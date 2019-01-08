//
//  CacheManager.swift
//  JPMC
//
//  Created by B0095764 on 1/8/19.
//  Copyright © 2019 Mine. All rights reserved.
//

import Foundation

final class CacheManager : CacheProtocol {
    
    static let sharedInstance = CacheManager()
    private var memCacheInfo = [String : Any]()
    
    private init() {
    }
    
    func getData(forKey key : String, withCompletion completion : @escaping (Any?) -> Void) {
        let keys = memCacheInfo.keys
        if keys.contains(key) {
            completion(memCacheInfo[key])
            return
        }
        
        CoreDataManager.sharedInstance.getData(forPath: key) { [weak self] (data) in
            if let dataVal = data {
                self?.memCacheInfo[key] = dataVal
                completion(dataVal)
            }
            else {
                self?.memCacheInfo.removeValue(forKey: key)
                completion(nil)
            }
        }
    }
    
    func saveData(withData data : Any, forKey key : String, withCompletion completion : @escaping (Bool) -> Void) {
        let keys = memCacheInfo.keys
        if keys.contains(key) {
            memCacheInfo[key] = data
            CoreDataManager.sharedInstance.updateData(withData: data, forPath: key, withCompletion: completion)
        }
        else {
            CoreDataManager.sharedInstance.saveData(withData: data, forPath: key, withCompletion: completion)
        }
    }
}
