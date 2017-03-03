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
    
    static func recognized(from flags: [String]) -> [RecognizedArguments] {
        var recognized: [RecognizedArguments] = []
        
        if flags.contains("-e") {
            recognized.append(.equatable)
        }
        
        return recognized
    }
}
