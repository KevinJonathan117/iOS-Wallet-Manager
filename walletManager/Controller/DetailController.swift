//
//  DetailController.swift
//  walletManager
//
//  Created by Cynthia Wijaya on 05/12/20.
//  Copyright © 2020 Cynthia Wijaya. All rights reserved.
//

import UIKit
import Firebase

class DetailController: UIViewController {

    var receiveData : Transaksi?
    var ref : DatabaseReference!
    
    @IBAction func deleteTransaction(_ sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: "Confirm Delete", message: "Are you sure you want to delete this one?", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: {ACTION in
            
            self.ref.child(ViewController.logindefaults.value(forKey: "username") as! String).child("transaksi").observe(.value, with: { (snapshot) in
                if(snapshot.childrenCount > 0) {
                    let v = snapshot.value as! NSDictionary
                    for (i,j) in v {
                        var checkDeletion = 0
                        for (m,n) in j as! NSDictionary {
                            if(m as! String == "note") {
                                if (n as? String == self.receiveData?.note) {
                                    checkDeletion += 1
                                }
                            }
                            if(m as! String == "tgl") {
                                if(n as? String == self.receiveData?.tgl) {
                                    checkDeletion += 1
                                }
                            }
                        }
                        if checkDeletion == 2 {
                            self.ref.child("\(ViewController.logindefaults.value(forKey: "username") as! String)/transaksi/\(i as! String)").removeValue()
                            let alert = UIAlertController(title: "Delete Success", message: "Transaction Deleted", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: {
                                (alert: UIAlertAction!) in print("Success delete")
                                    self.navigationController?.popViewController(animated: true)
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                } else {
                    let alert = UIAlertController(title: "No Data", message: "Data tidak ditemukan!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
              }) { (error) in
                print(error.localizedDescription)
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    @IBOutlet weak var lblNote: UILabel!
    @IBOutlet weak var lblNominal: UILabel!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblDate.text = receiveData?.tgl
        let nominall = receiveData?.nominal
        lblNominal.text = String(format: "%.1f", nominall!)
        lblCategory.text = receiveData?.jenis
        lblNote.text = receiveData?.note
        
        if receiveData?.jenis == "Expense"{
            lblNominal.textColor = .red
        }
        else{
            lblNominal.textColor = .green
        }
        ref = Database.database().reference()
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
