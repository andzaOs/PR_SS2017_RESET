//
//  AccountTableViewController.swift
//  reset-ios
//
//  Created by Andza Os on 15/02/17.
//  Copyright © 2017 Andza Os. All rights reserved.
//

import UIKit
import KeychainSwift

class AccountTableViewController: UITableViewController {
   
    @IBOutlet weak var lblFirstName: UILabel!
    @IBOutlet weak var lblLastName: UILabel!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtNewPassword: UITextField!
    @IBOutlet weak var txtRepeatedPassword: UITextField!
    @IBOutlet weak var txtOldPassword: UITextField!
    @IBOutlet weak var cellEmail: UIView!
    
    var user : User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Localized.localize(key: "account_settings_title")
        lblFirstName.text = self.user?.firstName
        lblLastName.text = self.user?.lastName
        lblUsername.text = self.user?.username
        txtEmail.text = self.user?.email
        txtEmail.isUserInteractionEnabled = true
        cellEmail.isUserInteractionEnabled = true
    }
    
    @IBAction func btnUpdate(_ sender: Any) { 
        
        
        if(txtNewPassword.text == txtRepeatedPassword.text || !Validations.validatePasswordLength(password: txtNewPassword.text!)) {
            AlertManager.sharedInstance.alertMessage(message: "settings_bad_new_password", controler: self)
            
        } else if (txtNewPassword.text != txtRepeatedPassword.text) {
            AlertManager.sharedInstance.alertMessage(message: "settings_bad_input", controler: self)
            
        } else {
            user?.password = txtNewPassword.text
            user?.confirmationPassword = txtOldPassword.text
        }
        
        user?.email = txtEmail.text
        
        NetworkManager.sharedInstance.PutAccount(user: user!, controler: self) { user, error in
            
            if(error == nil) {
                
                AlertManager.sharedInstance.alertMessage(message: "settings_good_input", controler: self)
                
                self.txtNewPassword.text = ""
                self.txtRepeatedPassword.text = ""
                self.txtOldPassword.text = ""
                
            } else {
                print("Log: " + String(describing: error))
            }
        }
    }
    
    @IBAction func btnLogout(_ sender: Any) {
        //TODO
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
