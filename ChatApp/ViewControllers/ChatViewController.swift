//
//  ChatViewController.swift
//  ChatApp
//
//  Created by Vaibhav Gawde on 24/11/24.
//

import UIKit
import MessageKit
import InputBarAccessoryView



class ChatViewController: MessagesViewController{
    
    public let otherEmail: String
    public var isNewConversation = false
    private var message = [Message]()
    private var sender = Sender(senderId: "1",
                                displayName: "Vaibhav",
                                photo: "")
    
    
    init(with email: String){
        self.otherEmail = email
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
       
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
            
        messagesCollectionView.reloadData()
    }
    
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        messageInputBar.inputTextView.becomeFirstResponder()
    }
    
}

extension ChatViewController : InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        
        guard !text.replacingOccurrences(of: " ", with: "").isEmpty else {
            return
        }
        
        debugPrint("Message \(text)")
        
        if isNewConversation {
            
        }else{
            
        }
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
