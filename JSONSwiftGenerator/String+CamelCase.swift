//
//  String+CamelCase.swift
//  JSONSwiftGenerator
//
//  Created by Dan Turner on 3/3/17.
//  Copyright © 2017 Bren. All rights reserved.
//

import Foundation

extension String {
    var camelCased: String {
        if isUppercase {
            return self
        }
        else if let existingFirstCharacter = characters.first, existingFirstCharacter.isUppercase {
            return camelCasedUppercase()
        }
        else {
            return camelCasedLowercase()
        }
    }
    
    var typeCamelCased: String {
        let camelCasedString = camelCased
        let firstCharacter = camelCasedString.substring(to: index(startIndex, offsetBy: 1)).uppercased()
        let restOfString = String(camelCasedString.characters.dropFirst())
        
        return "\(firstCharacter)\(restOfString)"
    }
    
    private func camelCasedLowercase() -> String {
        let firstCharacter, restOfString: String
        
        if characters.contains(" ") || characters.contains("_") {
            firstCharacter = substring(to: index(startIndex, offsetBy: 1))
            let capitalizedWithoutSpaces = replacedUnderscoresWithSpaces.capitalized.removedSpaces
            restOfString = String(capitalizedWithoutSpaces.characters.dropFirst())
        } else {
            firstCharacter = substring(to: lowercased().index(startIndex, offsetBy: 1))
            restOfString = String(characters.dropFirst())
        }
        
        return "\(firstCharacter)\(restOfString)"
    }
    
    private func camelCasedUppercase() -> String {
        let firstCharacter, restOfString: String
        
        if characters.contains(" ") || characters.contains("_") {
            firstCharacter = lowercased().substring(to: index(startIndex, offsetBy: 1))
            let capitalizedWithoutSpaces = replacedUnderscoresWithSpaces.capitalized.removedSpaces
            restOfString = String(capitalizedWithoutSpaces.characters.dropFirst())
        } else {
            firstCharacter = lowercased().substring(to: index(startIndex, offsetBy: 1))
            restOfString = String(characters.dropFirst())
        }
        
        return "\(firstCharacter)\(restOfString)"
    }
}
