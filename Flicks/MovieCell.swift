//
//  MovieCell.swift
//  Flicks
//
//  Created by Jiayi Kou on 1/10/16.
//  Copyright © 2016 Jiayi Kou. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {

    @IBOutlet var title: UILabel!
    @IBOutlet var overview: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
