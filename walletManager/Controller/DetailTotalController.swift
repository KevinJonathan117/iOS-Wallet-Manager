//
//  DetailTotalController.swift
//  walletManager
//
//  Created by Cynthia Wijaya on 07/12/20.
//  Copyright © 2020 Cynthia Wijaya. All rights reserved.
//

import UIKit

class DetailTotalController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate{
    
    var dtCurrency : Rates?
    var currencyCategory: [String] = [String]()
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyCategory.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyCategory[row]
    }

    var receiveTotal : String?
    var doubleTotal : Double?
    
    
    @IBAction func convertButton(_ sender: UIButton) {
        let currencyRow = self.currencyPicker.selectedRow(inComponent: 0)
        var selectedValue: Double = 0
        if currencyRow == 0 {
            selectedValue = dtCurrency!.HKD
        } else if currencyRow == 1 {
            selectedValue = dtCurrency!.JPY
        } else if currencyRow == 2 {
            selectedValue = dtCurrency!.EUR
        } else if currencyRow == 3 {
            selectedValue = dtCurrency!.CNY
        } else if currencyRow == 4 {
            selectedValue = dtCurrency!.USD
        } else {
            selectedValue = dtCurrency!.SGD
        }
        self.currencyValue.text = String(format: "%.2f", selectedValue * MainController.totalTransaction)
    }
    @IBOutlet weak var currencyValue: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    @IBOutlet weak var totalRupiah: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        totalRupiah.text = receiveTotal
        APIcall()
        
        self.currencyPicker.delegate = self
        self.currencyPicker.dataSource = self
        
        currencyCategory = ["HKD", "JPY" , "EUR", "CNY", "USD", "SGD"]
        
        // Do any additional setup after loading the view.
    }
    
    //call API
    func APIcall() {
        let contactURL = "https://api.exchangeratesapi.io/latest?base=IDR"
        let request = NSMutableURLRequest(url: NSURL(string: contactURL)! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
                    request.httpMethod = "GET"
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: handle(data: response: error:))
        task.resume()
    }

    func handle(data: Data?, response: URLResponse?, error: Error?) {
        if error != nil {
            print(error ?? "")
        }
        let httpResponse = response as? HTTPURLResponse
        print(httpResponse ?? "")
        if let safeData = data {
            let dataString = String(data: safeData, encoding: .utf8)
            print(dataString ?? "")
            self.parseJSON(currencyData: safeData)
        }
    }
    
    func parseJSON(currencyData: Data)  {
        let decoder = JSONDecoder()
        do {
            let decodeData = try decoder.decode(CurrencyData.self, from: currencyData)
            DispatchQueue.main.async {
                self.dtCurrency = decodeData.rates
                /*let currencyRates = Rates(HKD: decodeData.HKD)
                for i in 0...5 {
                   
                    self.myContacts.append(myContact)
                    self.data.append(self.myContacts[i].name)
                }
                self.filteredData = self.data
                self.makeSections()
                //print(decodeData.results[10].name.first)
                self.tableView.reloadData()*/
            }
        } catch {
            print(error)
            let alert = UIAlertController(title: "Error", message: "App failed to load the data", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            
            self.present(alert, animated: true)
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
