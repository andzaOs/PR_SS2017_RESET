//
//  ViewController.swift
//  ResetFrontendiOS
//
//  Created by Andza Os on 09/02/17.
//  Copyright © 2017 Andza Os. All rights reserved.
//

import UIKit

class LoginTableViewController: UITableViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var txtUsername: UITextField!
    
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBAction func btnSignin(_ sender: Any) {
        
        let controler = self
        
        if(txtPassword.text == "" || txtUsername.text == "") {
            
            AlertManager.sharedInstance.alertMessage(message: "login_bad_input", controler: controler)
            
        } else {
            
            NetworkManager.sharedInstance.Login(username: txtUsername.text!, password: txtPassword.text!, controler: controler) { responseObject, error in
                if(error == nil) {
                    self.performSegue(withIdentifier: "dashboardView", sender: self)
                } else {
                    print("Log: " + String(describing: error))
                }
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtUsername.delegate = self
        txtPassword.delegate = self
        
        txtUsername.text = ""
        txtPassword.text = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func textFieldShouldReturn(textField: UITextField!) -> Bool {
        
        if textField == self.txtUsername {
            self.txtPassword.becomeFirstResponder()
        }
        if textField == self.txtPassword {
            self.txtPassword.resignFirstResponder()
        }
        return true
    }
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue){
        
    }

}

