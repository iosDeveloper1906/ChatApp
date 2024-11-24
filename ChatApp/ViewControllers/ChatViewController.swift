//
//  ChatViewController.swift
//  ChatApp
//
//  Created by Vaibhav Gawde on 24/11/24.
//

import UIKit
import MessageKit



class ChatViewController: MessagesViewController{
    
    private var message = [Message]()
    private var sender = Sender(senderId: "1",
                                displayName: "Vaibhav",
                                photo: "")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
       
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        message.append(Message(sender: sender,
                               messageId: "1",
                               sentDate: Date(),
                               kind: .text("Hello Vaibhav")))
        
        message.append(Message(sender: sender,
                               messageId: "1",
                               sentDate: Date(),
                               kind: .text("Common your doing great keep it up")))
        
        messagesCollectionView.reloadData()
    }
    
}

extension ChatViewController : MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    
    
    var currentSender: any MessageKit.SenderType {
        return sender
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessageKit.MessagesCollectionView) -> any MessageKit.MessageType {
        return message[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessageKit.MessagesCollectionView) -> Int {
        debugPrint(message.count)
        return message.count
    }
    
    
}
