//
//  DataInitializer.swift
//  BeerCraft
//
//  Created by B0095764 on 1/8/19.
//  Copyright © 2018 Mine. All rights reserved.
//

import Foundation

/**
 This Protocol is to provide requirements for initializing any application object such as Planet.
 */

protocol DataInitializer {
    init(withData data : [AnyHashable : Any])
}
