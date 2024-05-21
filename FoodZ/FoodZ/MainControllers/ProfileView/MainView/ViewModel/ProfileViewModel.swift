//
//  ProfileViewModel.swift
//  FoodZ
//
//  Created by surexnx on 21.04.2024.
//

import Foundation
import Combine

enum ProfileMainSection: Int {
    case header
    case body
    case exit
}
enum CellType: Hashable {
    case header(ProfileMainHeader)
    case body(ProfileMainBody)
}

struct ProfileMainHeader: Hashable, Decodable {
    var id: Int
    var username: String
    var imageId: Int?
    var number: String?
    var address: String

    init(username: String, nubmer: String, id: Int, imageId: Int?, address: String) {
        self.username = username
        self.number = nubmer
        self.id = id
        self.imageId = imageId
        self.address = address
    }
}
struct ProfileMainBody: Hashable {
    var cellName: String
    var cellImageName: String
}

protocol ProfileMainModeling: UIKitViewModel where State == ProfileMainState, Intent == ProfileMainIntent {}

final class ProfileViewModel: ProfileMainModeling {

    // MARK: Private properties

    private(set) var stateDidChange: ObservableObjectPublisher
    private var output: ProfileMainModuleOutput?
    private var headerItem: [CellType]
    private var repository: ProfileUserProtocol & UserExitProtocol
    private let displayDataMapper: DisplayDataMapper
    private var displayData: ProfileMainHeader?

    // MARK: Internal properties

    @Published var state: ProfileMainState {
        didSet {
            stateDidChange.send()
        }
    }

    // MARK: Initialization

    init(output: ProfileMainModuleOutput, repository: ProfileUserProtocol & UserExitProtocol) {
        self.stateDidChange = ObjectWillChangePublisher()
        self.output = output
        self.state = .loading
        self.headerItem = [
            .header(ProfileMainHeader(username: "User", nubmer: "+7 000 00000000", id: 0, imageId: nil, address: "Адрес готовки")),
            .body(ProfileMainBody(cellName: "Профиль", cellImageName: "person.fill")),
            .body(ProfileMainBody(cellName: "Адрессная книга", cellImageName: "mappin.and.ellipse")),
            .body(ProfileMainBody(cellName: "Методы оплаты", cellImageName: "creditcard.fill")),
            .body(ProfileMainBody(cellName: "Заказы", cellImageName: "menucard.fill")),
            .body(ProfileMainBody(cellName: "Настройка", cellImageName: "gearshape.fill")),
            .body(ProfileMainBody(cellName: "Help & FAQ", cellImageName: "questionmark.circle.fill")),
            .body(ProfileMainBody(cellName: "Выйти", cellImageName: "figure.walk.circle.fill"))]
        self.repository = repository
        self.displayDataMapper = DisplayDataMapper()

    }

    // MARK: Internal methods

    func trigger(_ intent: ProfileMainIntent) {
        switch intent {
        case .onDidLoad:
            output?.profileMainModuleDidLoad(input: self)
        case .onClose:
            break
        case .onReload:
            reloadHeader()
        case .processedTapItem(let index):
            processingItemTaped(index: index)
        case .proccesedUpdateAddress:
            proccesedUpdateAddress()
        case .onLoad:
            reloadHeader()
        }
    }

    // MARK: Private methods

    private func proccesedUpdateAddress() {
        repository.getUserAddress { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.displayData?.address = data.address
                guard let displayData = displayData else { return }
                headerItem[0] = .header(displayData)
                state = .content(headerItem)
            case .failure:
                break
            }
        }
    }

    private func processingItemTaped(index: Int) {
        switch index {
        case 0:
            output?.processedProfileItemTapped()
        case 1:
            output?.processedAddressBookItemTapped()
        case 2:
            output?.processedPaymentItemTapped()
        case 3:
            output?.processedOrderItemTapped()
        case 4:
            output?.processedSettingItemTapped()
        case 5:
            output?.processedHelpItemTapped()
        case 6:
            exitUser()
        default:
            break
        }
    }

    private func reloadHeader() {
        state = .loading
        repository.fetchUserInfo { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                displayData = displayDataMapper.dispayData(from: data)
                guard let displayData = displayData else { return }
                headerItem[0] = .header(displayData)
                state = .content(headerItem)
            case .failure:
                state = .error(headerItem)
            }
        }
    }

    private func exitUser() {
        repository.fetchUserExit()
        output?.processedExitItemTapped()
    }
}

extension ProfileViewModel: ProfileMainModuleInput {
    func proccessedUpdateAddress() {
        trigger(.proccesedUpdateAddress)
    }
}
