//
//  CellUpdateProtocol.swift
//  JPMC
//
//  Created by B0095764 on 1/8/19.
//  Copyright © 2019 Mine. All rights reserved.
//

import Foundation

protocol CellUpdateProtocol {
    associatedtype Item
    func updateCell(withData data : Item?)
}
