//
//  AlarmRepeatDetailViewController.swift
//  clock-app
//
//  Created by Jun on 2023/02/24.
//

import UIKit

class AlarmRepeatDetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupController()
        setupUI()
    }
    
    func setupNavigationBar(){
        self.title = "반복"
        self.navigationItem.leftBarButtonItem?.title = "뒤로"
        self.navigationController?.navigationBar.tintColor = .systemOrange
    }
    
    func setupController(){
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func setupUI(){
        tableView.layer.cornerRadius = 10
    }

}

extension AlarmRepeatDetailViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmRepeatDetailTableViewCell", for: indexPath) as? AlarmRepeatDetailTableViewCell else {
            return UITableViewCell()
        }
        
        cell.day = indexPath.row
        cell.isCheck = true
        cell.backgroundColor = UIColor(named: "ModalSettingTableViewColor")
        cell.tintColor = .systemOrange
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
}


extension AlarmRepeatDetailViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let value = tableView.visibleCells[indexPath.row].accessoryType
        
        if(value == .checkmark){
            tableView.visibleCells[indexPath.row].accessoryType = .none
        }else{
            tableView.visibleCells[indexPath.row].accessoryType = .checkmark
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
