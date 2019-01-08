//
//  PlanetManager.swift
//  JPMC
//
//  Created by B0095764 on 1/8/19.
//  Copyright © 2019 Mine. All rights reserved.
//

import Foundation

class PlanetManager {
    
    /**
     This method will be used for fetching planet data from "https://swapi.co/api/planets/" API end point.
     - Parameter completion: completion is the callback once data is fetched.
     */
    
    static func getPlanetData(withCompletion completion : @escaping ([Planet]?, DataError?) -> Void) {
        WebServiceManager.sharedInstance.createDataRequest(withPath: WebEngineConstant.planetAPI, withParam: nil, withCustomHeader: nil, withRequestType: .GET) { (data, error) in
            
            if let dataVal = data {
                DispatchQueue.global().async {
                    
                    var list : [Planet]?
                    
                    if let dataObjectInfo = dataVal as? [AnyHashable : Any], let dataList = dataObjectInfo["results"] as? [Any] {
                        let builder = DataBuilder<Planet>()
                        list = builder.getParsedDataList(withData: dataList)
                        list?.sort(by: { (first, second) -> Bool in
                            return first.planetName > second.planetName
                        })
                    }
                    
                    DispatchQueue.main.async {
                        completion(list, nil)
                    }
                }
            }
            else {
                if let err = error {
                    completion(nil, err)
                }
                else {
                    let errVal = DataError()
                    completion(nil, errVal)
                }
            }
        }
    }
}
