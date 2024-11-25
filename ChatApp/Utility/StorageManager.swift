//
//  StorageManager.swift
//  ChatApp
//
//  Created by Vaibhav Gawde on 24/11/24.
//

import Foundation
import FirebaseStorage

final class StorageManager {
    
    
    static let shared = StorageManager()
    
    private let storage = Storage.storage().reference()
    
    public func uploadProfilePic(with data: Data,fileName: String, completion: @escaping ( (Result<String, Error>) -> Void)){
        
        storage.child("image/\(fileName)").putData(data, metadata: nil) { metadata, error in
            
            guard error == nil else {
                completion(.failure(storageError.failedUploadFile))
                return
            }
            
            self.storage.child("image/\(fileName)").downloadURL { url, error in
                
                guard let url = url else{
                    completion(.failure(storageError.failedToDownloadURL))
                    return
                }
                
                let urlString = url.absoluteString
                debugPrint(urlString)
                completion(.success(urlString))
            }
        }
        
    }
    
    public func downloadURL(with path: String, completion : @escaping (Result<URL,Error>) -> Void ) {
        
        let reference = storage.child(path)
        reference.downloadURL { url, error in
            
            guard let url = url, error == nil else {
                completion(.failure(storageError.failedToDownloadURL))
                return
            }
            
            completion(.success(url))
            
        }
        
    }
    
    
    enum storageError : Error {
        case failedUploadFile
        case failedToDownloadURL
    }
}
