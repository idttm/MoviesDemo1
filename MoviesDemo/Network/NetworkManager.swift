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
     
        let urlString = "https://api.themoviedb.org/3/trending/movie/week?api_key=357c897a0e2f1679cd227af63c654745&page=\(page)"
        self.fetchData(model: Test.self, urlString: urlString) { [weak self] result in
            switch result {
            case .success(let model):
                if model.page <= model.totalPages {
                    completion(.success(model.results))
                }
            case .failure(let error):
                completion(.failure(error))
                return
            }
        }
    }
   
    func gettingDataSearchFromJSON(page: Int, query: String, completion: @escaping (Result<[DataSearch],Error>) -> Void) {
        
        let urlString =  "https://api.themoviedb.org/3/search/movie?api_key=357c897a0e2f1679cd227af63c654745&language=en-US&query=\(query)&page=1&include_adult=false&page=\(page)"
        self.fetchData(model: SearchData.self, urlString: urlString) { [weak self] result in
            switch result {
            case .success(let model):
                completion(.success(model.results))
            case .failure(let error):
                completion(.failure(error))
                return
            }
        }
    }
    func fetchData<T:Decodable>(model: T.Type, urlString: String, completion: @escaping (Result<T, Error>)  -> Void) {
        guard let url = URL(string: urlString) else {return}
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
                    let test = try self.parseJSON(type: model.self, data: data)
                    completion(.success(test))
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
