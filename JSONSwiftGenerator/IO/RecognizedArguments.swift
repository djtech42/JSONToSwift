//
//  RecognizedArguments.swift
//  JSONSwiftGenerator
//
//  Created by Brenden Konnagan on 3/1/17.
//  Copyright © 2017 Bren. All rights reserved.
//

import Foundation

struct RecognizedArguments: OptionSet {
    let rawValue: Int
    
    static let equatable = RecognizedArguments(rawValue: 1 << 0)
    static let automaticRootName = RecognizedArguments(rawValue: 1 << 1)
    static let legacy = RecognizedArguments(rawValue: 1 << 2)
    static let verbose = RecognizedArguments(rawValue: 1 << 3)
    
    static func recognized(from flags: [Character]?) -> RecognizedArguments {
        guard let existingFlags = flags else { return [] }
        
        var recognized: RecognizedArguments = []
        
        if existingFlags.contains("e") {
            recognized.insert(.equatable)
        }
        if existingFlags.contains("l") {
            recognized.insert(.legacy)
        }
        if existingFlags.contains("n") {
            recognized.insert(.automaticRootName)
        }
        if existingFlags.contains("v") {
            recognized.insert(.verbose)
        }
        
        return recognized
    }
}
