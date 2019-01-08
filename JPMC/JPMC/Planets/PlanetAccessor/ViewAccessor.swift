//
//  ViewAccessor.swift
//  JPMC
//
//  Created by B0095764 on 1/8/19.
//  Copyright © 2019 Mine. All rights reserved.
//

import Foundation

protocol TableViewAccessor {
    associatedtype Item
    func numberOfSections() -> Int
    func numberOfRows(section : Int) -> Int
    subscript (index : Int) -> Item? {get}
}
