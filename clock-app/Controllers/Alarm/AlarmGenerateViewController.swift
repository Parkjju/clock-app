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
    
    let tableViewContents = [0,1,2,3]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupController()
        setupNavigationBar()
        setupUI()
    }
    
    func setupController(){
        
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
        print("right!")
    }
    
    func setupUI(){
        datePicker.setValue(UIColor.white, forKey: "textColor")
        
        tableView.backgroundColor = UIColor(named: "ModalSettingTableViewColor")
        tableView.layer.cornerRadius = 10
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

