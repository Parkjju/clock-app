//
//  ViewController.swift
//  clock-app
//
//  Created by 박경준 on 2023/02/08.
//

import UIKit

class WorldClockViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    
    let clockDataManager = WorldClockManager.shared
    var clockData: [WorldClockData]{
        get {
            return clockDataManager.getSavedWorldClock()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupController()
        
        NotificationService.sharedInstance.authorizeNotification()
    }
    
    func setupNavigationBar(){
        self.title = "세계 시계"
        
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
        let selectNavigationVC = storyboard?.instantiateViewController(withIdentifier: "WorldClockSelectNavigationController") as! WorldClockSelectNavigationViewController
        
        selectNavigationVC.clockData = clockDataManager.getWorldClockData()
        
        self.performSegue(withIdentifier: "WorldClockViewController", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "WorldClockViewController"){
            guard let destination = segue.destination as? WorldClockSelectNavigationViewController else {
                return
            }
            destination.clockData = clockDataManager.getWorldClockData()
        }
    }

    
    func setupController(){
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        tableView.setEditing(editing, animated: true)
        
        let _ = tableView.visibleCells.map({ cell in
            guard let cell = cell as? WorldClockTableViewCell else {
                return
            }
            
            
            
            cell.timeLabel.isHidden = editing
            cell.noon.isHidden = editing
            cell.noon.constraints.first?.priority = .defaultLow
            cell.timeLabel.constraints.first?.priority = .defaultLow
            
            
            // 기본이 햄버거 메뉴인데 이미지를 추가하면 tintColor 기준으로 색상이 적용됨.
            if(editing){
                cell.noon.widthAnchor.constraint(equalToConstant: 0).isActive = true
                cell.timeLabel.widthAnchor.constraint(equalToConstant: 0).isActive = true
                
            }else{
                print("ended")
                cell.noon.constraints.last?.isActive = false
                cell.timeLabel.constraints.last?.isActive = false
                
            }
        })
        
    }
    
    
    
    
}

extension WorldClockViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorldClockCell", for: indexPath) as! WorldClockTableViewCell
        
        cell.clockData = clockData[indexPath.row]
        cell.overrideUserInterfaceStyle = .dark
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clockData.count
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == .delete){
            
            clockDataManager.removeClock(deleteTarget: clockData[indexPath.row]) {
                tableView.reloadData()
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "삭제"
    }

    func tableView(_ tableView: UITableView, canMoveRowAt indexPath:
     IndexPath) -> Bool {
        return true
    }
    
    
}

extension WorldClockViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        // row 움직이고 순서 변경하는 로직 추가
        clockDataManager.updateIndex(sourceData: clockData[sourceIndexPath.row], destinationData: clockData[destinationIndexPath.row]) {
            print("END!")
        }
        
        
        
        
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
        
    }
    
}
