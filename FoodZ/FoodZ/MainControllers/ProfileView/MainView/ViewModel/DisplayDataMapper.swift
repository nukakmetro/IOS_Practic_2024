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
            id: dataModel.userId ?? 0,
            image: String(dataModel.imageId ?? 0)
        )
    }
}
