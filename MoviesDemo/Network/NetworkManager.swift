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

enum responseTrandingMovies: String {
    case trendingWeek = "trending/movie/week"
    case trendingDay = "trending/movie/day"
    case search = "search/movie"
}

class NetworkMoviesManager {
    
    func makeURL(page: String,
                 apiKey: String,
                 requestOption: responseTrandingMovies,
                 query: String? = nil) -> String? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.themoviedb.org"
        components.path = "/3/\(requestOption.rawValue)"
        if query != nil {
            components.queryItems = [
                URLQueryItem(name: "query", value: query),
                URLQueryItem(name: "api_key", value: apiKey),
                URLQueryItem(name: "page", value: page)
            ]
            let url = components.url?.absoluteString
            
            return url
        }
        components.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "page", value: page)
        ]
        let url = components.url?.absoluteString
        return url




    }



    func gettingDataFromJSON(page: Int, week: Bool? = true, completion: @escaping (Result<[DataResult],Error>) -> Void) {
        var url: String
        
        if week == true {
            url = self.makeURL(page: String(page), apiKey: apiKey, requestOption: .trendingWeek)!
        } else {
            url = self.makeURL(page: String(page), apiKey: apiKey, requestOption: .trendingDay)!
        }
        
        self.fetchData(model: Test.self, urlString: url) { [weak self] result in
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
        let urlString =  self.makeURL(page: String(page), apiKey: apiKey, requestOption: .search, query: query)
        print(urlString)
        self.fetchData(model: SearchData.self, urlString: urlString!) { [weak self] result in
            switch result {
            case .success(let model):
                completion(.success(model.results))
            case .failure(let error):
                completion(.failure(error))
                return
            }
        }
    }
    
    func gettingDataSimilarFromJSON(page: Int, query: String, completion: @escaping (Result<[ResultSimilar],Error>) -> Void) {
        let urlString = "https://api.themoviedb.org/3/movie/\(query)/similar?api_key=357c897a0e2f1679cd227af63c654745&language=en-US&page=\(page)"
        self.fetchData(model: DataSimilar.self, urlString: urlString) { [weak self] result in
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
