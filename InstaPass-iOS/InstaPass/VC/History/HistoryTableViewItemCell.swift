//
//  HistoryTableViewItemCell.swift
//  InstaPass
//
//  Created by 法好 on 2020/6/30.
//  Copyright © 2020 yuetsin. All rights reserved.
//

import UIKit

class HistoryTableViewItemCell: UITableViewCell {

    @IBOutlet weak var outingTimeLabel: UILabel!
    @IBOutlet weak var outingReasonLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
