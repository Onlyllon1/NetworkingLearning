//
//  CoinsViewModel.swift
//  NetworkingTutorial
//
//  Created by Francesco on 15/03/24.
//

import Foundation

class CoinsViewModel: ObservableObject {
    
    @Published var coin = " "
    @Published var price = " "
    
    init(){
        fetchPrice(coin: "ethereum")
    }
    
    func fetchPrice(coin: String) {
//       salvo l' url in una variabile
        let urlString = "https://api.coingecko.com/api/v3/simple/price?ids=\(coin)&vs_currencies=eur"
//        converto la variabile nel tipo URL
        guard let url = URL(string: urlString) else {return}
        
        
        print("Fetching price..")
        URLSession.shared.dataTask(with: url) { data, response, error in
            print("Did receive data \(data)")
            guard let data = data else { return }
            guard let jsonObject = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else { return }
            print(jsonObject)
            guard let value = jsonObject[coin] as? [String: Double] else {
                print ("Failed to parse value")
                return
            }
            guard let price = value["eur"] else { return }
            print(value)
            
            DispatchQueue.main.async {
                self.coin = coin.capitalized
                self.price = "$\(price)"
            }
 
        }.resume()
        
        print("Did reach end of function")
    }
}
