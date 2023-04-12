//
//  TimerViewController.swift
//  clock-app
//
//  Created by 박경준 on 2023/03/23.
//

import UIKit

// 뒷단에 숨겨진 타이머를 계속 select하는 방식으로 로직을 처리한다
class TimerViewController: UIViewController {
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var timerView: UIView!
    @IBOutlet weak var timerInnerView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var ringtoneSelectView: UIView!
    @IBOutlet weak var rintoneSelectView: UIView!
    @IBOutlet weak var timeSubLabel: UILabel!
    @IBOutlet weak var ringtoneLabel: UILabel!
    
    var timer = Timer()
    
    var notificationId: String = ""
    
    let date: DateFormatter = {
        let df = DateFormatter()
        df.locale = Locale(identifier: "ko_KR")
        df.timeZone = TimeZone(abbreviation: "KST")
        df.dateFormat = "a HH:mm"
        return df
    }()
    
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
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ringtoneSelectViewTapped))
        ringtoneSelectView.addGestureRecognizer(tap)
        ringtoneSelectView.isUserInteractionEnabled = true
    }
    
    @objc func ringtoneSelectViewTapped(){
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.ringtoneSelectView.layer.opacity = 0.6
            self?.ringtoneSelectView.layer.opacity = 1
        }
        performSegue(withIdentifier: "TimerRingtoneSelectView", sender: self)
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
        
        NotificationService.sharedInstance.UNCurrentCenter.removePendingNotificationRequests(withIdentifiers: [notificationId])
        
        resetTimer()
    }
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        
        if(timePicker.selectedRow(inComponent: 0) == 0 && timePicker.selectedRow(inComponent: 1) == 0 && timePicker.selectedRow(inComponent: 2) == 0){
            return
        }
        
        self.paused = !paused
        
        guard isOn == true else {
            self.paused = false
            isOn = true
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimeLabel), userInfo: nil, repeats: true)
            timer.fire()
            
            // 노티피케이션 아이디 지정
            notificationId = "\(getAlertTimeWithTimeInterval())"
            
            // 알람 시간 리턴함수
            timeSubLabel.text = date.string(from: Date(timeIntervalSinceNow:getAlertTimeWithTimeInterval()))

            // 푸시알람 설정
            // notification id는 timeinterval로 설정
            NotificationService.sharedInstance.requestAlarmNotification(nil, type: "Timer", title: "시계", subtitle: "타이머", sound: translateSoundName(text: ringtoneLabel.text!), withInterval: getAlertTimeWithTimeInterval() + 1, notificationId: notificationId)
            return
        }
        
        if(paused){
            timer.invalidate()
            timeSubLabel.textColor = .darkGray
            NotificationService.sharedInstance.UNCurrentCenter.removePendingNotificationRequests(withIdentifiers: [notificationId])
        }else{
            timeSubLabel.textColor = .white
            timer.invalidate()
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimeLabel), userInfo: nil, repeats: true)
            
            notificationId = "\(getAlertTimeWithTimeInterval())"
            NotificationService.sharedInstance.requestAlarmNotification(nil, type: "Timer", title: "시계", subtitle: "타이머", sound: translateSoundName(text: ringtoneLabel.text!), withInterval: getAlertTimeWithTimeInterval() + 1, notificationId: notificationId)
        }
    }
    
    func getAlertTimeWithTimeInterval() -> TimeInterval{
        let hour = timePicker.selectedRow(inComponent: 0)
        let minute = timePicker.selectedRow(inComponent: 1)
        let second = timePicker.selectedRow(inComponent: 2)
        
        return TimeInterval(hour * 3600 + minute * 60 + second)
    }
    
    @objc func updateTimeLabel(){
        if(timePicker.selectedRow(inComponent: 0) == 0 && timePicker.selectedRow(inComponent: 1) == 0 && timePicker.selectedRow(inComponent: 2) == 0){
            isOn = false
            paused = true
            resetTimer()
            return
        }
        let hour = timePicker.selectedRow(inComponent: 0) / 10 < 1 ? "0\(timePicker.selectedRow(inComponent: 0))" : "\(timePicker.selectedRow(inComponent: 0))"
        let minute = timePicker.selectedRow(inComponent: 1) / 10 < 1 ? "0\(timePicker.selectedRow(inComponent: 1))" : "\(timePicker.selectedRow(inComponent: 1))"
        let second = timePicker.selectedRow(inComponent: 2) / 10 < 1 ? "0\(timePicker.selectedRow(inComponent: 2))" : "\(timePicker.selectedRow(inComponent: 2))"
        
        // 시간에 대한 picker가 0값이면
        if(timePicker.selectedRow(inComponent: 0) == 0){
            timeLabel.text = "\(minute):\(second)"
            timeLabel.font = timeLabel.font.withSize(82)
        }else{
            timeLabel.text = "\(hour):\(minute):\(second)"
            timeLabel.font = timeLabel.font.withSize(78)
        }
        
        // 초가 0초면 -> 분을 1개 줄이고 초는 59초
        // 분이 0분이면 -> 시를 1시간 줄이고 분은 59분, 초도 59초
        if(timePicker.selectedRow(inComponent: 2) > 0){
            let selected = timePicker.selectedRow(inComponent: 2)
            timePicker.selectRow(selected - 1, inComponent: 2, animated: false)
        }else if(timePicker.selectedRow(inComponent: 1) > 0){
            let selected = timePicker.selectedRow(inComponent: 1)
            timePicker.selectRow(selected - 1, inComponent: 1, animated: false)
            timePicker.selectRow(59, inComponent: 2, animated: false)
        }else if(timePicker.selectedRow(inComponent: 0) > 0){
            let selected = timePicker.selectedRow(inComponent: 0)
            timePicker.selectRow(selected - 1, inComponent: 0, animated: false)
            timePicker.selectRow(59, inComponent: 1, animated: false)
            timePicker.selectRow(59, inComponent: 2, animated: false)
        }else{
            return
        }
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
        timePicker.selectRow(0, inComponent: 0, animated: false)
        timePicker.selectRow(0, inComponent: 1, animated: false)
        timePicker.selectRow(0, inComponent: 2, animated: false)
    }
    
    // 커스텀델리게이트 패턴 적용을 위해 preparesegue 호출
    // segue가 naviagation으로 연결되므로 guard let 바인딩 한번 더 진행
    // 도착지 뷰 컨트롤러가 현재 레이블 기준으로 알람음 선택이 되어 있어야 함.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "TimerRingtoneSelectView"){
            guard let destinationNavigationVC = segue.destination as? UINavigationController else {
                return
            }
            
            guard let destination = destinationNavigationVC.viewControllers[0] as? TimerRingtoneSelectViewController else {
                return
            }
            
            guard let ringtoneLabel = ringtoneLabel.text else {
                return
            }
            
//            destination.loadViewIfNeeded()
//
//            switch(ringtoneLabel){
//            case "실행 중단":
//                break
//            case "공상음":
//                destination.tableView.visibleCells[0].accessoryType = .checkmark
//            case "녹차":
//                destination.tableView.visibleCells[1].accessoryType = .checkmark
//            case "놀이 시간":
//                destination.tableView.visibleCells[2].accessoryType = .checkmark
//            case "물결":
//                destination.tableView.visibleCells[3].accessoryType = .checkmark
//            default:
//                break
//            }
            
            destination.delegate = self
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

extension TimerViewController: AlarmSoundDelegate{
    func soundUpdate(index: Int) {
        switch(index){
        case 0:
            ringtoneLabel.text = "공상음"
        case 1:
            ringtoneLabel.text = "녹차"
        case 2:
            ringtoneLabel.text = "놀이 시간"
        case 3:
            ringtoneLabel.text = "물결"
        default:
            break
        }
    }
}
