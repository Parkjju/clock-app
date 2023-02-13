//
//  WorldClockSelectTableViewCell.swift
//  clock-app
//
//  Created by 박경준 on 2023/02/13.
//

import UIKit

class WorldClockSelectTableViewCell: UITableViewCell {
    
    var data: String?{
        didSet{
            mainLabel.text = data
        }
    }
    
    @IBOutlet weak var mainLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        mainLabel.tintColor = .white
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
