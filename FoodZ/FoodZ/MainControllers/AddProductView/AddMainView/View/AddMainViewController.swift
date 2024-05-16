//
//  SelfProductViewController.swift
//  FoodZ
//
//  Created by surexnx on 04.05.2024.
//

import UIKit
import Combine
import SnapKit

protocol AddMainViewControllerConfiguration: UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate {}

final class AddMainViewController<ViewModel: AddMainViewModel>: UIViewController, AddMainViewControllerConfiguration {

    // MARK: Private properties

    private let viewModel: ViewModel
    private var cancellables: Set<AnyCancellable> = []
    private let items: [String]
    private lazy var segmentControl = UISegmentedControl(items: items)
    private var viewControllers: [UIViewController]
    private var currentPageIndex: Int
    private lazy var pageController: UIPageViewController = {
        return UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }()
    private lazy var createButton = UIButton()

    // MARK: Initialization

    init( viewModel: ViewModel, viewControllers: [UIViewController]) {
        self.viewModel = viewModel
        self.viewControllers = viewControllers
        items = ["Черновики", "Архивы"]
        self.currentPageIndex = 0
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        makeConstraint()
        setupSegmentControl()
        setupPageController()
        setupButton()
        view.backgroundColor = AppColor.background.color
        navigationItem.title = "Мои Объявления"
        navigationItem.titleView?.backgroundColor = AppColor.primary.color
        navigationController?.isNavigationBarHidden = false
    }

    // MARK: Private methods

    private func setupSegmentControl() {
        segmentControl.selectedSegmentIndex = 0
        segmentControl.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 30)
        segmentControl.addUnderlineForSelectedSegment()
        segmentControl.addTarget(self, action: #selector(changeSegment(_:)), for: .valueChanged)
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupPageController() {
        pageController.delegate = self
        pageController.dataSource = self
        pageController.setViewControllers(
            [viewControllers[currentPageIndex]],
            direction: .forward,
            animated: false
        )
    }

    private func setupButton () {
        let action = UIAction { [weak self] _ in
            guard let self = self else { return }
            viewModel.trigger(.proccesedTappedCreateProduct)
        }
        createButton.addAction(action, for: .touchUpInside)
        createButton.setTitle("Добавить продукт", for: .normal)
        createButton.backgroundColor = .blue
        createButton.translatesAutoresizingMaskIntoConstraints = false
    }

    @objc private func changeSegment(_ sender: UISegmentedControl) {
        segmentControl.changeUnderlinePosition()
        segmentControl.isEnabled = false
        let index = sender.selectedSegmentIndex
        if currentPageIndex < index {
            pageController.setViewControllers(
                [self.viewControllers[index]],
                direction: .forward, animated: true,
                completion: { [weak self] isFinished in
                self?.segmentControl.isEnabled = isFinished
            })
        } else {
            pageController.setViewControllers(
                [self.viewControllers[index]],
                direction: .reverse, animated: true,
                completion: { [weak self] isFinished in
                self?.segmentControl.isEnabled = isFinished
            })
        }
        currentPageIndex = index
    }

    private func makeConstraint() {
        addChild(pageController)
        view.addSubview(pageController.view)
        view.addSubview(segmentControl)
        view.addSubview(createButton)

        segmentControl.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
        }
        pageController.view.snp.makeConstraints { make in
            make.top.equalTo(segmentControl.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }

        createButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(30)
        }
    }

    // MARK: - UIPageViewControllerDataSource

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        currentPageIndex = viewController.view.tag
        segmentControl.selectedSegmentIndex = currentPageIndex
        for subviews in pageController.view.subviews {
            if let scrollView = subviews as? UIScrollView {
                scrollView.delegate = self
            }
        }
        let pageIndex = viewController.view.tag - 1
        if pageIndex < 0 {
            return nil
        }
        return viewControllers[pageIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        currentPageIndex = viewController.view.tag
        segmentControl.selectedSegmentIndex = currentPageIndex
        let pageIndex = viewController.view.tag + 1
        if pageIndex > 1 {
            return nil
        }
        return viewControllers[pageIndex]
    }

    // MARK: - UIPageViewControllerDelegate

    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool) {
        segmentControl.isEnabled = true
    }

    // MARK: - UIScrollViewDelegate

    var lastContentOffset: CGFloat = 0

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        lastContentOffset = scrollView.contentOffset.x
        print(lastContentOffset)
    }
}
