//
//  Character+Case.swift
//  JSONSwiftGenerator
//
//  Created by Dan Turner on 3/3/17.
//  Copyright © 2017 Bren. All rights reserved.
//

import Foundation

extension Character {
    var uppercased: String {
        return String(self).uppercased()
    }
    var lowercased: String {
        return String(self).lowercased()
    }
    var isUppercase: Bool {
        return String(self) != lowercased
    }
    var isLowercase: Bool {
        return !isUppercase
    }
}
