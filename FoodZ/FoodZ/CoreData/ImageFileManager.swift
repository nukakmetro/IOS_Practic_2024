//
//  ImageFileManager.swift
//  FoodZ
//
//  Created by surexnx on 07.05.2024.
//

import Foundation

final class ImageFileManager {

    // MARK: Private properties

    private let documentsDirectory: URL

    // MARK: Initialization

    init(documentsDirectory: URL) {
        self.documentsDirectory = documentsDirectory
    }

    // MARK: Internal methods

    func writeImage(id: UUID, image: Data) {
        let fileName = "\(id).png"
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        do {
            try image.write(to: fileURL)
        } catch {
            print("Ошибка при сохранении изображения: \(error.localizedDescription)")
        }
    }

    func removeImage(id: UUID) {
        let fileName = "\(id).png"
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        do {
            try FileManager.default.removeItem(at: fileURL)
        } catch {
            print("Ошибка при удалении файла: \(error.localizedDescription)")
        }
    }

    func fetchImage(id: UUID) -> Data? {
        let fileName = "\(id).png"
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        guard let imageData = try? Data(contentsOf: fileURL) else { return nil }
        return imageData
    }
}
