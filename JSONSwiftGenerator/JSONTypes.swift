//
//  JSONTypes.swift
//  JSONSwiftGenerator
//
//  Created by Dan Turner on 3/3/17.
//  Copyright © 2017 Bren. All rights reserved.
//

import Foundation

indirect enum JSONType {
    case array
    case arrayOf(type: JSONType?)
    case object
    case string
    case number
    case boolean
}
