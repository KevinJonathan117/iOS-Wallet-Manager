//
//  ViewController.swift
//  walletManager
//
//  Created by Cynthia Wijaya on 19/11/20.
//  Copyright © 2020 Cynthia Wijaya. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    var ref: DatabaseReference!
    static let logindefaults = UserDefaults.standard
    var data : UserData?
    var ceksukseslogin = false
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        ref = Database.database().reference()
        
        if(ViewController.logindefaults.value(forKey: "username") != nil){
            performSegue(withIdentifier: "keMain", sender: self)
        }
        print("login")
    }

    @IBAction func tombolLogin(_ sender: UIButton) {
        if(txtUsername.text != "" && txtPassword.text != "") {
                ref.child(txtUsername.text!).observe(.value, with: { (snapshot) in
                    if(snapshot.childrenCount > 0) {
                        let v = snapshot.value as! NSDictionary
                        for (_,j) in v {
                            for (m,n) in j as! NSDictionary {
                                if(m as! String == "password") {
                                    if(n as! String == self.txtPassword.text!) {
                                        ViewController.self.logindefaults.setValue(self.txtUsername.text!, forKey: "username")
                                        /*let alert = UIAlertController(title: "Login Success", message: "Anda terlogin sebagai \(self.txtUsername.text!)", preferredStyle: .alert)
                                        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: {
                                            (alert: UIAlertAction!) in print("Success login")
                                        }))
                                        self.present(alert, animated: true, completion: nil)*/
                                        //self.ceksukseslogin = true
                                        self.performSegue(withIdentifier: "keMain", sender: self)
                                        
                                    } else {
                                        let alert = UIAlertController(title: "Cannot Login", message: "Password salah!", preferredStyle: .alert)
                                        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: nil))
                                        self.present(alert, animated: true, completion: nil)
                                    }
                                }
                            }
                        }
                        
                    } else {
                        let alert = UIAlertController(title: "Cannot Login", message: "Username salah!", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                  }) { (error) in
                    print(error.localizedDescription)
                }
            
        }
        else {
            let alert = UIAlertController(title: "Cannot Login", message: "Username dan Password harus diisi!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func tombolSignUp(_ sender: UIButton) {
        performSegue(withIdentifier: "toSignUp", sender: self)
        
    }
}

