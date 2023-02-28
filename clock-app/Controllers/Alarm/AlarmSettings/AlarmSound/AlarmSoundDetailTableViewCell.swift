//
//  AlarmSoundDetailTableViewCell.swift
//  clock-app
//
//  Created by 박경준 on 2023/02/28.
//

import UIKit

class AlarmSoundDetailTableViewCell: UITableViewCell {
    var text: String?{
        didSet{
            mainLabel.text = text
        }
    }
    
    @IBOutlet weak var mainLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupUI(){
        mainLabel.textColor = .white
    }

}
