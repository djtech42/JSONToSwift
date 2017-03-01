//
//  LaunchRouter.swift
//  JSONSwiftGenerator
//
//  Created by Brenden Konnagan on 3/1/17.
//  Copyright © 2017 Bren. All rights reserved.
//

import Foundation

struct LaunchRouter {
    static func run() throws {
        let argumentRouter = Input.checkArguments()
        guard let providedUrl = argumentRouter else {
            let inputFile = Input.getFilePath()
            try LaunchRouter.execute(with: inputFile)
            return
        }
        
        try LaunchRouter.execute(with: providedUrl)
    }
    
    fileprivate static func execute(with router: DataRouter) throws {
        guard let location = router.location else {
            throw JSONToSwiftError(message: "Invalid URL provided")
        }
        let objectName = Input.getNameForObject()
        let converter = JSONToSwift(with: location, rootObjectName: objectName)
        try converter.convert()
    }
}
