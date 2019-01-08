//
//  CoreDataStackProtocol.swift
//  ReatilStore
//
//  Created by B0095764 on 1/8/19.
//  Copyright © 2018 Mine. All rights reserved.
//

import Foundation

/**
 This Protocol is to provide requirements for making any object as Cache Manager.
 */

protocol CacheProtocol {
    func getData(forKey key : String, withCompletion completion : @escaping (Any?) -> Void)
    func saveData(withData data : Any, forKey key : String, withCompletion completion : @escaping (Bool) -> Void)
}
