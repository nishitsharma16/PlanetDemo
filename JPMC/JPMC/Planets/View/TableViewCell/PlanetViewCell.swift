//
//  PlanetViewCell.swift
//  JPMC
//
//  Created by B0095764 on 1/8/19.
//  Copyright © 2019 Mine. All rights reserved.
//

import UIKit

class PlanetViewCell: UITableViewCell, CellUpdateProtocol {

    @IBOutlet weak var planetTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateCell(withData data : PlanetAccessor?) {
        planetTitle.text = data?.planetName
    }
}
