//
//  ViewAccessor.swift
//  JPMC
//
//  Created by B0095764 on 1/8/19.
//  Copyright © 2019 Mine. All rights reserved.
//

import Foundation

/**
 This Generic Protocol is to provide requirements for making any type as View Model to Interact with View in MVVM Design Pattern.
 */

protocol TableViewAccessor {
    associatedtype Item
    func numberOfSections() -> Int
    func numberOfRows(section : Int) -> Int
    subscript (index : Int) -> Item? {get}
}
