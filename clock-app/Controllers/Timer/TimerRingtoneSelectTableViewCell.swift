//
//  TimerRingtoneSelectTableViewCell.swift
//  clock-app
//
//  Created by Jun on 2023/04/03.
//

import UIKit

class TimerRingtoneSelectTableViewCell: UITableViewCell {

    @IBOutlet weak var soundLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupUI(){
        self.backgroundColor = UIColor(named: "ModalSettingTableViewColor")
        soundLabel.textColor = .white
    }
}
