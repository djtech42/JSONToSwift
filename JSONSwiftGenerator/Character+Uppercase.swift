//
//  Character+Uppercase.swift
//  JSONSwiftGenerator
//
//  Created by Dan Turner on 3/3/17.
//  Copyright © 2017 Bren. All rights reserved.
//

import Foundation

extension Character {
    var isUppercase: Bool {
        return String(self) != String(self).lowercased()
    }
}
