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
        tableView.dragDelegate = self
        tableView.dragInteractionEnabled = true
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        tableView.setEditing(editing, animated: true)
    }
    
    
}

extension WorldClockViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorldClockCell", for: indexPath) as! WorldClockTableViewCell
        
        cell.clockData = clockData[indexPath.row]

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
    
}

extension WorldClockViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }    
}
// notification

extension WorldClockViewController: UITableViewDragDelegate{
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let dragItem = UIDragItem(itemProvider: NSItemProvider())
        dragItem.localObject = clockData[indexPath.row]
        return [ dragItem ]
    }
}
