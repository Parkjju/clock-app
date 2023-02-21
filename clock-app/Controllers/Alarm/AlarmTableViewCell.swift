//
//  AlarmTableViewCell.swift
//  clock-app
//
//  Created by 박경준 on 2023/02/21.
//

import UIKit

class AlarmTableViewCell: UITableViewCell {
    var alarmData: AlarmData?{
        didSet{
            setupUI()
        }
    }

    @IBOutlet weak var noonLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var switchButton: UISwitch!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setupUI(){
        guard let alarmData = alarmData else {
            print("?")
            return
        }

        
        timeLabel.text = alarmData.time
        noonLabel.text = alarmData.noon
        descriptionLabel.text = alarmData.description
        switchButton.isOn = alarmData.isOn
        
        switchButton.backgroundColor = .darkGray
        switchButton.layer.cornerRadius = switchButton.bounds.size.height / 2

        
        if(alarmData.isOn){
            timeLabel.textColor = .white
            noonLabel.textColor = .white
            descriptionLabel.textColor = .white
        }else{
            timeLabel.textColor = .lightGray
            noonLabel.textColor = .lightGray
            descriptionLabel.textColor = .lightGray
        }
        
        
        
    }

    @IBAction func switchButtonTapped(_ sender: UISwitch) {
        if(switchButton.isOn){
            timeLabel.textColor = .white
            noonLabel.textColor = .white
            descriptionLabel.textColor = .white
        }else{
            timeLabel.textColor = .lightGray
            noonLabel.textColor = .lightGray
            descriptionLabel.textColor = .lightGray
            
        }
    }
}
