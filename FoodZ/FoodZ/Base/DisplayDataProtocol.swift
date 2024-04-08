//
//  DisplayData.swift
//  FoodZ
//
//  Created by surexnx on 05.04.2024.
//

import Foundation
import Combine

protocol DisplayDataProtocol: ObservableObject {

    var sections: [Section] { get }
    var sectionsDidChange: PassthroughSubject<[Section], Never> { get }
}
