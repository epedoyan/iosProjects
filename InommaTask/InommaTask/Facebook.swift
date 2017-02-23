//
//  Facebook.swift
//  InommaTask
//
//  Created by Codefights on 2/8/17.
//  Copyright © 2017 Codefights. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

struct Facebook {
    
    func hasUserLoggedIn() -> Bool {
        return (FBSDKAccessToken.current() != nil)
    }
    
    func fetchLoggedInUserInfo(_ completionHandler:@escaping (String, String) -> Void) {
        
        let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "id, first_name, last_name, picture.type(normal)"])
        _ = graphRequest?.start(completionHandler: { (connection, result, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            } else
            {
                guard let result = result as? NSDictionary else { return }
                FireBase.shared.saveLoggedInUserInfoToDB(result)
                completionHandler(result["id"] as! String, result["first_name"] as! String)
            }
        })
    }
    
}
