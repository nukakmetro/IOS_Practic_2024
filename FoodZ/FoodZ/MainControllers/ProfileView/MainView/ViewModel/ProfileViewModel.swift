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
    var image: String?
    var number: String?

    init(username: String, nubmer: String, id: Int, image: String) {
        self.username = username
        self.number = nubmer
        self.id = id
        self.image = image
    }
}
struct ProfileMainBody: Hashable {
    var cellName: String
    var cellImageName: String

    init(cellName: String, cellImageName: String) {
        self.cellName = cellName
        self.cellImageName = cellImageName
    }
}

protocol ProfileMainModeling: UIKitViewModel where State == ProfileMainState, Intent == ProfileMainIntent {}

final class ProfileViewModel: ProfileMainModeling {

    // MARK: Private properties

    private(set) var stateDidChange: ObservableObjectPublisher
    private var output: ProfileMainModuleOutput?
    private var headerItem: [CellType]
    private var repository: ProfileUserProtocol & UserExitProtocol
    private let displayDataMapper: DisplayDataMapper

    // MARK: Internal properties

    @Published var state: ProfileMainState {
        didSet {
            stateDidChange.send()
        }
    }

    // MARK: Initializator

    init(output: ProfileMainModuleOutput, repository: ProfileUserProtocol & UserExitProtocol) {
        self.stateDidChange = ObjectWillChangePublisher()
        self.output = output
        self.state = .loading
        self.headerItem = [
            .header(ProfileMainHeader(username: "User", nubmer: "+7 000 00000000", id: 0, image: "person")),
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
            state = .loading
            reloadHeader()
        case .onClose:
            break
        case .onReload:
            state = .loading
            reloadHeader()
        case .processedTapItem(let index):
            processingItemTaped(index: index)
        }
    }

    // MARK: Private methods

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
        repository.fetchUserInfo { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                headerItem[0] = .header(displayDataMapper.dispayData(from: data))
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
