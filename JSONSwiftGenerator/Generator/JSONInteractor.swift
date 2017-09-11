//
//  JSONInteractor.swift
//  JSONSwiftGenerator
//
//  Created by Brenden Konnagan on 2/28/17.
//  Copyright © 2017 Bren. All rights reserved.
//

import Foundation

enum JSONInteractor {
    static func collection(from json: Any) throws -> JSONCollection? {
        let type = try JSONInteractor.rootType(from: json)
        
        switch type {
        case .array:
            guard let jsonArray = json as? [Any] else { return .none }
            return JSONCollection(jsonArray)
        case .object:
            guard let jsonDictionary = json as? Object else { return .none }
            return JSONCollection(jsonDictionary)
        }
    }
}

extension JSONInteractor {
    fileprivate enum RootObjectType {
        case array
        case object
    }
    fileprivate static func rootType(from json: Any) throws -> RootObjectType {
        switch json {
        case is [Any]: return .array
        case is Object: return .object
        
        default: throw JSONToSwiftError(message: "JSON data has invalid root object type. JSON requires root objects to be either Array or Dictionary")
        }
    }
}
