//
//  WebEngineDataDownloader.swift
//  BeerCraft
//
//  Created by B0095764 on 1/8/19.
//  Copyright © 2018 Mine. All rights reserved.
//

import Foundation

protocol WebEngineDataDownloader {
    func createDataRequest(withPath path : String, withParam param: [AnyHashable : Any]?, withCustomHeader headers : [String : String]?, withRequestType type : RequestType, withCompletion completion : ((Any?, DataError?) -> Void)?)
}
