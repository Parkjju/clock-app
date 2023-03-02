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
        
        // 시간 숫자 세팅
        guard let time = alarmData.time else {
            return
        }
        timeLabel.text = "\(setupTimeString(time: time).0)"
        
        // 오전오후 세팅
        noonLabel.text = setupTimeString(time: time).1
        
        descriptionLabel.text = alarmData.label
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
    
    func setupTimeString(time: Date) -> (String, String){
        var isNoon = false
        let timeString = "\(time)".split(separator: " ")[1]
        var timeArray = timeString.split(separator: ":").map { str in
            String(str)
        }
        
        if(Int(timeArray[0])! > 12){
            timeArray[0] = String(Int(timeArray[0])! - 12)
            isNoon = true
        }
        
        let _ = timeArray.popLast()
        
        let timeJoinedString = timeArray.joined(separator: ":")
        
        return (timeJoinedString, isNoon ? "오후" : "오전")
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
