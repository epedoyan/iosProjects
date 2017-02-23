//
//  ChatVC.swift
//  InommaTask
//
//  Created by Codefights on 2/20/17.
//  Copyright © 2017 Codefights. All rights reserved.
//

import UIKit
import Firebase
import JSQMessagesViewController

class ChatVC: JSQMessagesViewController {
    
    var chatMemberId: String!
    var chatMemberDisplayName: String!
    var chatMemberAvatar: UIImage!
    var messages = [JSQMessage]()
    
    lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setupOutgoingBubble()
    lazy var incomingBubbleImageView: JSQMessagesBubbleImage = self.setupIncomingBubble()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        getMessages()
    }

    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        let chatName = makeUniqueChatNameFor(senderId, chatMemberId)
        let message = ["senderId": senderId!, "senderName": senderDisplayName!, "text": text!]
        FireBase.shared.saveMessageInfoToDB(message, withChatName: chatName)
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        finishSendingMessage()
    }
    
    override func didPressAccessoryButton(_ sender: UIButton!) {
        //
    }
    
    // MARK : - JSQMessagesCollectionViewDataSource protocol methods
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        let message = messages[indexPath.item]
        if chatMemberAvatar == nil {
            return nil
        }
        return message.senderId == senderId ? nil : JSQMessagesAvatarImageFactory.avatarImage(with: chatMemberAvatar, diameter: 15)
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item]
        return message.senderId == senderId ? outgoingBubbleImageView : incomingBubbleImageView
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        let message = messages[indexPath.item]
        cell.textView?.textColor = message.senderId == senderId ? UIColor.white : UIColor.black
        return cell
    }

    // MARK: - private functions
    
    private func makeUniqueChatNameFor(_ senderID: String, _ chatMemberId: String) -> String {
        return senderID < chatMemberId ? senderID + "-" + chatMemberId : chatMemberId + "-" + senderId
    }
    
    private func addMessage(withId id: String, name: String, text: String) {
        if let message = JSQMessage(senderId: id, displayName: name, text: text) {
            messages.append(message)
        }
    }
    
    private func getMessages() {
        let chatName = makeUniqueChatNameFor(senderId, chatMemberId)
        FireBase.shared.fetchChatHistoryFromDB(chatName: chatName) { (id, name, text) in
            self.addMessage(withId: id, name: name, text: text)
            self.finishReceivingMessage()
        }
    }
    
    // message bubble colors
    
    private func setupOutgoingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
    }
    
    private func setupIncomingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    }
}
