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
        
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        
        database.child(safeEmail).observeSingleEvent(of: .value) { snapsot in
            guard snapsot.value as? String != nil else {
                complection(false)
                return
            }
            
            complection(true)
        }
    }
    
    /// Insert new user to database
    func insertUser(with user: ChatAppUser) {
        database.child(user.safeEmail).setValue([
            "first_name": user.firstName,
            "last_name": user.lastName
        ])
    }
    
}
 
struct ChatAppUser {
    let firstName: String
    let lastName: String
    let emailAddress: String
    
    var safeEmail: String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        return safeEmail
    }
//    let profilePictureUrl: String
}
