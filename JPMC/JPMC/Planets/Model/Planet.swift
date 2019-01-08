//
//  Planet.swift
//  JPMC
//
//  Created by B0095764 on 1/8/19.
//  Copyright © 2019 Mine. All rights reserved.
//

import Foundation

/*
 {
 "name": "Alderaan",
 "rotation_period": "24",
 "orbital_period": "364",
 "diameter": "12500",
 "climate": "temperate",
 "gravity": "1 standard",
 "terrain": "grasslands, mountains",
 "surface_water": "40",
 "population": "2000000000",
 "residents": [
 "https://swapi.co/api/people/5/",
 "https://swapi.co/api/people/68/",
 "https://swapi.co/api/people/81/"
 ],
 "films": [
 "https://swapi.co/api/films/6/",
 "https://swapi.co/api/films/1/"
 ],
 "created": "2014-12-10T11:35:48.479000Z",
 "edited": "2014-12-20T20:58:18.420000Z",
 "url": "https://swapi.co/api/planets/2/"
 }
 */

struct Planet : DataInitializer, PlanetAccessor {
    
    private let terrain : String
    private let gravity : String
    private let name : String
    private let climate : String
    
    var planetName : String {
        return name
    }
    
    var planetClimate : String {
        return climate
    }
    
    /**
     This method will be used for initializing Planet object from JSON object.
     - Parameter data: data is the JSON object.
     */
    
    init(withData data : [AnyHashable : Any]) {
        terrain = data["terrain"] as? String ?? Constants.noData
        gravity = data["gravity"] as? String ?? Constants.noData
        name = data["name"] as? String ?? Constants.noData
        climate = data["climate"] as? String ?? Constants.noData
    }
}
