//
//  JSONInteractor.swift
//  JSONSwiftGenerator
//
//  Created by Brenden Konnagan on 2/28/17.
//  Copyright © 2017 Bren. All rights reserved.
//

import Foundation

enum JSONInteractor {
    static func generateCollection(from json: Any) throws -> JSONCollection? {
        let type = try JSONInteractor.rootType(from: json)
        switch type {
        case .array:
            guard let jsonArray = json as? [Any] else { return nil }
            return JSONCollection(jsonArray)
        case .dictionary:
            guard let jsonDictionary = json as? [String : Any] else { return nil }
            return JSONCollection(jsonDictionary)
        }
    }
}

extension JSONInteractor {
    fileprivate enum RootObjectType {
        case array
        case dictionary
    }
    fileprivate static func rootType(from json: Any) throws -> RootObjectType {
        if json is [Any] { return .array }
        if json is Object { return .dictionary }
        throw JSONToSwiftError(message: "JSON data has invalid root object type. JSON requires root objects to be either Array or Dictionary")
    }
}
