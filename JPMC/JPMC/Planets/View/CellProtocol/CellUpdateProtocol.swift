//
//  CellUpdateProtocol.swift
//  JPMC
//
//  Created by B0095764 on 1/8/19.
//  Copyright © 2019 Mine. All rights reserved.
//

import Foundation

/**
 This Generic Protocol is to provide requirements for updating any UITableView Cell from a particular object of type Item.
 */

protocol CellUpdateProtocol {
    associatedtype Item
    func updateCell(withData data : Item?)
}
