//
//  IOWrapper.swift
//  JSONSwiftGenerator
//
//  Created by Brenden Konnagan on 2/28/17.
//  Copyright © 2017 Bren. All rights reserved.
//

import Foundation

struct IOWrapper {
    static func getInputFile() -> URL {
        print("Please enter path to JSON data")
        guard let path = readLine(strippingNewline: true) else {
            return getInputFile()
        }
        return URL(fileURLWithPath: path)
    }
    static func getNameForObject() -> String {
        print("Please enter name for root object")
        return readLine(strippingNewline: true) ?? ""
    }
}
