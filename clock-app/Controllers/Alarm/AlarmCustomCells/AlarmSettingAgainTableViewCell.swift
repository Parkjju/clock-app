//
//  AlarmSettingAgainTableViewCell.swift
//  clock-app
//
//  Created by 박경준 on 2023/02/23.
//

import UIKit

class AlarmSettingAgainTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var settingSwitch: UISwitch!
    
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
        self.titleLabel.text = "다시 알림"
        self.settingSwitch.isOn = true
    }

}

