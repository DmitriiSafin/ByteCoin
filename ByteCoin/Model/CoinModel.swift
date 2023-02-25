//
//  CoinModel.swift
//  ByteCoin
//
//  Created by Дмитрий on 25.02.2023.
//

import Foundation

struct CoinModel {
    let coin: String
    let rate: Double
    
    var rateString: String {
        return String(format: "%.2f", rate)
    }
}
