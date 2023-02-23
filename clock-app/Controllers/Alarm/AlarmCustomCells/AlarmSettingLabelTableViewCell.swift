//
//  AlarmSettingLabelTableViewCell.swift
//  clock-app
//
//  Created by 박경준 on 2023/02/23.
//

import UIKit

class AlarmSettingLabelTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
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
        self.titleLabel.text = "레이블"
        textField.placeholder = "알람"
        textField.attributedPlaceholder = NSAttributedString(
            string: "알람",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        )
        
        textField.borderStyle = .none
    }
    
}

extension AlarmSettingLabelTableViewCell: UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("hi")
    }
}
