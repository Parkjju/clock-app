//
//  WorldClockViewController.swift
//  clock-app
//
//  Created by Jun on 2023/02/09.
//

import UIKit

class AlarmViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let alarmManager = AlarmManager.shared
    var alarmData: [AlarmData]{
        get {
            return alarmManager.getSavedAlarm()
        }
    }
    
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
        setEditing(!tableView.isEditing, animated: true)
    }
    
    @objc func rightBarButtonTapped(){
        let _ = storyboard?.instantiateViewController(withIdentifier: "AlarmGenerateNavigationController") as! AlarmGenerateNavigationController
        
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touches begin")
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        tableView.setEditing(editing, animated: true)
        
        let _ = tableView.visibleCells.map { cell in
            guard let cell = cell as? AlarmTableViewCell else {
                return
            }
            
            
            
            if(editing){
                cell.switchButton.isHidden = true
            }else{
                UIView.transition(with: cell.switchButton,duration: 0.5, options: .transitionCrossDissolve) {
                    cell.switchButton.isHidden = false
                }
            }
        }
    }
}

extension AlarmViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == .delete){
            alarmManager.removeAlarm(deleteTarget: alarmData[indexPath.row]) {
                tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "삭제"
    }
    
    // MARK: - 인스턴스 생성 서치필요
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
}

extension AlarmViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmTableViewCell", for: indexPath) as? AlarmTableViewCell else {
            return UITableViewCell()
        }
        cell.alarmData = alarmData[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarmData.count
    }
}


