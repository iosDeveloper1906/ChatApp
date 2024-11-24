//
//  UserModel.swift
//  ChatApp
//
//  Created by Vaibhav Gawde on 23/11/24.
//

import Foundation


struct User {
    
    let firstName: String?
    let lastName: String?
    let emailID: String?
    
    init(firstName: String?, lastName: String?, emailID: String?) {
        self.firstName = firstName
        self.lastName = lastName
        self.emailID = emailID
    }
    
    var safeEmail: String  {
        var safeEmail = emailID?.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail?.replacingOccurrences(of: "@", with: "-")
        return safeEmail ?? ""
    }
}
