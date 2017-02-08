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
    
    func readFromFireBaseDB(completionHandler: @escaping ([NSDictionary]) -> Void) {
        FIRDatabase.database().reference().child("users").observe(.value, with: { (snapshot) in
            let usersDictionary = snapshot.value as! NSDictionary
            let usersArray = usersDictionary.allValues as! [NSDictionary]
            completionHandler(usersArray)
        })
    }
    
    func writeToFireBaseDB(_ result : NSDictionary) {
        guard let firstname = result["first_name"] as? String,
            let lastname = result["last_name"] as? String, let id = result["id"] as? String else { return }
        
        if let picture = result["picture"] as? NSDictionary, let data = picture["data"] as? NSDictionary, let imageURL = data["url"] {
            FIRDatabase.database().reference().child("users").child(id).setValue(["firstName": firstname, "lastName": lastname, "picture": imageURL])
        }
    }
}
