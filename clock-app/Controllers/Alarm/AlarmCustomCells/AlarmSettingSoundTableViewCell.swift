//
//  AlarmSettingSoundTableViewCell.swift
//  clock-app
//
//  Created by 박경준 on 2023/02/23.
//

import UIKit

class AlarmSettingSoundTableViewCell: UITableViewCell {

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var chosenLabel: UILabel!
    
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
        self.titleLabel.text = "사운드"
        self.chosenLabel.text = "공상음"
        self.createCustomCellDisclosureIndicator(chevronColor: .lightGray)
    }
}

extension AlarmSettingSoundTableViewCell {
    func createCustomCellDisclosureIndicator(chevronColor: UIColor) {
        //MARK: Custom Accessory View
        //Chevron img
        if #available(iOS 13.0, *) {
            let chevronConfig = UIImage.SymbolConfiguration(pointSize: 14, weight: .medium)
            guard let chevronImg = UIImage(systemName: "chevron.right", withConfiguration: chevronConfig)?.withTintColor(chevronColor, renderingMode: .alwaysTemplate) else { return }
            let chevron = UIImageView(image: chevronImg)
            chevron.tintColor = chevronColor

            //chevron view
            let accessoryViewHeight = self.frame.height
            let customDisclosureIndicator = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: accessoryViewHeight))
            customDisclosureIndicator.addSubview(chevron)

            //chevron constraints
            chevron.translatesAutoresizingMaskIntoConstraints = false
            chevron.trailingAnchor.constraint(equalTo: customDisclosureIndicator.trailingAnchor,constant: 0).isActive = true
            chevron.centerYAnchor.constraint(equalTo: customDisclosureIndicator.centerYAnchor).isActive = true

            //Assign the custom accessory view to the cell
            customDisclosureIndicator.backgroundColor = .clear
            self.accessoryView = customDisclosureIndicator
        } else {
            self.accessoryType = .disclosureIndicator
            self.accessoryView?.tintColor = chevronColor
        }
    }
}
