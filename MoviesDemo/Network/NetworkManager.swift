//
//  NetworkManager.swift
//  MoviesDemo
//
//  Created by Andrew Cheberyako on 12.05.2021.
//

import Foundation

protocol NetworkManagerDelegate {
    func updateInterface(_: NetworkMoviesManager, with usedDate: UsedData)
}

class NetworkMoviesManager {
    
    
    var delegate: NetworkManagerDelegate?
    func fetchCurrentJson() {
        
        let urlStirng = "https://api.themoviedb.org/3/trending/movie/week?api_key=357c897a0e2f1679cd227af63c654745"
        guard let url = URL(string: urlStirng) else {return}
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            if let data = data {
                if let currentData = self.parseJSON(withData: data) {
                    self.delegate?.updateInterface(self, with: currentData)
                }
            }
        }
        task.resume()
    }
    
    func parseJSON(withData data: Data) -> UsedData? {
        
        let decoder = JSONDecoder()
        do {
           let currentJSON =  try decoder.decode(Test.self, from: data)
            guard let currentData = UsedData(dataStruct: currentJSON) else {return nil }

            
            return currentData
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
        return nil
    }
}
