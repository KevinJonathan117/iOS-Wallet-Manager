//
//  SignUpController.swift
//  walletManager
//
//  Created by Cynthia Wijaya on 19/11/20.
//  Copyright © 2020 Cynthia Wijaya. All rights reserved.
//

import UIKit
import Firebase

class SignUpController: UIViewController {

    var ref: DatabaseReference!
    
    @IBOutlet weak var txtConfirm: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        ref = Database.database().reference()
    }
    
    @IBAction func signUpButton(_ sender: UIButton) {
        
        if txtName.text == "" || txtUsername.text == "" || txtPassword.text == "" || txtConfirm.text == ""{
            let alertController = UIAlertController(title: "Data Tidak Boleh Kosong !", message: "", preferredStyle: .alert)
                   
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil ))
                   
            self.present(alertController, animated: true, completion: nil)
        }
        else{
            
            if txtPassword.text == txtConfirm.text{
                
                let val = [ "name": txtName.text, "username": txtUsername.text, "password": txtPassword.text]
                    
                ref.child("\(txtUsername.text!)").child("datauser").setValue(val)
                    txtName.text = ""
                    txtUsername.text = ""
                    txtPassword.text = ""
                    txtConfirm.text = ""
                
                    navigationController?.popViewController(animated: true)
                
            }
            else{
                let alertController = UIAlertController(title: "Confirm Password Harus Sama!", message: "", preferredStyle: .alert)
                       
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil ))
                       
                self.present(alertController, animated: true, completion: nil)
            }
            
        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
