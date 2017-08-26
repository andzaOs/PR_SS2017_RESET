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
    
    var user : User?
    
    @IBAction func btnUpdate(_ sender: Any) {
        
        if(txtNewPassword.text == txtRepeatedPassword.text) {
            
            if(txtNewPassword.text! == "" || !Validations.validatePasswordLength(password: txtNewPassword.text!)) {
                AlertManager.sharedInstance.alertMessage(message: "settings_bad_new_password", controler: self)
            } else {
                
                user?.password = txtNewPassword.text
                user?.confirmationPassword = txtOldPassword.text
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
            
        } else {
            
            AlertManager.sharedInstance.alertMessage(message: "settings_bad_input", controler: self)
            
        }
        
        
        
    }
    
    @IBAction func btnLogout(_ sender: Any) {
    
        KeychainSwift().clear()
        
        self.performSegue(withIdentifier: "unwindToLogin", sender: self)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        lblFirstName.text = self.user?.firstName
        lblLastName.text = self.user?.lastName
        lblUsername.text = self.user?.username
        txtEmail.text = self.user?.email
        
        txtEmail.isUserInteractionEnabled = true
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnBack(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    private func textFieldShouldReturn(textField: UITextField!) -> Bool {
        
        txtEmail.becomeFirstResponder()
        return true
    }

    // MARK: - Table view data source
    /*
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    
    */

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
