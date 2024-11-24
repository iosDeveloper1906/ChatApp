//
//  MessageModel.swift
//  ChatApp
//
//  Created by Vaibhav Gawde on 24/11/24.
//

import Foundation
import MessageKit

struct Message : MessageType {
    var sender: any MessageKit.SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKit.MessageKind
    
    
}
