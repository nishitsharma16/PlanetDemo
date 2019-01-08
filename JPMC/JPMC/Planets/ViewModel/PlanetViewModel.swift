//
//  PlanetViewModel.swift
//  JPMC
//
//  Created by B0095764 on 1/8/19.
//  Copyright © 2019 Mine. All rights reserved.
//

import Foundation

class PlanetViewModel {
    
    var dataList : [Planet]?
    
    /**
     This method will be used for fetching planet data from "https://swapi.co/api/planets/" API end point.
     - Parameter completion: completion is the callback once data is fetched.
     */
    
    func getPlanetData(withCompletion completion : @escaping (Bool) -> Void) {
        PlanetManager.getPlanetData { [weak self] (list, error) in
            self?.dataList = list
            completion(true)
        }
    }
}

extension PlanetViewModel : TableViewAccessor {
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfRows(section : Int) -> Int {
        return self.dataList?.count ?? 0
    }
    
    subscript (index : Int) -> Planet? {
        return self.dataList?[index]
    }
}
