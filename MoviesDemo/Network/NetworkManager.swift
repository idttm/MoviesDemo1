//
//  NetworkManager.swift
//  MoviesDemo
//
//  Created by Andrew Cheberyako on 12.05.2021.
//

import Foundation

enum NetworkError: Error {
    case somothingWentWrong
    case noData
    case parsingFailed
}

class NetworkMoviesManager {
    
    func gettingDataFromJSON(page: Int, completion: @escaping (Result<[DataResult],Error>) -> Void) {
        let urlStirng = "https://api.themoviedb.org/3/trending/movie/week?api_key=357c897a0e2f1679cd227af63c654745&page=\(page)"
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
                    let test = try self.parseJSON(type: Test.self, data: data)
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
