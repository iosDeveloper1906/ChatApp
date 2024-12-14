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


extension MessageKind {
    
    var messagekindString: String {
        switch self {
        case .text(let string):
            return "text"
        case .attributedText(let nSAttributedString):
            return "attributed"
        case .photo(let mediaItem):
            return "photo"
        case .video(let mediaItem):
            return "video"
        case .location(let locationItem):
            return "location"
        case .emoji(let string):
            return "emoji"
        case .audio(let audioItem):
            return "audio"
        case .contact(let contactItem):
            return "contact"
        case .linkPreview(let linkItem):
            return "link"
        case .custom(let any):
            return "custom"
        }
    }
}
