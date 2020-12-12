//
//  Currency.swift
//  walletManager
//
//  Created by Cynthia Wijaya on 11/12/20.
//  Copyright © 2020 Cynthia Wijaya. All rights reserved.
//

import Foundation

struct CurrencyData: Decodable {
    let rates: Rates
}

struct Rates: Decodable {
    let HKD: Double
    let JPY: Double
    let EUR: Double
    let CNY: Double
    let USD: Double
    let SGD: Double
}
