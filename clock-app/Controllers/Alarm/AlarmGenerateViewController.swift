//
//  AlarmGenerateViewController.swift
//  clock-app
//
//  Created by Jun on 2023/02/22.
//

import UIKit
import AVFAudio
// audioPlayer는 전역적으로 선언되어 있음

class AlarmGenerateViewController: UIViewController {
    private var workItem: DispatchWorkItem?

    let alarmManager = AlarmManager.shared
    var alarmData: AlarmData?
    var notificationId: String = ""
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    let dict: [Int: String] = [
        0: "일",
        1: "월",
        2: "화",
        3: "수",
        4: "목",
        5: "금",
        6: "토"
    ]
    
    var checkedDayList: [Int: Bool] = [
        0: false,
        1: false,
        2: false,
        3: false,
        4: false,
        5: false,
        6: false,
    ]
    
    var checkedIndex = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupController()
        setupNavigationBar()
        setupUI()
    }
    
    func setupController(){
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setupNavigationBar(){
        self.title = "알람 추가"
        
        let leftBarButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(leftBarButtonTapped))
        leftBarButton.tintColor = .systemOrange
        
        let rightBarButton = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(rightBarButtonTapped))
        rightBarButton.tintColor = .systemOrange
        
        self.navigationItem.rightBarButtonItem = rightBarButton
        self.navigationItem.leftBarButtonItem = leftBarButton
        
    }
    
    @objc func leftBarButtonTapped(){
        self.dismiss(animated: true)
    }
    
    // isOn - 알람 활성화 또는 비활성화
    // isAgain - 10분 있다가 다시 알림
    @objc func rightBarButtonTapped(){
        // 최종 저장 시 newAlarmData time difference 계산 및 저장
        
        // isOn 요소 뽑아오기
        if(alarmData != nil){
            let newData = alarmData
            newData?.isOn = true
            newData?.time = datePicker.date
            newData?.label = getLabel()
            newData?.isAgain = getIsAgain()
            newData?.repeatDays = getRepeatDays()
            newData?.sound = getRingTone()
            
            alarmManager.updateAlarm(targetId:alarmData!.time!, newData: newData!) {
                self.reloadAfterChangeAlarmData()
            }
            
            // 기존 등록된 푸시알람데이터 삭제
        }else{
            alarmManager.saveAlarm(isOn: true, time: datePicker.date, label: getLabel(), isAgain: getIsAgain(), repeatDays: getRepeatDays(), sound: getRingTone()) {
                self.reloadAfterChangeAlarmData()
            }
            // 노티피케이션 아이디
            notificationId = "\(datePicker.date)"
        }
        // 벨소리 셀 불러오기
        guard let soundCell = tableView.visibleCells[2] as? AlarmSettingSoundTableViewCell else {
            return
        }
        
        let sound = translateSoundName(text: soundCell.chosenLabel.text ?? "")
        
        // 한국시간을 notificationId로 전달
        // 데이터가 추가되는 곳의 인덱스를 전달하여 추후 willPresent에서 삭제 대상의 인덱스를 notification의 userInfo에 저장한다
        // presenting VC의 테이블뷰를 가져와야됨
        
        NotificationService.sharedInstance.requestAlarmNotification(datePicker.date, type: "Alarm",title: "시계", subtitle: "알람", sound: sound, withInterval: nil, notificationId: notificationId, alarmManager.getSavedAlarm().count == 0 ? nil : alarmManager.getSavedAlarm().count, needToReloadTableView: getPresentingVCTableView()
        )
    }
    
    func reloadAfterChangeAlarmData(){
        guard let tabVC = self.presentingViewController as? UITabBarController else{
            return
        }


        guard let firstNavigationVC = tabVC.viewControllers![1] as? AlarmNavigationViewController else {
            return
        }

        guard let firstVC = firstNavigationVC.viewControllers.first as? AlarmViewController else {
            return
        }
        firstVC.tableView.reloadData()

        self.dismiss(animated: true)
    }
    
    func getPresentingVCTableView() -> UITableView{
        let tabBarVC = self.presentingViewController as! WorldClockTabBarViewController
        let alarmNavigationVC = tabBarVC.viewControllers?[1] as! AlarmNavigationViewController
        let alarmVC = alarmNavigationVC.viewControllers[0] as! AlarmViewController
        
        return alarmVC.tableView
    }
    
    
    
    func getRepeatDays() -> String{
        let repeatCell = tableView.visibleCells[0] as! AlarmSettingRepeatTableViewCell
        
        if let text = repeatCell.choiceLabel.text, text != "안 함"{
            return text
        }

        return ""
    }
    
    func getLabel() -> String{
        let labelCell = tableView.visibleCells[1] as! AlarmSettingLabelTableViewCell
        
        return labelCell.textField.text ?? ""
    }
    func getRingTone() -> String{
        let soundCell = tableView.visibleCells[2] as! AlarmSettingSoundTableViewCell
        
        return soundCell.chosenLabel.text ?? ""
    }
    
    func getIsAgain() -> Bool{
        let againCell = tableView.visibleCells[3] as! AlarmSettingAgainTableViewCell
        
        return againCell.settingSwitch.isOn
    }
    
    func setupUI(){
        // setupUI에서 만들어지는 id정보가 초기 id정보
        if let alarmData = alarmData{
            notificationId = "\(getCurrentDateFromSimulator(date: alarmData.time!))"
        }
        
        datePicker.setValue(UIColor.white, forKey: "textColor")
        datePicker.timeZone = TimeZone.current
        
        tableView.backgroundColor = UIColor(named: "ModalSettingTableViewColor")
        tableView.layer.cornerRadius = 10
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    // 델리게이트 연결
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "AlarmDetailRepeat"){
            guard let repeatVC = segue.destination as? AlarmRepeatDetailViewController else {
                return
            }
            
            repeatVC.delegate = self
            repeatVC.checkedDayList = self.checkedDayList
        }else if(segue.identifier == "AlarmSoundDetailViewController"){
            guard let soundVC = segue.destination as? AlarmSoundDetailViewController else {
                return
            }
            
            soundVC.delegate = self
            soundVC.checkedIndex = self.checkedIndex
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        tableView.endEditing(true)
    }
    
    func playSound(fileName: String) {
        if(fileName == ""){
            return
        }
        guard let path = Bundle.main.path(forResource: fileName, ofType:"mp3") else {
                print("bundle error")
                return
        }
            let url = URL(fileURLWithPath: path)
        
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            
            guard let player = audioPlayer else {
                print("player load error")
                return
            }
            
            // play atTime
            player.prepareToPlay()
            player.play()
        }catch{
            print("audio load error")
            print(error.localizedDescription)
        }
    }
}

