//
//  TimerViewController.swift
//  clock-app
//
//  Created by 박경준 on 2023/03/23.
//

import UIKit

class TimerViewController: UIViewController {
    
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var timerView: UIView!
    @IBOutlet weak var timerInnerView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var ringtoneSelectView: UIView!
    
    var timer = Timer()
    
    var isOn: Bool = false{
        didSet{
            if(isOn){
                cancelButton.setTitleColor(.white, for: .normal)
                startButton.setTitle("일시 정지", for: .normal)
                startButton.setTitleColor(UIColor(named: "pauseTextColor"), for: .normal)
                startButton.backgroundColor = UIColor(named:"pauseColor")
                timePicker.isHidden = true
                timerView.isHidden = false
                
                setupTimerUI()
            }else{
                cancelButton.setTitleColor(.gray, for: .normal)
            }
        }
    }
    
    var paused: Bool = false{
        didSet{
            if(paused){
                startButton.backgroundColor = UIColor(named:"startColor")
                startButton.setTitleColor(UIColor(named:"startTextColor"), for: .normal)
                startButton.setTitle("재개", for: .normal)
            }else{
                startButton.backgroundColor = UIColor(named:"pauseColor")
                startButton.setTitleColor(UIColor(named:"pauseTextColor"), for: .normal)
                startButton.setTitle("일시 정지", for: .normal)
            }
        }
    }
    
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
        timerView.isHidden = true
        timePicker.setValue(UIColor.white, forKey: "textColor")
        
        cancelButton.layer.cornerRadius = 40
        startButton.layer.cornerRadius = 40
        
        cancelButton.setTitle("취소", for: .normal)
        cancelButton.backgroundColor = UIColor(named: "ModalColor")
        cancelButton.setTitleColor(.gray, for: .normal)
        
        ringtoneSelectView.backgroundColor = UIColor(named: "ModalSettingTableViewColor")
        ringtoneSelectView.clipsToBounds = true
        ringtoneSelectView.layer.cornerRadius = 10
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
    
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        isOn = false
        paused = true
        
        resetTimer()
    }
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        
        self.paused = !paused
        
        guard isOn == true else {
            self.paused = false
            isOn = true
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimeLabel), userInfo: nil, repeats: true)
            return
        }
        
        if(paused){
            timer.invalidate()
        }else{
            timer.invalidate()
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimeLabel), userInfo: nil, repeats: true)
        }
    }
    
    @objc func updateTimeLabel(){
        let hour = timePicker.selectedRow(inComponent: 0) / 10 < 1 ? "0\(timePicker.selectedRow(inComponent: 0))" : "\(timePicker.selectedRow(inComponent: 0))"
        let minute = timePicker.selectedRow(inComponent: 1) / 10 < 1 ? "0\(timePicker.selectedRow(inComponent: 1))" : "\(timePicker.selectedRow(inComponent: 1))"
        let second = timePicker.selectedRow(inComponent: 2) / 10 < 1 ? "0\(timePicker.selectedRow(inComponent: 2))" : "\(timePicker.selectedRow(inComponent: 2))"
        
    }
    
    func setupTimerUI(){
        timerView.backgroundColor = .systemOrange
        timerView.clipsToBounds = true
        timerView.layer.cornerRadius = timerView.layer.bounds.width / 2
        
        timerInnerView.backgroundColor = .black
        timerInnerView.clipsToBounds = true
        timerInnerView.layer.cornerRadius =  timerInnerView.layer.bounds.width / 2
        
        timePicker.alpha = 1
        timerView.alpha = 0
        
        UIView.animate(withDuration: 0.6) {[weak self] in
            self?.timePicker.alpha = 0
            self?.timerView.alpha = 1
        }
    }
    
    func resetTimer(){
        timer.invalidate()
        timePicker.isHidden = false
        timerView.isHidden = true
        UIView.animate(withDuration: 0.6) { [weak self] in
            self?.timerView.alpha = 0
            self?.timePicker.alpha = 1
        }
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
            // 0.1 0.2 0.3 .... -> 픽셀 아님!!
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
