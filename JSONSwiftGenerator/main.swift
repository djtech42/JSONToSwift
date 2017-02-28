//
//  main.swift
//  JSONSwiftGenerator
//
//  Created by Brenden Konnagan on 2/28/17.
//  Copyright © 2017 Bren. All rights reserved.
//

import Foundation

let sourcePath = IOWrapper.getInputFile()
let rootObjectName = IOWrapper.getNameForObject()
let jsonToSwift = JSONToSwift(with: sourcePath, rootObjectName: rootObjectName)
do {
    try jsonToSwift.convert()
} catch {
    print("Error! : \(String(describing: error))")
}
