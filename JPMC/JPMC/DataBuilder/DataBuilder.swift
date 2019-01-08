//
//  DataBuilder.swift
//  BeerCraft
//
//  Created by B0095764 on 1/8/19.
//  Copyright © 2018 Mine. All rights reserved.
//

import Foundation

/**
 This Type is to used for data parser for objects which are conforming to DataInitializer protocol.
 */

struct DataBuilder<DataElement : DataInitializer> {
    
    /**
     This method will be used for parsing application data objects from JSON object. And it's a generic method which will parse data and return list of DataElement if DataElement has conforms to DataInitializer protocol.
     - Parameter jsonList: jsonList is JSON object to parse.
     - Returns: returnvalue List of Generic Element which conforms to DataInitializer protocol.
     */
    
    func getParsedDataList(withData jsonList : [Any]?) -> [DataElement]? {
        if let dataList = jsonList {
            var list = [DataElement]()
            for item in dataList {
                if let dataItem = item as? [AnyHashable : Any] {
                    let dataObject = DataElement(withData: dataItem)
                    list.append(dataObject)
                }
            }
            return list
        }
        return nil
    }
}
