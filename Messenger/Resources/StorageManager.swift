//
//  StorageManager.swift
//  Messenger
//
//  Created by Артур Дохно on 10.04.2023.
//

import Foundation
import FirebaseStorage

final class StorageManager {
    
    static let shared = StorageManager()
    
    private let storage = Storage.storage().reference()
    
    ///  Загружаем изображение в базу данных и получаем строку с URL для загрузки
    func uploadProfilePicture(with data: Data, fileName: String, completion: @escaping(Result<String, Error>) -> Void) {
        storage.child("images/\(fileName)").putData(data) { metadata, error in
            guard error == nil else {
                print("Не удалось загрузить данные Firebase для изображения")
                completion(.failure(StorageError.failedToUpload))
                return
            }
        }
        
        self.storage.child("images/\(fileName)").downloadURL(completion: { url, error in
            guard let url = url else {
                print("Не удалось получить Url адрес загрузки")
                completion(.failure(StorageError.failedToGetDownloadUrl))
                return
            }
            
            let urlString = url.absoluteString
            print("Загруженый url: \(urlString)")
            completion(.success(urlString))
        })
    }
    
    
    public enum StorageError: Error{
        case failedToUpload
        case failedToGetDownloadUrl
    }
    
}
