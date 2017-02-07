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
import Firebase
import FirebaseDatabase

class MainVC: UIViewController, UITableViewDataSource, FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var userListTableView: UITableView!
    @IBOutlet weak var topView: UIView!
    
    let loginButton = FBSDKLoginButton()
    var usersArray = [NSDictionary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLoginButton()
        readFromFireBaseDB()
        
        if let _ = FBSDKAccessToken.current() { // User logged in
            userListTableView.isHidden = false
            fetchLoggedInUserInfo()
        }
    }
    
    func configureLoginButton() {
        loginButton.center.x = view.center.x // ??? why topView.center.x doesn't work
        loginButton.center.y = topView.center.y
        loginButton.loginBehavior = .web
        loginButton.readPermissions = ["public_profile"]
        loginButton.delegate = self
        topView.addSubview(loginButton)
    }
    
    func readFromFireBaseDB() {
        FIRDatabase.database().reference().child("users").observe(.value, with: { (snapshot) in
            let usersDictionary = snapshot.value as! NSDictionary
            self.usersArray = usersDictionary.allValues as! [NSDictionary]
            self.userListTableView.reloadData()
        })
    }
    
    func writeToFireBaseDB(_ result : NSDictionary) {
        guard let firstname = result["first_name"] as? String,
            let lastname = result["last_name"] as? String, let id = result["id"] as? String else { return }
        
        if let picture = result["picture"] as? NSDictionary, let data = picture["data"] as? NSDictionary, let imageURL = data["url"] {
            FIRDatabase.database().reference().child("users").child(id).setValue(["firstName": firstname, "lastName": lastname, "picture": imageURL])
        }
        
    }
    
    func fetchLoggedInUserInfo() {
        let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "id, first_name, last_name, picture.type(normal)"])
        _ = graphRequest?.start(completionHandler: { (connection, result, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            } else
            {
                guard let result = result as? NSDictionary else { return }
                self.writeToFireBaseDB(result)
            }
        })
    }
    
    // MARK: - FBSDKLoginButtonDelegate
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if let error = error {
            print("Error: \(error.localizedDescription)")
            return
        }
        if let _ = FBSDKAccessToken.current() {
            fetchLoggedInUserInfo()
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