extension AlarmGenerateViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row{
        case 0:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmSettingRepeatTableViewCell", for: indexPath) as! AlarmSettingRepeatTableViewCell
            cell.backgroundColor = UIColor(named: "ModalSettingTableViewColor")
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmSettingLabelTableViewCell", for: indexPath) as! AlarmSettingLabelTableViewCell
            cell.backgroundColor = UIColor(named: "ModalSettingTableViewColor")
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmSettingSoundTableViewCell", for: indexPath) as! AlarmSettingSoundTableViewCell
            cell.backgroundColor = UIColor(named: "ModalSettingTableViewColor")
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmSettingAgainTableViewCell", for: indexPath) as! AlarmSettingAgainTableViewCell
            cell.backgroundColor = UIColor(named: "ModalSettingTableViewColor")
            return cell
        default:
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
}

extension AlarmGenerateViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension AlarmGenerateViewController: AlarmManagerDelegate{
    
    func repeatUpdate(index: Int) {
        guard let repeatTableViewCell = tableView.visibleCells[0] as? AlarmSettingRepeatTableViewCell else {
            return
        }
        
        repeatTableViewCell.choiceLabel.text = ""
        
        // 1. 커스텀 델리게이트 패턴으로 체크마크 요일 목록을 받아온다
        // 2. 체크 목록을 Boolean 타입 값으로 딕셔너리 체킹을 하고
        // 3. 최종적으로 레이블을 바꿔준다.
        if(checkedDayList[index]!){
            checkedDayList[index] = false
        }else{
            checkedDayList[index] = true
        }
        
        
        for checkedDay in checkedDayList{
            if(checkedDay.value){
                repeatTableViewCell.choiceLabel.text?.append(contentsOf: "\(dict[checkedDay.key]!) ")
            }
        }
        
        // 아무것도 체크되지 않았으면 안함 텍스트로 변경
        if(repeatTableViewCell.choiceLabel.text?.count == 0){
            repeatTableViewCell.choiceLabel.text = "안 함"
        }
        
        tableView.reloadData()
        
        
    }
        
}
    
extension AlarmGenerateViewController: AlarmSoundDelegate{
    func soundUpdate(index: Int) {
        
        self.checkedIndex = index
        guard let cell = tableView.visibleCells[2] as? AlarmSettingSoundTableViewCell else{
            return
        }
        
        switch index{
        case 0:
            cell.chosenLabel.text = "공상음"
        case 1:
            cell.chosenLabel.text = "녹차"
        case 2:
            cell.chosenLabel.text = "놀이 시간"
        case 3:
            cell.chosenLabel.text = "물결"
        default:
            break
        }
    }
}
