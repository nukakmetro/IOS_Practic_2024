//
//  DisplayDataMapper.swift
//  FoodZ
//
//  Created by surexnx on 24.04.2024.
//

import Foundation

final class DisplayDataMapper {
    func dispayData(from dataModel: UserInfoModel) -> ProfileMainHeader {
        return ProfileMainHeader(
            username: dataModel.username,
            nubmer: dataModel.number ?? "Номер телефона",
            id: dataModel.id,
            image: String(dataModel.image ?? 0)
        )
    }
}
