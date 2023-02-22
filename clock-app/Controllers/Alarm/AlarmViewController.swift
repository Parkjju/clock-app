//
//  WorldClockViewController.swift
//  clock-app
//
//  Created by Jun on 2023/02/09.
//

import UIKit

class AlarmViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupController()
        setupUI()
    }
    
    
    func setupNavigationBar(){
        self.title = "알람"
        
        let leftBarButton = UIBarButtonItem(title: "편집", style: .plain, target: self, action:#selector(leftBarButtonTapped))
        let rightBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(rightBarButtonTapped))
        
        leftBarButton.tintColor = .systemOrange
        rightBarButton.tintColor = .systemOrange
        
        self.navigationItem.rightBarButtonItem = rightBarButton
        self.navigationItem.leftBarButtonItem = leftBarButton
        
    }
    
    @objc func leftBarButtonTapped(){
        print("left")
    }
    
    @objc func rightBarButtonTapped(){
        let navigationVC = storyboard?.instantiateViewController(withIdentifier: "AlarmGenerateNavigationController") as! AlarmGenerateNavigationController
        
        // navigationVC에 데이터 전달, first 뷰 컨트롤러 세팅 완료 후 데이터 전달하는 로직 추가해야됨.
        
        self.performSegue(withIdentifier: "AlarmViewController", sender: self)
    }
    
    func setupController(){
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setupUI(){
        tableView.backgroundColor = .black
    }

}

extension AlarmViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
}

extension AlarmViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmTableViewCell", for: indexPath) as? AlarmTableViewCell else {
            print("HI!")
            return UITableViewCell()
        }
        // 하드코딩
        let alarm = AlarmData()
        alarm.isOn = true
        alarm.noon = "오후"
        alarm.time = "3:08"
        alarm.description = "알람"
        
        cell.alarmData = alarm
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
}


