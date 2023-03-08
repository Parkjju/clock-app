//
//  WorldClockSelectViewController.swift
//  clock-app
//
//  Created by Jun on 2023/02/09.
//

import UIKit

class WorldClockSelectViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let sectionTitles = "ㄱㄴㄷㄹㅁㅂㅅㅇㅈㅊㅋㅌㅍㅎ".map(String.init)
    
    var clockData: [(String, TimeZone)] = []{
        didSet{
            setClockDataSection()
            
        }
    }
    lazy var clockDataWithSection: [String: [String]] = [:]
    
    let worldClockManager = WorldClockManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupController()
        
    }
    
    func setClockDataSection(){
        let _ = clockData.map { (region, _) in
            
            // 초성 얻어내기
            guard let initialConsonant = getInitialConsonant(text: region) else {
                return
            }
            
            // 초성 기준으로 섹션 데이터 만들기
            if let _ = clockDataWithSection[initialConsonant] {
//                print("OK")
            }else{
                clockDataWithSection[initialConsonant] = []
            }
            clockDataWithSection[initialConsonant]?.append(region)
        }
    }
    
    func getInitialConsonant(text: String) -> String? {
        guard let firstChar = text.unicodeScalars.first?.value, 0xAC00...0xD7A3 ~= firstChar else { return nil }

        let value = ((firstChar - 0xAC00) / 28 ) / 21

        return String(format:"%C", value + 0x1100)
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
        tableView.delegate = self
    }
    
    
    
    
    
}

extension WorldClockSelectViewController: UITableViewDataSource{
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sectionTitles
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return index
    }
    
    // numberOfSection 로직 수정 필요
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return sectionTitles.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        clockDataWithSection.map { (key: String, value: [String]) in
            print(key == sectionTitles[section])
        }
        return clockData.count
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

extension WorldClockSelectViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    
        worldClockManager.saveWorldClockData(newRegion: clockData[indexPath.row].0, newTimezone: clockData[indexPath.row].1) {
            self.dismiss(animated: true)
        }
    }
}
