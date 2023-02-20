//
//  WorldClockTableViewCell.swift
//  clock-app
//
//  Created by 박경준 on 2023/02/13.
//

import UIKit

class WorldClockTableViewCell: UITableViewCell {
    let worldClockManager = WorldClockManager.shared
    
    var clockData: WorldClockData?{
        didSet{
            setLabel()
        }
    }
    
    @IBOutlet weak var offsetLabel: UILabel!
    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var noon: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setLabel(){
        guard let clock = clockData else {
            print("Clock data load error in worldClockTableViewCell")
            return
        }
        print(clock)
        
        guard let tz = clock.timezone else {
            return
        }
        
        regionLabel.text = clock.region
        timeLabel.text = worldClockManager.getTimeFromTimeZone(timezone: tz, isNoon: false)
        offsetLabel.text =  worldClockManager.getOffsetFromTimeZone(timezone: tz)
        noon.text = worldClockManager.getTimeFromTimeZone(timezone: tz, isNoon: true)
        
    }

}
