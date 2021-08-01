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

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

protocol EndPointType {
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
}

typealias Parameters = [String: Any]

enum HTTPTask {
    case request
    case requestParameters(urlParametrs: Parameters?)
}

enum MoviesEndPoint: EndPointType {
    case configurationWeek(apiKey: String, page: Int)
    case configurationDay(apiKey: String, page: Int)
    case similarMovies(apyKey: String, page: Int, movieId: Int)
    case searchMovies(apyKey: String, page: Int, query: String)
}

extension MoviesEndPoint {
    
    var environmentBaseURL: String { "https://api.themoviedb.org/3/" }
    
    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else {
            fatalError("failed to configure base URL")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .configurationWeek(_, _):
            return "trending/movie/week"
        case .configurationDay(_, _):
            return "trending/movie/day"
        case .searchMovies(_, _, _):
            return "search/movie"
        case .similarMovies(_, _, let movieId):
            return "movie/\(movieId)/similar"
        }
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var task: HTTPTask {
        switch self {
        case .configurationWeek(apiKey: let apiKey, page: let page):
            return .requestParameters(urlParametrs: ["api_key": apiKey,
                                                     "page": page])
        case .configurationDay(apiKey: let apiKey, page: let page):
            return .requestParameters(urlParametrs: ["api_key": apiKey,
                                                     "page": page])
        case .similarMovies(apyKey: let apyKey, page: let page, _):
            return .requestParameters(urlParametrs: [ "api_key": apyKey,
                                                      "page": page,])
        case .searchMovies(apyKey: let apyKey, page: let page, query: let query):
            return .requestParameters(urlParametrs: ["api_key": apyKey,
                                                     "page": page,
                                                     "query": query])
        }
    }
}

class NetworkingManager {
    
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForResource = 30
        config.timeoutIntervalForRequest = 30
        let session = URLSession(configuration: config)
        return session
    }()
    
    func makeRequest(from route: EndPointType) -> URLRequest {
        var request = URLRequest(url: route.baseURL.appendingPathComponent(route.path), cachePolicy: .reloadRevalidatingCacheData, timeoutInterval: 30.0)
        request.httpMethod = route.httpMethod.rawValue
        
        do {
            switch route.task {
            case .request:
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            case .requestParameters(urlParametrs: let urlParametrs):
                guard let url = request.url else { fatalError("NO URL") }
                if var urlComponts = URLComponents(url: url, resolvingAgainstBaseURL: false), let params = urlParametrs, !params.isEmpty {
                    urlComponts.queryItems = [URLQueryItem]()
                    for (key, value) in params {
                        let queryItem = URLQueryItem(name: key, value: "\(value)")
                        urlComponts.queryItems?.append(queryItem)
                    }
                    request.url = urlComponts.url
                }
                if request.value(forHTTPHeaderField: "Content-Type") == nil {
                    
                    request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
                }
            }
        }
        return request
    }
    
    @discardableResult
    func fetchData<T: Decodable>(_ route: EndPointType, model: T.Type, completion: @escaping (Result<T, Error>)  -> Void) -> URLSessionTask? {
        let request = makeRequest(from: route)
        let task = session.dataTask(with: request) { [unowned self] data, response, error in
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
        return task
    }
    
    func getTrandinMovies(page: Int, week: Bool = true, completion: @escaping (Result<[DataResult],Error>) -> Void) {
        let route = week ? MoviesEndPoint.configurationWeek(apiKey: apiKey, page: page) : MoviesEndPoint.configurationDay(apiKey: apiKey, page: page)
        self.fetchData(route, model: Test.self) { [weak self] result in
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
    
    func getSearchMovies(page: Int, query: String, completion: @escaping (Result<[DataSearch],Error>) -> Void) {
        self.fetchData(MoviesEndPoint.searchMovies(apyKey: apiKey, page: page, query: query), model: SearchData.self) { [weak self] result in
            switch result {
            case .success(let model):
                completion(.success(model.results))
            case .failure(let error):
                completion(.failure(error))
                return
            }
        }
    }
    
    func getSimilarMovies(page: Int, movieId: Int, completion: @escaping (Result<[ResultSimilar],Error>) -> Void) {
        
        self.fetchData(MoviesEndPoint.similarMovies(apyKey: apiKey, page: page, movieId: movieId), model: DataSimilar.self) { [weak self] result in
            switch result {
            case .success(let model):
                completion(.success(model.results))
            case .failure(let error):
                completion(.failure(error))
                return
            }
        }
    }
    
    func parseJSON<T:Decodable>(type: T.Type, data: Data) throws -> T {
        let decoder = JSONDecoder()
        return try decoder.decode(type, from: data)
    }
    
}
