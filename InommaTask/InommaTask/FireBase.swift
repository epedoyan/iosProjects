//
//  FireBase.swift
//  InommaTask
//
//  Created by Codefights on 2/8/17.
//  Copyright © 2017 Codefights. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class FireBase: NSObject {
    
    static let shared = FireBase()
    
    let databaseRef = FIRDatabase.database().reference()
    
    func fetchUsersInfoFromDB(completionHandler: @escaping ([NSDictionary]) -> Void) {
        databaseRef.child("users").observe(.value, with: { (snapshot) in
            let usersDictionary = snapshot.value as! NSDictionary
            let usersArray = usersDictionary.allValues as! [NSMutableDictionary]
            for (index, item) in usersDictionary.allKeys.enumerated() {
                usersArray[index]["id"] = item
            }
            completionHandler(usersArray)
        })
    }
    
    func fetchChatHistoryFromDB(chatName: String, completionHandler: @escaping (String, String, String) -> Void) {
        databaseRef.child("chats").child(chatName).observe(.childAdded, with: { (snapshot) in
            let messageData = snapshot.value as! Dictionary<String, String>
            
            if let id = messageData["senderId"] as String!, let name = messageData["senderName"] as String!, let text = messageData["text"] as String!, text.characters.count > 0 {
                completionHandler(id, name, text)
            } else {
                print("Error! Could not decode message data")
            }
        })
    }
    
    func saveLoggedInUserInfoToDB(_ userInfo: NSDictionary) {
        guard let firstname = userInfo["first_name"] as? String,
            let lastname = userInfo["last_name"] as? String, let id = userInfo["id"] as? String else { return }
        
        if let picture = userInfo["picture"] as? NSDictionary, let data = picture["data"] as? NSDictionary, let imageURL = data["url"] {
            FIRDatabase.database().reference().child("users").child(id).setValue(["firstName": firstname, "lastName": lastname, "picture": imageURL])
        }
    }
    
    func saveMessageInfoToDB(_ message: [String:String], withChatName chatName: String) {
        databaseRef.child("chats").child(chatName).childByAutoId().setValue(message)
    }
}
