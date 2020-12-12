//
//  AddTransactionController.swift
//  walletManager
//
//  Created by Cynthia Wijaya on 28/11/20.
//  Copyright © 2020 Cynthia Wijaya. All rights reserved.
//

import UIKit
import Firebase

class AddTransactionController: UIViewController {

    @IBOutlet weak var txtNominal: UITextField!
    @IBOutlet weak var txtNote: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var categorySegment: UISegmentedControl!
    
    var ref: DatabaseReference!
    
    var usernameNow = ViewController.logindefaults.value(forKey: "username")
    
    @IBAction func cancelButton(_ sender: UIButton) {
        print("Cancel clicked!")
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func addButton(_ sender: UIButton) {
        if txtNominal.text == "" || txtNote.text == ""{
            let alertController = UIAlertController(title: "Data Tidak Boleh Kosong !", message: "", preferredStyle: .alert)
                   
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil ))
                   
            self.present(alertController, animated: true, completion: nil)
        }else{
            
            var categorySelection : String = ""
            var tgl : String = ""
            let nominal : String = txtNominal.text!
            let note : String = txtNote.text!
            
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy"
            let year: String = dateFormatter.string(from: self.datePicker.date)
            dateFormatter.dateFormat = "MM"
            let month: String = dateFormatter.string(from: self.datePicker.date)
            dateFormatter.dateFormat = "dd"
            let day: String = dateFormatter.string(from: self.datePicker.date)
        
            tgl = "\(day)-\(month)-\(year)"
            
            if(categorySegment.selectedSegmentIndex == 0) {
                categorySelection = "Expense"
            } else {
                categorySelection = "Income"
            }
            
            let valTrans = [ "nominal": nominal, "tgl": tgl, "jenis": categorySelection, "note": note]
            
            ref.child("\(usernameNow!)").child("transaksi").childByAutoId().setValue(valTrans)
            txtNominal.text = ""
            txtNote.text = ""
            
            //DispatchQueue.main.async {
            let alert = UIAlertController(title: "Add Success", message: "New Transaction Added", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: {
                (alert: UIAlertAction!) in print("Success add")
                    self.navigationController?.popViewController(animated: true)
            }))
            self.present(alert, animated: true, completion: nil)
            //}
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        print("add trans")
        self.navigationController?.isNavigationBarHidden = true
        // Do any additional setup after loading the view.
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
