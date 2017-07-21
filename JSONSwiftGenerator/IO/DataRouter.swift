//
//  DataRouter.swift
//  JSONSwiftGenerator
//
//  Created by Brenden Konnagan on 3/1/17.
//  Copyright © 2017 Bren. All rights reserved.
//

import Foundation

enum DataRouter {
    case file(location: URL)
    case url(location: URL)
    
    var location: URL? {
        switch self {
        case .file(let location): return location
        case .url(let location): return location
        }
    }
}

extension DataRouter: Equatable {
    var value: Int {
        switch self {
        case .file: return 0
        case .url: return 1
        }
    }
    
    static func == (lhs: DataRouter, rhs: DataRouter) -> Bool {
        return lhs.value == rhs.value
    }
}
