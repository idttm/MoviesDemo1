//
//  SearchUserData.swift
//  MoviesDemo
//
//  Created by Andrew Cheberyako on 21.05.2021.
//

import Foundation

struct SearchUserData {
    
    let name: [String]
    
    init?(dataStruct: Test2) {
        var name1 = [String]()
        for name in dataStruct.results {
            name1.append(name.name)
        }
        name = name1
    }
    
}
