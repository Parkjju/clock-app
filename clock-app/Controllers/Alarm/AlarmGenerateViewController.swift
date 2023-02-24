//
//  AlarmGenerateViewController.swift
//  clock-app
//
//  Created by Jun on 2023/02/22.
//

import UIKit

class AlarmGenerateViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var newAlarmData: AlarmData?
    
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
    
    @objc func rightBarButtonTapped(){
        // 최종 저장 시 newAlarmData time difference 계산 및 저장
        newAlarmData?.time = Int64(datePicker.date.timeIntervalSince1970 - Date().timeIntervalSince1970)
        
        
        
        
    }
    
    func setupUI(){
        datePicker.setValue(UIColor.white, forKey: "textColor")
        
        tableView.backgroundColor = UIColor(named: "ModalSettingTableViewColor")
        tableView.layer.cornerRadius = 10
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
            print("?")
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
        
        
        
        repeatTableViewCell.titleLabel.text = ""
        
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
                repeatTableViewCell.titleLabel.text?.append(contentsOf: "\(dict[checkedDay.key]!) ")
            }
        }
        
        // 아무것도 체크되지 않았으면 안함 텍스트로 변경
        if(repeatTableViewCell.titleLabel.text?.count == 0){
            repeatTableViewCell.titleLabel.text = "안 함"
        }
        
        tableView.reloadData()
    }
        
}
    

