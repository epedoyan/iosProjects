//
//  MainVC.swift
//  InommaTask
//
//  Created by Codefights on 2/7/17.
//  Copyright © 2017 Codefights. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class MainVC: UIViewController, UITableViewDataSource, UITableViewDelegate, FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var userListTableView: UITableView!
    @IBOutlet weak var topView: UIView!
    
    let loginButton = FBSDKLoginButton()
    var usersArray = [NSDictionary]()
    var loggedInUserId: String!
    var loggedInUserDisplayName: String!
    var chatVC : ChatVC!
    var chatRow: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLoginButton()
        FireBase.shared.fetchUsersInfoFromDB() { (result) in
            self.usersArray = result
            self.userListTableView.reloadData()
        }
        if Facebook().hasUserLoggedIn() {
            getLoggedInUserInfoFromFacebook()
            userListTableView.isHidden = false
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        loginButton.center.x = topView.frame.size.width  / 2;
        loginButton.center.y = topView.frame.size.height / 2;
    }
  
    private func configureLoginButton() {
        loginButton.loginBehavior = .web
        loginButton.readPermissions = ["public_profile"]
        loginButton.delegate = self
        topView.addSubview(loginButton)
    }
    
    private func getLoggedInUserInfoFromFacebook() {
        Facebook().fetchLoggedInUserInfo() { (userId, displayName) in
            self.loggedInUserId = userId
            self.loggedInUserDisplayName = displayName
        }
    }
 
    // MARK: - FBSDKLoginButtonDelegate
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if let error = error {
            print("Error: \(error.localizedDescription)")
            return
        }
        if Facebook().hasUserLoggedIn() {
            getLoggedInUserInfoFromFacebook()
            userListTableView.isHidden = false
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        FBSDKLoginManager().logOut()
        self.userListTableView.isHidden = true
    }
    
    // MARK: - Table view data source, delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userCell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! UserCell
        
        let firstName = usersArray[indexPath.row]["firstName"] as! String
        let lastName = usersArray[indexPath.row]["lastName"] as! String
        let pictureUrl = usersArray[indexPath.row]["picture"] as! String
        userCell.fullname.text = firstName + " " + lastName
        ImagesManager().downloadImages(pictureUrl) { (image) in
            userCell.picture.image = image
            if (self.chatVC != nil) && self.chatRow == indexPath.row {
                self.chatVC.chatMemberAvatar = userCell.picture.image
                self.chatVC.collectionView.reloadData()
            }
        }
        return userCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chatRow = indexPath.row
        chatVC = storyboard?.instantiateViewController(withIdentifier: "chatVC") as! ChatVC
        chatVC.senderId = loggedInUserId
        chatVC.senderDisplayName = loggedInUserDisplayName
        chatVC.chatMemberId = usersArray[indexPath.row]["id"] as! String
        chatVC.chatMemberDisplayName = usersArray[indexPath.row]["firstName"] as! String
        chatVC.chatMemberAvatar = (tableView.cellForRow(at: indexPath) as! UserCell).picture.image
        navigationController?.pushViewController(chatVC, animated: true)
    }
}
