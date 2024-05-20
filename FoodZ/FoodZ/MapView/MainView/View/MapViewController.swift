//
//  MapViewController.swift
//  FoodZ
//
//  Created by surexnx on 19.05.2024.
//

import Combine
import UIKit
import MapKit
import SnapKit

final class MapViewController<ViewModel: MapViewModeling>: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    // MARK: Private properties

    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.showsUserLocation = true
        mapView.delegate = self
        return mapView
    }()

    private var locationManager: CLLocationManager?
    private let viewModel: ViewModel
    private var cancellables: Set<AnyCancellable> = []
    private lazy var backButton = UIButton()

    // MARK: Initialization

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        self.locationManager = CLLocationManager()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocationManager()
        setupDisplay()
        makeContstraint()
        configureIO()
        viewModel.trigger(.onDidLoad)
        navigationController?.isNavigationBarHidden = true

    }

    // MARK: Private methods

    private func makeContstraint() {
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.equalToSuperview().inset(30)
        }
        mapView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }

    private func configureIO() {
        viewModel
            .stateDidChange
            .sink { [weak self] _ in
                self?.render()
            }
            .store(in: &cancellables)
    }

    private func render() {
        switch viewModel.state {
        case .loading:
            break
        case .content(let dispayData):
            for data in dispayData {
                mapView.addAnnotation(data)
            }
        case .error:
            break
        }
    }

    private func checkAuthorization() {
        guard let locationManager = locationManager,
              let location = locationManager.location
        else { return }

        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            break
        case .denied:
              showAlert(title: "Выключено местоположени", message: "Включить,", url: URL(string: UIApplication.openSettingsURLString))
        case .authorizedAlways, .authorizedWhenInUse:
            let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 2500, longitudinalMeters: 2500)
            mapView.setRegion(region, animated: true)

        @unknown default:
            break
        }
    }

    private func showAlert(title: String, message: String?, url: URL?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let settingAction = UIAlertAction(title: "Настройки", style: .default ) { [weak self] _ in
            if let url = url {
                UIApplication.shared.open(url, options: [:])
            }
        }
        let cancelAction = UIAlertAction(title: "Отмены", style: .cancel)
        alert.addAction(settingAction)
        alert.addAction(cancelAction)
        present(alert, animated: false)
    }

    private func setupDisplay() {
        let backButtonAction = UIAction { [weak self] _ in
            self?.viewModel.trigger(.proccesedTappedButtonBack)
        }
        backButton.configuration = UIButton.Configuration.plain()
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        backButton.addAction(backButtonAction, for: .touchUpInside)
        backButton.backgroundColor = AppColor.background.color
        backButton.setTitleColor(AppColor.title.color, for: .normal)
        backButton.clipsToBounds = true
        let width = view.frame.width / 10
        backButton.frame = CGRect(origin: .zero, size: CGSize(width: width, height: width))
        backButton.layer.cornerRadius = width / 2

    }

    private func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self

        locationManager?.requestWhenInUseAuthorization()
        locationManager?.requestAlwaysAuthorization()
        locationManager?.requestLocation()
    }

    // MARK: - CLLocationManagerDelegate

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkAuthorization()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }

    // MARK: - MKMapViewDelegate

    func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
        guard let pickUpPointAnnotation = annotation as? PickUpPointAnnotation else { return }
        viewModel.trigger(.proccesedTappedAnnotation(pickUpPointId: pickUpPointAnnotation.id))
    }
}

