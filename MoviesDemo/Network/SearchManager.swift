//
//  SearchManager.swift
//  MoviesDemo
//
//  Created by Andrew Cheberyako on 19.05.2021.
//

import Foundation

class SearchManager {
    
    
    func fetchCurrentJson(query: String, completion: @escaping (Result<[DataSearch],Error>) -> Void) {
    
    let urlStirng =  "https://api.themoviedb.org/3/search/keyword?api_key=357c897a0e2f1679cd227af63c654745&query=\(query)&page=1"
        
        guard let url = URL(string: urlStirng) else {return}
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else {return}
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let data = data else {
                    completion(.failure(NetworkError.noData))
                    return
                }
                do {
                    let test = try self.parseJSON(type: SearchData.self, data: data)
                    completion(.success(test.results))
                } catch let error {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    func parseJSON<T:Decodable>(type: T.Type, data: Data) throws -> T {
       let decoder = JSONDecoder()
        return try decoder.decode(type, from: data)
    }
}
