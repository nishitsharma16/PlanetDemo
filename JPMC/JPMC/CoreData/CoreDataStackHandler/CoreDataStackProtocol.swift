//
//  CoreDataStackProtocol.swift
//  ReatilStore
//
//  Created by B0095764 on 1/8/19.
//  Copyright © 2018 Mine. All rights reserved.
//

import Foundation

/**
 This Protocol is to provide requirements for making any object as Core Data Manager.
 */

protocol CoreDataStackProtocol {
    var momFileName : String { get }
    func initializeCoreDataStack(withCompletion completion : ((Bool) -> Void)?)
}

protocol CoreDataAccessorProtocol {
    func getData(forPath path : String, withCompletion completion : @escaping (Any?) -> Void)
    func saveData(withData data : Any, forPath path : String, withCompletion completion : @escaping (Bool) -> Void)
    func updateData(withData data : Any, forPath path : String, withCompletion completion : @escaping (Bool) -> Void)
}
