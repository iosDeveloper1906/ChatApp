//
//  DataBaseManager.swift
//  ChatApp
//
//  Created by Vaibhav Gawde on 23/11/24.
//

import Foundation
import FirebaseDatabase

final class DataBaseManager {
    
    static let shared = DataBaseManager()
    
    private let database = Database.database().reference()
    
    
    public func insertUser(with user: User){
        
        database.child(user.safeEmail ?? "").setValue([
            "first_name": user.firstName ?? "",
            "last_name": user.lastName ?? ""
        ])
    }
    
    public func validateEmail(with email: String, completion : @escaping( (Bool) -> Void)){
        
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        
        
        database.child(safeEmail).observeSingleEvent(of: .value) { snapShot in
            
            guard snapShot.value as? String != nil else {
                completion(false)
                return
            }
            
            completion(true)
        }
    }
    
}
