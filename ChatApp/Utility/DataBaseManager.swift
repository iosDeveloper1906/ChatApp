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
    
    static func safeEmail(with emailAddress: String) -> String{
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        
        return safeEmail
    }
    
    
    public func insertUser(with user: User, completion: @escaping ( (Bool) -> Void) ){
        
        database.child(user.safeEmail).setValue([
            "first_name": user.firstName ?? "",
            "last_name": user.lastName ?? ""
        ]) { error, _ in
            guard error == nil else {
                completion(false)
                return
            }
            
            self.database.child("users").observeSingleEvent(of: .value) { snapShot, _  in
                
                if var userCollection = snapShot.value as? [[String: String]]{
                    
                    let newCollection = [
                        [
                            "name": (user.firstName ?? "") + " " + (user.lastName ?? ""),
                            "email": user.emailID ?? ""
                        ]
                    
                    ]
                    
                    userCollection.append(contentsOf: newCollection)
                    self.database.child("users").setValue(userCollection) { error, _ in
                        guard error == nil else {
                            completion(false)
                            return
                        }
                        
                        completion(true)
                    }
                    
                    
                }else {
                    let newCollection: [[String: String]] = [
                        [
                            "name": (user.firstName ?? "") + " " + (user.lastName ?? ""),
                            "email": user.emailID ?? ""
                        ]
                    
                    ]
                    
                    self.database.child("users").setValue(newCollection) { error, _ in
                        guard error == nil else {
                            completion(false)
                            return
                        }
                        
                        completion(true)
                    }
                }
            }
            
        }
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
    
    public func fetchUsers(completion: @escaping ( Result<[[String: String]], Error> ) -> Void){
        
        database.child("users").observeSingleEvent(of: .value) { snapShot in
            
            guard let value = snapShot.value as? [[String:String]] else {
                
                completion(.failure(DataBaseError.failedToFetch))
                return
            }
            
            completion(.success(value))
        }
        
    }
    
    
    public enum DataBaseError : Error {
        case failedToFetch
    }
    
}
