//
//  StopWatchTableViewCell.swift
//  clock-app
//
//  Created by 박경준 on 2023/03/18.
//

import UIKit

class StopWatchTableViewCell: UITableViewCell {

    @IBOutlet weak var lapLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
