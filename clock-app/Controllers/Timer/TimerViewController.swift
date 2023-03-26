//
//  TimerViewController.swift
//  clock-app
//
//  Created by 박경준 on 2023/03/23.
//

import UIKit

class TimerViewController: UIViewController {
    var time: [[Int]]{
        get{
            return setTime()
        }
    }
    
    
    
    @IBOutlet weak var timePicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(setTime())

        setupUI()
        setupController()
    }
    
    func setTime() -> [[Int]]{
        var hour: [Int] = []
        var minuteAndSecond: [Int] = []
        
        for i in 0...23{
            hour.append(i)
        }
        
        for i in 0...59{
            minuteAndSecond.append(i)
        }
        
        return [hour, minuteAndSecond, minuteAndSecond]
    }
    
    func setupUI(){
        timePicker.setValue(UIColor.white, forKey: "textColor")
    }
    
    func setupController(){
        timePicker.delegate = self
        timePicker.dataSource = self
    }
}

extension TimerViewController: UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch(component){
        case 0:
            return "\(time[component][row])"
        case 1:
            return "\(time[component][row])"
        case 2:
            return "\(time[component][row])"
        default:
            return nil
        }
    }
    
    
}

extension TimerViewController: UIPickerViewDataSource{
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return time[component].count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return time.count
    }
}

