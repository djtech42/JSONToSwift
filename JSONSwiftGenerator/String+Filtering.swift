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
    
    var removedSpaces: String {
        return removingOccurrences(of: " ")
    }
    
    var formattedForSwiftPropertyName: String {
        return camelCased.removingOccurrences(of: SwiftLanguage.disallowedPropertyNameCharacters)
    }
    
    var formattedForSwiftTypeName: String {
        return typeCamelCased.removingOccurrences(of: SwiftLanguage.disallowedTypeNameCharacters)
    }
}
