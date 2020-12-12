//
//  Transaksi.swift
//  walletManager
//
//  Created by Cynthia Wijaya on 26/11/20.
//  Copyright © 2020 Cynthia Wijaya. All rights reserved.
//

import Foundation

struct Transaksi {
    var nominal : Double
    var tgl : String
    var jenis: String
    var note: String
    
    init(nominal: Double, tgl: String, jenis: String, note: String) {
        self.nominal = nominal
        self.tgl = tgl
        self.jenis = jenis
        self.note = note
    }
    
    func getNote() -> String {
        return note
    }
    
    func getNominal() -> Double {
        return nominal
    }
    
    func getJenis() -> String {
        return jenis
    }
    
    func getTgl() -> String {
        return tgl
    }
}
