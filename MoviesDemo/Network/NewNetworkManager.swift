//
//  NewNetworkManager.swift
//  MoviesDemo
//
//  Created by Andrew Cheberyako on 20.06.2021.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

protocol EndPointType {
    var baseURL: URL {get}
    var path: String {get}
    var httpMethod: HTTPMethod {get}
    var task: HTTPTack {get}
}

typealias Parameters = [String: Any]
enum HTTPTack {
    case request
    case requestParameters(urlParametrs: Parameters?)
}

enum ConfigurationTrendingMoves: EndPointType {
    case configurationWeek(apiKey: String, path: String, page: Int)
    case configurationDay(apiKey: String, path: String, page: Int) 
    case similarMovies(apyKey: String, path: String, page: Int, movieId: Int)
    case searchMovies(apyKey: String, path: String, page: Int, query: String)
}

extension ConfigurationTrendingMoves {
    
    var environmentBaseURL: String { "https://api.themoviedb.org/3/" }
    
    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else {
            fatalError("failed to configure base URL")
        }
        return url
    }
    
    var path: String {
        switch self {
        
        case .configurationWeek(_, _, _):
            return "trending/movie/week"
        case .configurationDay(_, _, _):
        return "treding/movie/day"
        case .searchMovies(_, _, _, _):
            return "search/company"
        case .similarMovies(_, _, _, let movieId):
        return "movie/\(movieId)/similar?"
        }
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var task: HTTPTack {
        switch self {
        case .configurationWeek(apiKey: let apiKey, _, page: let page):
            return .requestParameters(urlParametrs: ["api_key": apiKey,
                                                     "page": page])
        case .configurationDay(apiKey: let apiKey, _, page: let page):
            return .requestParameters(urlParametrs: ["api_key": apiKey,
                                                     "page": page])
        case .similarMovies(apyKey: let apyKey,_ , page: let page, _):
            return .requestParameters(urlParametrs: [ "api_key": apyKey,
                                                      "page": page,])
        case .searchMovies(apyKey: let apyKey, _, page: let page, query: let query):
            return .requestParameters(urlParametrs: ["api_key": apyKey,
                                                     "page": page,
                                                     "query": query])
        }
    }
}
class Networking {
    
    
    func makeURL(from route: EndPointType,apiKey: String, page: Int, query: String?, movieID: String?) {
        var request = URLRequest(url: route.baseURL.appendingPathComponent(route.path), cachePolicy: .reloadRevalidatingCacheData, timeoutInterval: 30.0)
        request.httpMethod = route.httpMethod.rawValue
        do {
            switch route.task {
            
            case .request:
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//            case .requestParameters(urlParametrs: let urlParametrs):
                
            case .requestParameters(urlParametrs: let urlParametrs):
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
        }
        
        
    }
    
    func gettingDataFromJSON(page: Int, week: Bool = true, completion: @escaping (Result<[DataResult],Error>) -> Void) {
        var url = "1111"
        
        
    
        
        self.fetchData(model: Test.self, urlString: url) { [weak self] result in
            switch result {
            case .success(let model):
                if model.page <= model.totalPages {
                    completion(.success(model.results))
                    print(model.totalPages)
                }
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
