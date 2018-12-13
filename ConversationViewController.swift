//
//  ConversationViewController.swift
//  zhiyouios
//
//  Created by Yun Fei Guo on 2018-11-30.
//  Copyright © 2018 Yun Fei Guo. All rights reserved.
//

import UIKit
import MessageKit
import MessageInputBar

class ConversationViewController: MessagesViewController {
    
    var connectionPersonId: String!
    var connection: Member! = Member()
    var messages: [Message] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        connection.color = .blue
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messageInputBar.delegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        if SYSTEM_VERSION_LESS_THAN(version: "11.0") {
            self.messagesCollectionView.contentInset = UIEdgeInsets(top: 89, left: 0, bottom: 0, right: 10)
        } else {
            self.messagesCollectionView.contentInset = UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 10)
        }
        
        setUpNavBar()
    }

    func setUpNavBar() {
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 45, width: UIScreen.main.bounds.width, height: 44))
        self.view.addSubview(navBar)
        navBar.items?.append(UINavigationItem(title: "Essence"))
        let backButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(onCancel))
        navBar.topItem?.leftBarButtonItem = backButton
    }
    
    @objc func onCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    func SYSTEM_VERSION_LESS_THAN(version: String) -> Bool {
        return UIDevice.current.systemVersion.compare(
            version,
            options: NSString.CompareOptions.numeric
            ) == ComparisonResult.orderedAscending
    }
}

extension ConversationViewController: MessagesDataSource {
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func currentSender() -> Sender {
        return Sender(id: connection.name, displayName: connection.name)
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 12
    }
    
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        return NSAttributedString(string: message.sender.displayName, attributes: [.font: UIFont.systemFont(ofSize: 12)])
    }
}

extension ConversationViewController: MessagesLayoutDelegate {
    func heightForLocation(message: MessageType,
                           at indexPath: IndexPath,
                           with maxWidth: CGFloat,
                           in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 0
    }
}

extension ConversationViewController: MessagesDisplayDelegate {
    func configureAvatarView(
        _ avatarView: AvatarView,
        for message: MessageType,
        at indexPath: IndexPath,
        in messagesCollectionView: MessagesCollectionView) {
        
        let message = messages[indexPath.section]
        let color = message.member.color
        avatarView.backgroundColor = color
    }
}

extension ConversationViewController: MessageInputBarDelegate {
    func messageInputBar(
        _ inputBar: MessageInputBar,
        didPressSendButtonWith text: String) {
        
        let newMessage = Message(
            member: connection,
            text: text,
            messageId: UUID().uuidString)
        
        messages.append(newMessage)
        inputBar.inputTextView.text = ""
        messagesCollectionView.reloadData()
        messagesCollectionView.scrollToBottom(animated: true)
    }
}
