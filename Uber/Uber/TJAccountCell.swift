//
//  TJAccountCell.swift
//  Uber
//
//  Created by Tony Jin on 6/15/16.
//  Copyright © 2016 Innovatis Tech. All rights reserved.
//

import UIKit

class TJAccountCell: UITableViewCell {
    
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var labelName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
