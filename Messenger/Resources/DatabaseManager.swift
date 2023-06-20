//
//  DatabaseManager.swift
//  Messenger
//
//  Created by Артур Дохно on 19.03.2023.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
}

// MARK: - Account Management

extension DatabaseManager {
    
    /// Checking new user existence
    func userExists(with email: String, complection: @escaping (Bool) -> Void) {
        
        let safeEmail = email.replacingOccurrences(of: ".", with: "-")
        
        database.child(safeEmail).observeSingleEvent(of: .value) { snapsot in
            guard snapsot.value as? String != nil else {
                complection(false)
                return
            }
            
            complection(true)
        }
    }
    
    /// Insert new user to database
    func insertUser(with user: ChatAppUser, completion: @escaping (Bool) -> Void) {
        database.child(user.safeEmail).setValue([
            "first_name": user.firstName,
            "last_name": user.lastName
        ]) { error, _ in
            guard error == nil else {
                print("Запись в базу данных не удалась")
                completion(false)
                return
            }
            completion(true)
        }
    }
    
}
 
struct ChatAppUser {
    let firstName: String
    let lastName: String
    let emailAddress: String
    
    var safeEmail: String {
        let safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        return safeEmail
    }
    
    var profilePictureFileName: String {
        return "\(safeEmail)_profile_picture.png"
    }
}
