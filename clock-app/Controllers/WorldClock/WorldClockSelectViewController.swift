//
//  WorldClockSelectViewController.swift
//  clock-app
//
//  Created by Jun on 2023/02/09.
//

import UIKit

class WorldClockSelectViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var clockData: [(String, String)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupController()
    }
    
    func setupNavigationBar(){
        self.title = "도시 선택"
        
        let rightBarButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(rightBarButtonTapped))
        rightBarButton.tintColor = .systemOrange
        
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    @objc func rightBarButtonTapped(){
        self.dismiss(animated: true)
    }
    
    func setupController(){
        tableView.dataSource = self
    }
}

extension WorldClockSelectViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.clockData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorldClockSelectCell", for: indexPath) as! WorldClockSelectTableViewCell
        
        cell.data = clockData[indexPath.row].0
        
        // 선택시 백그라운드 뷰 컬러 수정하는 부분
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(named: "CellSelectedColor")
        cell.selectedBackgroundView = backgroundView
        
        return cell
        
    }
}
