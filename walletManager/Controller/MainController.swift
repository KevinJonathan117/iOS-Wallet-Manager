//
//  MainController.swift
//  walletManager
//
//  Created by Cynthia Wijaya on 26/11/20.
//  Copyright © 2020 Cynthia Wijaya. All rights reserved.
//

import UIKit
import Firebase

class MainController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var ref: DatabaseReference!
    
    var passingTrans:Transaksi?

    static var transactionData = [Transaksi]()
    static var totalTransaction : Double = 0.00
    var data = [String]()
    var filteredData: [String]!
    var dataDict = [String: [String]]()
    var dataSectTitles = [String]()
    var tempName : String = ""
    
    //variable sementara
    var tempNominal: Double = 0.00
    var tempTgl: String = ""
    var tempJenis: String = ""
    var tempNote: String = ""
    
    @IBOutlet weak var tableView: UITableView!
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "keAddTransaction", sender: self)
    }
    @IBAction func logOutButton(_ sender: UIBarButtonItem) {
        ViewController.logindefaults.removeObject(forKey: "username")
        MainController.transactionData.removeAll()
        MainController.totalTransaction = 0.00
        self.navigationController?.isNavigationBarHidden = true
        navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationController?.isNavigationBarHidden = false
        ref = Database.database().reference()
        tableView.delegate = self
        tableView.dataSource = self
        dataSectTitles.append("Total")
        dataSectTitles.append("Transactions")
        print("main")
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("view will appear")
        self.navigationController?.isNavigationBarHidden = false
        MainController.transactionData.removeAll()
        MainController.totalTransaction = 0.00
        getTransactions()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("View did appear")
    }
    
    ///this is database call
    //get transaction from firebase
    func getTransactions() {
        print("get transaction")
        let myUsername = ViewController.logindefaults.value(forKey: "username")
        ref.child(myUsername as! String).child("transaksi").observe(.value, with: { (snapshot) in
            if(snapshot.childrenCount > 0) {
                let v = snapshot.value as! NSDictionary
                for (_,j) in v {
                    for (m,n) in j as! NSDictionary {
                        if(m as! String == "nominal") {
                            self.tempNominal = Double("\(n)")!
                        }
                        if(m as! String == "tgl") {
                            self.tempTgl = n as! String
                        }
                        if(m as! String == "jenis") {
                            self.tempJenis = n as! String
                        }
                        if(m as! String == "note") {
                            self.tempNote = n as! String
                        }
                    }
                    let newTransaksi = Transaksi(nominal: self.tempNominal, tgl: self.tempTgl, jenis: self.tempJenis, note: self.tempNote)
                    MainController.transactionData.append(newTransaksi)
                    if(self.tempJenis == "Income") {
                        MainController.totalTransaction += self.tempNominal
                    } else {
                        MainController.totalTransaction -= self.tempNominal
                    }
                    self.tableView.reloadData()
                    
                }
            }
          }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    ///this is table funcs
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSectTitles.count
    }
    
    //number of section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //let key = dataSectTitles[section]
        if section == 0 {
            return 1
        }
        if section == 1 {
            return MainController.transactionData.count
        }
        /*if let fData = dataDict[key] {
            return fData.count
        }*/
        return 0
    }
    
    //onclick
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.section == 0) {

            performSegue(withIdentifier: "keDetailTotal", sender: self)
            
        }else if(indexPath.section == 1) {
            print("Index : \(indexPath.section), \(indexPath.row)")
            print("\(MainController.transactionData[indexPath.row].getNote())")
            let tgl = MainController.transactionData[indexPath.row].getTgl()
            let jenis = MainController.transactionData[indexPath.row].getJenis()
            let nominal = MainController.transactionData[indexPath.row].getNominal()
            let notes = MainController.transactionData[indexPath.row].getNote()
            passingTrans = Transaksi(nominal: nominal,tgl: tgl,jenis: jenis,note: notes)
            
            performSegue(withIdentifier: "keDetail", sender: self)
        }
                
       
        
    }
    
    //show cell in tableview
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        /*let key = dataSectTitles[indexPath.section]
        if let fData = dataDict[key] {
            cell.textLabel?.text = fData[indexPath.row]
         }*/
        if(ViewController.logindefaults.value(forKey: "username") != nil) {
            if(indexPath.section == 0) {
                cell.textLabel?.text = "Rp. \(MainController.totalTransaction)"
                cell.detailTextLabel?.text = ""
                cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
            }
            else if(indexPath.section == 1) {
                if MainController.transactionData.count > 0 {
                    if MainController.transactionData[indexPath.row].getNote().count > 25{
                        cell.textLabel?.text = String(MainController.transactionData[indexPath.row].getNote().prefix(12)) + "..."
                    }
                    else{
                        cell.textLabel?.text = MainController.transactionData[indexPath.row].getNote()
                    }
                    cell.detailTextLabel?.text = " \(MainController.transactionData[indexPath.row].getNominal())"
                    if(MainController.transactionData[indexPath.row].getJenis() == "Expense") {
                        cell.detailTextLabel?.textColor = .red
                    } else {
                        cell.detailTextLabel?.textColor = .green
                    }
                }
            }
        }
        return cell
    }
    
    //show section titles in view
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dataSectTitles[section]
    }
    
    /*private func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UIContextualAction]? {
        
        let delete = UIContextualAction(style: .destructive, title: "Delete", handler: {_,_,_ in
            tableView.deleteRows(at: [indexPath], with: .fade)
        })
        
        return [delete]
    }*/
    
    /*func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return dataSectTitles
    }*/
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "keDetail"{
            let vc = segue.destination as! DetailController
            vc.receiveData = self.passingTrans
        }
        else if segue.identifier == "keDetailTotal"{
            let vc = segue.destination as! DetailTotalController
            vc.receiveTotal = String(MainController.totalTransaction)
        }
    }
    
    
    /*func makeSections() {
        for fData in filteredData {
            let key = String(fData.prefix(1))
            if var d = dataDict[key] {
                d.append(fData)
                dataDict[key] = d
            } else {
                dataDict[key] = [fData]
            }
        }
        dataSectTitles = [String](dataDict.keys)
        dataSectTitles = dataSectTitles.sorted(by: { $0 < $1 })
    }*/
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
