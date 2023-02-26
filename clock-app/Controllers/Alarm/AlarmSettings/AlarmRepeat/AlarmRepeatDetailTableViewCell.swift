//
//  AlarmRepeatDetailTableViewCell.swift
//  clock-app
//
//  Created by Jun on 2023/02/24.
//

import UIKit

class AlarmRepeatDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var choiceLabel: UILabel!
    
    var day: Int?{
        didSet{
            setupDay()
        }
    }
    var isCheck: Bool?{
        didSet{
            setupChecked()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    func setupDay(){
        switch day{
        case 0:
            choiceLabel.text = "일요일마다"
        case 1:
            choiceLabel.text = "월요일마다"
        case 2:
            choiceLabel.text = "화요일마다"
        case 3:
            choiceLabel.text = "수요일마다"
        case 4:
            choiceLabel.text = "목요일마다"
        case 5:
            choiceLabel.text = "금요일마다"
        case 6:
            choiceLabel.text = "토요일마다"
        default:
            break
        }
        
    }
    
    func setupChecked(){
        guard let isCheck = isCheck else {
            return
        }
        if(isCheck){
            self.accessoryType = .checkmark
        }else{
            self.accessoryType = .none
        }
    }

}
