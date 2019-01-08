//
//  PlanetAccessor.swift
//  JPMC
//
//  Created by B0095764 on 1/8/19.
//  Copyright © 2019 Mine. All rights reserved.
//

import Foundation

/**
 This Protocol is to provide requirements for making any type as Planet or any type which want to provide requirements of planetName and planetClimate.
 */

protocol PlanetAccessor {
    var planetName : String { get }
    var planetClimate : String { get }
}
