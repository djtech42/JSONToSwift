//
//  RecognizedArguments.swift
//  JSONSwiftGenerator
//
//  Created by Brenden Konnagan on 3/1/17.
//  Copyright © 2017 Bren. All rights reserved.
//

import Foundation

enum RecognizedArguments: String {
    case equatable
    case automaticRootName
    
    static func recognized(from flags: [Character]?) -> [RecognizedArguments] {
        guard let existingFlags = flags else { return [] }
        
        var recognized: [RecognizedArguments] = []
        
        if existingFlags.contains("e") {
            recognized.append(.equatable)
        }
        if existingFlags.contains("n") {
            recognized.append(.automaticRootName)
        }
        
        return recognized
    }
}
