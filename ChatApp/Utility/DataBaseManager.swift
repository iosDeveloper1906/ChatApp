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


extension DataBaseManager {
    
    /// new conversation for particular user
    public func createnewConversation(with otherUserEmail: String,name: String,firstMessage: Message, completion: @escaping (Bool) -> Void){
        
        guard let currentUser = UserDefaults.standard.value(forKey: Constants.UserEmail) as? String else {
            return
        }
        
        let safeEmail = DataBaseManager.safeEmail(with: currentUser)
        
        database.child(safeEmail).observeSingleEvent(of: .value) { data,_   in
            guard var userNode = data.value as? [String: Any] else {
                completion(false)
                return
            }
            
            let messageDate = firstMessage.sentDate
            let dateString = ChatViewController.dateFormatter.string(from: messageDate)
            var message = ""
            switch firstMessage.kind {
                
            case .text(let messageText):
                message = messageText
            case .attributedText(_):
                break
            case .photo(_):
                break
            case .video(_):
                break
            case .location(_):
                break
            case .emoji(_):
                break
            case .audio(_):
                break
            case .contact(_):
                break
            case .linkPreview(_):
                break
            case .custom(_):
                break
            }
            
            let conversationID = "conversation_\(firstMessage.messageId)"
            
            let newConversation = [
                "ID": conversationID,
                "otherUserEmail":otherUserEmail,
                "name":name,
                "latestMessage": [
                    "date":dateString,
                    "message":message,
                    "isRead": false,
                    
                ]
            
            ]
            
            if var conversation = userNode["conversation"] as? [[String:Any]]{
                
                conversation.append(newConversation)
                userNode["conversation"] = [
                    conversation
                ]
                
                self.database.child(safeEmail).setValue(userNode) { [weak self]error, _ in
                    guard error == nil else{
                        completion(false)
                        return
                    }
                    
            
                    
                    self?.finishCreateConversation(with: conversationID, firstMessage: firstMessage, name: name, completion: completion)
                }
                
                
            }else {
                userNode["conversation"] = [
                    newConversation
                ]
                
                self.database.child(safeEmail).setValue(userNode) { [weak self]error, _ in
                    guard error == nil else{
                        completion(false)
                        return
                    }
                    
                    self?.finishCreateConversation(with: conversationID, firstMessage: firstMessage, name: name, completion: completion)
                   
                    
                }
            }
            
        }
        
            
        
    }
    
    /// all te conversation of the curret login
    public func getAllConversation(for email: String, completion: @escaping (Result<String,Error>) -> Void ){
        
    }
    
    /// get all message of the particular conversation
    public func getAllMessageForConversation(with id: String, completion: @escaping(Result<String, Error>) -> Void){
        
    }
    
    /// send message in the conversation
    public func sendMessage(to conversation: String, message: Message, completion: @escaping( (Bool) -> Void )){
        
    }
    
    private func finishCreateConversation(with conversationID: String,firstMessage: Message,name: String ,completion: @escaping (Bool) -> Void ){
        
        var message = ""
        switch firstMessage.kind {
            
        case .text(let messageText):
            message = messageText
        case .attributedText(_):
            break
        case .photo(_):
            break
        case .video(_):
            break
        case .location(_):
            break
        case .emoji(_):
            break
        case .audio(_):
            break
        case .contact(_):
            break
        case .linkPreview(_):
            break
        case .custom(_):
            break
        }
        
        let messageDate = firstMessage.sentDate
        let dateString = ChatViewController.dateFormatter.string(from: messageDate)
        
        guard let currentUser = UserDefaults.standard.value(forKey: Constants.UserEmail) as? String else {
            return
        }
        
        let safeEmail = DataBaseManager.safeEmail(with: currentUser)
        
        
        let collectionMessage : [String: Any] = [
            "id":firstMessage.messageId,
            "type":firstMessage.kind.messagekindString,
            "content":message,
            "date":dateString,
            "name":name,
            "sender_email":safeEmail,
            "is_read":false
        
        ]
        let value : [String:Any] = [
            "message": [
                collectionMessage
            ]
        ]
        
        database.child(conversationID).setValue(value) { error, _ in
            guard error == nil else{
                completion(false)
                return
            }
            
            completion(true)
        }
        
    }
    
    
}
