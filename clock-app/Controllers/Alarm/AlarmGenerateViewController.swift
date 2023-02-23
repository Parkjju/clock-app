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
        
    }
    
    func setupUI(){
        datePicker.setValue(UIColor.white, forKey: "textColor")
        
        tableView.backgroundColor = UIColor(named: "ModalSettingTableViewColor")
        tableView.layer.cornerRadius = 10
        
        datePicker.addTarget(self, action: #selector(valueChangeHandler), for: .valueChanged)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func valueChangeHandler(sender: UIDatePicker){
        // datePicker 밸류 달라짐에 따라 저장할 알람데이터 time 세팅
        newAlarmData?.time = Int64(datePicker.date.timeIntervalSince1970 - Date().timeIntervalSince1970)
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
}
