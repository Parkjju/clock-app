//
//  TimerViewController.swift
//  clock-app
//
//  Created by 박경준 on 2023/03/23.
//

import UIKit

class TimerViewController: UIViewController {

    
    @IBOutlet weak var timePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    func setupUI(){
        timePicker.setValue(UIColor.white, forKey: "textColor")
        timePicker.locale = Locale(identifier: "ko_KR")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
