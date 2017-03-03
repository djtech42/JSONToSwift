//
//  String+Uppercase.swift
//  JSONSwiftGenerator
//
//  Created by Dan Turner on 3/3/17.
//  Copyright © 2017 Bren. All rights reserved.
//

import Foundation

extension String {
    var isUppercase: Bool {
        return characters.reduce(true, { (allUppercase, character) -> Bool in
            if !character.isUppercase {
                return false
            }
            else {
                return allUppercase
            }
        })
    }
}
