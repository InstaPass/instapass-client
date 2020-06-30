//
//  StatusCell.swift
//  InstaPass
//
//  Created by 法好 on 2020/6/30.
//  Copyright © 2020 yuetsin. All rights reserved.
//

import UIKit

class HistoryTableViewStatusCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var outingStatusLabel: UILabel!
    @IBOutlet weak var approximateTimeCell: UILabel!
    @IBOutlet weak var lastTimeLabel: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
