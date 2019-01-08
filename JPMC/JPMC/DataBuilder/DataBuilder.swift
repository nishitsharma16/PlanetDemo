//
//  DataBuilder.swift
//  BeerCraft
//
//  Created by B0095764 on 1/8/19.
//  Copyright © 2018 Mine. All rights reserved.
//

import Foundation

struct DataBuilder<DataElement : DataInitializer> {
    
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
    
    func getParsedData(withData dataObject : [AnyHashable : Any]?) -> DataElement? {
        if let object = dataObject {
            let dataObject = DataElement(withData: object)
            return dataObject
        }
        return nil
    }
}
