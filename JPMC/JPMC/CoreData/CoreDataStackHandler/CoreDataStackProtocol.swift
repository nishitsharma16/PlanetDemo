//
//  CoreDataStackProtocol.swift
//  ReatilStore
//
//  Created by B0095764 on 1/8/19.
//  Copyright © 2018 Mine. All rights reserved.
//

import Foundation

protocol CoreDataStackProtocol {
    var momFileName : String { get }
    func initializeCoreDataStack(withCompletion completion : ((Bool) -> Void)?)
}
