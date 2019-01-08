//
//  DataError.swift
//  BeerCraft
//
//  Created by B0095764 on 1/8/19.
//  Copyright © 2018 Mine. All rights reserved.
//

import Foundation

class DataError {
    
    var errorMessage = Constants.defaultErrorMessage
    
    init() {
    }
    
    init(withError error : Error) {
        errorMessage = error.localizedDescription
    }
}
