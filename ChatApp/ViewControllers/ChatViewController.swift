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
    
    
    public static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .long
        formatter.locale = .current
        return formatter
    }()
    public let otherEmail: String
    public var isNewConversation = false
    private var message = [Message]()

    
    private var selfSender : Sender? {
        guard let email = UserDefaults.standard.value(forKey: Constants.UserEmail) else {
            return nil
        }
        
        return Sender(senderId: email as! String,
               displayName: "Vaibhav",
               photo: "")
        
        
    }
    
    
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
        
        guard !text.replacingOccurrences(of: " ", with: "").isEmpty,
        let selfSender = self.selfSender,
        let messageID = createMessageID() else {
            return
        }
        
        
        
        debugPrint("Message \(text)")
        
        let message = Message(sender: selfSender,
                              messageId: messageID,
                              sentDate: Date(),
                              kind: .text(text))
        
        if isNewConversation {
            DataBaseManager.shared.createnewConversation(with: otherEmail, name: self.title ?? "User",
                                                         firstMessage: message){ result in
                
                if result {
                    debugPrint("Message Send")
                }else {
                    debugPrint("Message failed")
                }
                
            }
        }else{
            
        }
    }
    
    private func createMessageID() -> String?{
        //date, otherUserEmail, OwnEmail, randomInt
        let dateString = Self.dateFormatter.string(from: Date())
        guard let currentEmail = UserDefaults.standard.value(forKey: Constants.UserEmail) else {
            return ""
        }
        let otherSafeEmail = DataBaseManager.safeEmail(with: otherEmail as! String)
        let safeEmail = DataBaseManager.safeEmail(with: currentEmail as! String)
        let newIdentifier = "\(otherSafeEmail)_\(safeEmail)_\(dateString)"
        
        return newIdentifier
        
        
        
    }
}

extension ChatViewController : MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    
    
    var currentSender: any MessageKit.SenderType {
        if let sender = selfSender {
            return sender
        }
        return Sender(senderId: "",
                      displayName: "",
                      photo: "")
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessageKit.MessagesCollectionView) -> any MessageKit.MessageType {
        return message[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessageKit.MessagesCollectionView) -> Int {
        debugPrint(message.count)
        return message.count
    }
    
    
}
