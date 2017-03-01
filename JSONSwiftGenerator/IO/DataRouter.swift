//
//  DataRouter.swift
//  JSONSwiftGenerator
//
//  Created by Brenden Konnagan on 3/1/17.
//  Copyright © 2017 Bren. All rights reserved.
//

import Foundation

enum DataRouter {
    case none
    case file(location: URL)
    case url(location: URL)
    
    var location: URL? {
        switch self {
        case .file(let location): return location
        case .url(let location): return location
        case .none: return .none
        }
    }
}

extension DataRouter: Equatable {
    var value: Int {
        switch self {
        case .none: return 0
        case .file: return 1
        case .url: return 2
        }
    }
    
    static func ==(lhs: DataRouter, rhs: DataRouter) -> Bool {
        return lhs.value == rhs.value
    }
}
