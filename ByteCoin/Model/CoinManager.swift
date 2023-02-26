//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Дмитрий on 23.02.2023.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdateCoin(_ coinManager: CoinManager, coin: CoinModel)
}

struct CoinManager {
    
    private let apiKey = "91B9A41B-46DD-44AD-9D17-88A201D22B59"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    var delegate: CoinManagerDelegate?
    
    func getCoinPrice(for currency: String) {
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        performRequest(with: urlString)
    }
    
    private func performRequest(with urlString: String) {
                
        guard let url = URL(string: urlString) else { return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            if error != nil {
                print(error!)
                return
            }
            if let safeData = data {
                if let currency = parseJSON(safeData) {
                    delegate?.didUpdateCoin(self, coin: currency)
                }
            }
        }
        task.resume()
    }
    
    private func parseJSON(_ data: Data) -> CoinModel? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            let decodedData = try decoder.decode(CoinData.self, from: data)
            let price = decodedData.rate
            let currency = decodedData.assetIdQuote
            
            let rezult = CoinModel(coin: currency, rate: price)
            return rezult
        } catch {
            print(error)
            return nil
        }
    }
    
}

