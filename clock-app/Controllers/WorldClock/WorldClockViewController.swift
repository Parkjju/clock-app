//
//  ViewController.swift
//  clock-app
//
//  Created by 박경준 on 2023/02/08.
//

import UIKit

class WorldClockViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
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
        print("hi")
    }
    
    @objc func rightBarButtonTapped(){
        let selectVC = storyboard?.instantiateViewController(withIdentifier: "WorldClockSelectNavigationController") as! WorldClockSelectNavigationViewController
        
        selectVC.clockData = getWorldClockData()
        
        self.navigationController?.present(selectVC, animated: true)
    }

    
    func setupController(){
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func getWorldClockData() -> [(String, String)]{
        var worldClickArray:[(String, String)] = []
        for tz in TimeZone.knownTimeZoneIdentifiers{
            guard let timezone = TimeZone(identifier: tz) else {
                continue
            }
            guard var worldName = timezone.localizedName(for: .shortGeneric, locale: Locale(identifier:"ko-KR")) else {
                continue
            }
            
            var data = worldName.split(separator: " ")
            let _ = data.popLast()
            
            worldName = data.joined()
            
            let worldDate = Date()
            var selectedWorld = Date.FormatStyle.dateTime
            selectedWorld.timeZone = timezone
            
            worldClickArray.append((worldName, worldDate.formatted(selectedWorld)))
//            print(worldName)
//            print(worldDate.formatted(selectedWorld))
        }
        
        return worldClickArray
    }

}

extension WorldClockViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorldClockCell", for: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
}

extension WorldClockViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
