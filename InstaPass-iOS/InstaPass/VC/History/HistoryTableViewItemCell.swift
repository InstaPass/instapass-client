//
//  HistoryTableViewItemCell.swift
//  InstaPass
//
//  Created by 法好 on 2020/6/30.
//  Copyright © 2020 yuetsin. All rights reserved.
//

import UIKit

class HistoryTableViewItemCell: UITableViewCell {

    @IBOutlet weak var titleImageView: UIImageView!
    @IBOutlet weak var outingTimeLabel: UILabel!
    @IBOutlet weak var outingReasonLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setState(inside: Bool) {
        if inside {
            titleImageView.image = UIImage(systemName: "mount.fill")
        } else {
            titleImageView.image = UIImage(systemName: "eject.fill")
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
