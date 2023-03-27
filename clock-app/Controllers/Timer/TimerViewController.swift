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

        setupUI()
        setupController()
        setupPickerLabel()
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
    
    func setupPickerLabel(){
        let hourLabel = UILabel()
        hourLabel.text = "시간"
        
        let minuteLabel = UILabel()
        minuteLabel.text = "분"
        
        let secondLabel = UILabel()
        secondLabel.text = "초"
        
        timePicker.setPickerLabels(labels: [0:hourLabel, 1: minuteLabel, 2: secondLabel], containedView: self.view)
        
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

extension UIPickerView{
    func setPickerLabels(labels: [Int:UILabel], containedView: UIView) { // [component number:label]
        
        let fontSize:CGFloat = 20
        let labelWidth:CGFloat = containedView.bounds.width / CGFloat(self.numberOfComponents)
        let x:CGFloat = self.frame.origin.x
        let y:CGFloat = (self.frame.size.height / 2) - (fontSize / 2)
        for i in 0...self.numberOfComponents {
            
            if let label = labels[i] {
                if(label.text!.count == 2){
                    label.frame = CGRect(x: x + labelWidth * CGFloat(i) + 36, y: y, width: labelWidth, height: fontSize)
                }else{
                    label.frame = CGRect(x: x + labelWidth * CGFloat(i) + 24, y: y, width: labelWidth, height: fontSize)
                }
                
                if self.subviews.contains(label) {
                    label.removeFromSuperview()
                }
    
                label.font = UIFont.boldSystemFont(ofSize: fontSize)
                label.backgroundColor = .clear
                label.textAlignment = NSTextAlignment.center
                label.textColor = .white
                self.addSubview(label)
            }
        }
    }
}
