//
//  AlarmGenerateTableViewCell.swift
//  clock-app
//
//  Created by Jun on 2023/02/23.
//

import UIKit

class AlarmGenerateTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    var cellIndex = 0{
        didSet{
            setupUI()
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        print(self.subviews.last)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupUI(){
        self.backgroundColor = UIColor(named: "ModalSettingTableViewColor")
        
        switch cellIndex{
        case 0:
            setupRepeat()
        case 1:
            setupLabel()
        case 2:
            setupSound()
        case 3:
            setupAgain()
        default:
            break
        }
    }
    
    func setupRepeat(){
        titleLabel.text = "반복"
        detailLabel.text = "안 함"
    }
    
    func setupLabel(){
        titleLabel.text = "레이블"
        detailLabel.text = "알람"
    }
    
    func setupSound(){
        titleLabel.text = "사운드"
        detailLabel.text = "공상음"
    }
    
    func setupAgain(){
        titleLabel.text = "다시 알림"
        detailLabel.text = "버튼"
    }

}
