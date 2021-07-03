//
//  CombineNetworkDataResult.swift
//  MoviesDemo
//
//  Created by Andrew Cheberyako on 09.06.2021.
//

import Foundation
import Combine

enum MoviesManager {
    
    static let agent = Agent()
    static let base = URL(string:"https://api.themoviedb.org/3/trending/movie/week?api_key=357c897a0e2f1679cd227af63c654745&page=1")!
}

extension MoviesManager{
    static func popularMovies() -> AnyPublisher<Test, Error> {
        return run(URLRequest(url: base))
    }
    
    static func run<T: Decodable>(_ request: URLRequest) -> AnyPublisher<T, Error> {
        return agent.run(request)
            .map(\.value)
            .eraseToAnyPublisher()
        
    }
}
