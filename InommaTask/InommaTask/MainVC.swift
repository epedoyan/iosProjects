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

class MainVC: UIViewController, UITableViewDataSource, FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var userListTableView: UITableView!
    @IBOutlet weak var topView: UIView!
    
    let loginButton = FBSDKLoginButton()
    var usersArray = [NSDictionary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLoginButton()
        FireBase.shared.readFromFireBaseDB { (result) in
            self.usersArray = result
            self.userListTableView.reloadData()
        }
        
        if Facebook.shared.userLoggedIn() {
            userListTableView.isHidden = false
            Facebook.shared.fetchLoggedInUserInfo()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loginButton.center = topView.center
    }
    
    func configureLoginButton() {
        loginButton.loginBehavior = .web
        loginButton.readPermissions = ["public_profile"]
        loginButton.delegate = self
        topView.addSubview(loginButton)
    }
    
    // MARK: - FBSDKLoginButtonDelegate
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if let error = error {
            print("Error: \(error.localizedDescription)")
            return
        }
        if Facebook.shared.userLoggedIn() {
            Facebook.shared.fetchLoggedInUserInfo()
            userListTableView.isHidden = false
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        FBSDKLoginManager().logOut()
        self.userListTableView.isHidden = true
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userCell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! UserCell
        
        let firstName = usersArray[indexPath.row]["firstName"] as! String
        let lastName = usersArray[indexPath.row]["lastName"] as! String
        userCell.fullname.text = firstName + " " + lastName
        
        let imageURL = URL(string: usersArray[indexPath.row]["picture"] as! String)
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: imageURL!)
            DispatchQueue.main.async {
                userCell.picture.image = UIImage(data: data!)
            }
        }
        return userCell
    }
}
