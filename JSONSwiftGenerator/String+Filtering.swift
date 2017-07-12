//
//  String+Filtering.swift
//  JSONSwiftGenerator
//
//  Created by Dan Turner on 3/3/17.
//  Copyright © 2017 Bren. All rights reserved.
//

import Foundation

extension String {
    func removingOccurrences(of string: String) -> String {
        return replacingOccurrences(of: string, with: "")
    }
    
    func removingOccurrencesOfCharacters(from string: String) -> String {
        return removingOccurrences(of: Array(string.characters))
    }
    
    func removingOccurrences(of characters: [Character]) -> String {
        return characters.reduce(self) { (currentString, character) -> String in
            return currentString.removingOccurrences(of: character.description)
        }
    }
    
    var replacedUnderscoresWithSpaces: String {
        return replacingOccurrences(of: "_", with: " ")
    }
    
    var removedSpaces: String {
        return removingOccurrences(of: " ")
    }
    
    var prependedUnderscoreIfStartingWithDigit: String {
        if Int(String(describing: characters.first!)) != nil {
            return "_\(self)"
        }
        else {
            return self
        }
    }
    
    var isFormattedForSwiftPropertyName: Bool {
        return self == formattedForSwiftPropertyName
    }
    
    var formattedForSwiftPropertyName: String {
        return camelCased.prependedUnderscoreIfStartingWithDigit.removingOccurrences(of: SwiftLanguage.disallowedPropertyNameCharacters)
    }
    
    var isFormattedForSwiftTypeName: Bool {
        return self == formattedForSwiftTypeName
    }
    
    var formattedForSwiftTypeName: String {
        return typeCamelCased.prependedUnderscoreIfStartingWithDigit.removingOccurrences(of: SwiftLanguage.disallowedTypeNameCharacters)
    }
    
    var madeSingleFromPlural: String {
        return String(self.dropLast())
    }
}
