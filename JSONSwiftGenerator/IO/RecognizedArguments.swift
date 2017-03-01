//
//  RecognizedArguments.swift
//  JSONSwiftGenerator
//
//  Created by Brenden Konnagan on 3/1/17.
//  Copyright © 2017 Bren. All rights reserved.
//

import Foundation

enum RecognizedArguments: String {
    case url
    
    static func recognized(from flag: String) -> RecognizedArguments? {
        if flag == "-u" { return .url } else { return .none }
    }
}
