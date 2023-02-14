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
            
            guard let GMT = timezone.abbreviation() else {
                continue
            }
            
            
            guard var regionName = timezone.localizedName(for: .shortGeneric, locale: Locale(identifier:"ko-KR")) else {
                continue
            }
            
            guard var regionENGName = timezone.localizedName(for: Foundation.NSTimeZone.NameStyle.standard
                                                             , locale: Locale(identifier:"en-US")) else {
                continue
            }
            
            
            // TODO : 타임존 한글명 알아내기.
            print(timezone.identifier)
            
            // GMT + -로 시차 알아낼 수 있음.
//            guard var abbreviationName = timezone.localizedName(for: Foundation.NSTimeZone.NameStyle.shortStandard, locale: Locale(identifier:"ko-KR")) else {
//                continue
//            }
            
//            print(regionName)
//            print(timezone.identifier)
//            print("")
            
            var data = regionName.split(separator: " ")
            let _ = data.popLast()
            
            regionName = data.joined()
            
            let worldDate = Date()
            var selectedWorld = Date.FormatStyle.dateTime
            selectedWorld.timeZone = timezone
            print(selectedWorld)
            
            worldClickArray.append((regionName, worldDate.formatted(selectedWorld)))
            
        }
        // 현재까지
        // 1. 타임존에 따른 나라 이름은 얻어냈음
        // 2. 타임존이 만들어진 지역 이름을 알아내야함.
        // 3. 지역 이름도 사실 타임존에 걸쳐 있긴 한데 이걸 한국어로 바꿔주는 로직이 있는지
        
        // 1. 타임존 identifier중에 language identifier 있는지
        // 2. 있으면 language identifier 얻어내서 Locale 생성
        // 3. region 얻어내는 함수 찾아보기
        
        
        
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
