//
//  main.swift
//  JSONSwiftGenerator
//
//  Created by Brenden Konnagan on 2/28/17.
//  Copyright © 2017 Bren. All rights reserved.
//

import Foundation

do {
    try LaunchRouter.run()
}
catch {
    let errorString = String(describing: error)
    print("*** Error: \(errorString)")
}
