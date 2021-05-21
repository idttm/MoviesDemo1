//
//  SearchManager.swift
//  MoviesDemo
//
//  Created by Andrew Cheberyako on 19.05.2021.
//

import Foundation

protocol NetworkSearchManagerDelegate {
    func updateInterface(_: SearchManager, with usedDate: SearchUserData)
}


class SearchManager {
    
    static let shared = SearchManager()
    private init () {}
    var delegate: NetworkSearchManagerDelegate?
    func fetchCurrentJSONSearch(_ query: String = "Mortal") {
    
    let urlStirng =  "https://api.themoviedb.org/3/search/company?api_key=357c897a0e2f1679cd227af63c654745&query=\(query)&page=1"
        
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
    
    func parseJSON(withData data: Data) -> SearchUserData? {
        
        let decoder = JSONDecoder()
        do {
           let currentJSON =  try decoder.decode(Test2.self, from: data)
            guard let currentData = SearchUserData(dataStruct: currentJSON) else {return nil }
            return currentData
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
        return nil
    }
}
