//
//  WorldClockSelectViewController.swift
//  clock-app
//
//  Created by Jun on 2023/02/09.
//

import UIKit

class WorldClockSelectViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    lazy var searchBar = UISearchBar()
    
    var filteredData: [(String, TimeZone)] = []
    
    let sectionTitles = ["ㄱ","ㄴ","ㄷ","ㄹ","ㅁ","ㅂ","ㅅ","ㅇ","ㅈ","ㅊ","ㅋ","ㅌ","ㅍ","ㅎ"]
    
    // 배열로 제작해야됨 -> 조합형 유니코드 주의해서 배열로 각각 만들어야됨
    // 1102 유니코드들을 담기 ->
    // parsingSectionTitle -> rs
    
    var clockData: [(String, TimeZone)] = []{
        didSet{
            setClockDataSection()
        }
    }
    
    lazy var clockDataWithSection: [String: [String]] = [:]
    lazy var timezoneDataWithSection: [String: [TimeZone]] = [:]
    
    let worldClockManager = WorldClockManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupNavigationBar()
        setupController()
        
    }
    func setupUI(){
        tableView.sectionIndexColor = .systemOrange
        
        setupSearchBar()
    }
    
    func setupSearchBar(){
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = "검색"
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        
        
        
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.textColor = .white // 변경하고자 하는 색상으로 변경해주세요
        }
        
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.attributedPlaceholder = NSAttributedString(string: "검색", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])

        
        navigationItem.titleView = searchBar
        
    }
    
    func setClockDataSection(){
        let _ = clockData.map { (region, timezone) in
            
            // 초성 얻어내기
            guard var initialConsonant = getInitialConsonant(text: region) else {
                return
            }
            
            initialConsonant = convertJamoToChosung(jamo: initialConsonant)
            
            // 초성 기준으로 섹션 데이터 만들기
            if let _ = clockDataWithSection[initialConsonant] {
//                print("OK")
            }else{
                clockDataWithSection[initialConsonant] = []
            }
            
            if let _ = timezoneDataWithSection[initialConsonant]{
//                print("OK")
            }else{
                timezoneDataWithSection[initialConsonant] = []
            }
            
            clockDataWithSection[initialConsonant]?.append(region)
            timezoneDataWithSection[initialConsonant]?.append(timezone)
            
        }
    }
    
    // 알파벳 -> 나열형태
    // 한글 -> 조합형 ㄱ ㅏ  - 1 + 2
    // 조합형 가 자체를 무언가로 관리
    // 조합형 가의 ㄱ 과 ㄱ 자체의 코드가 다를 수 있다
    // 0xAC00 -> ㄱㄴㄷㄹㅁㅂㅅ 자체 코드
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
    
    @objc func rightBarButtonTapped(){        self.dismiss(animated: true)
    }
    
    func setupController(){
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    
    
    
    
}

extension WorldClockSelectViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.textColor = .lightGray
            headerView.contentView.backgroundColor = UIColor(named: "ModalColor")
         }
    }
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if(filteredData.count != 0){
            return nil
        }
        return sectionTitles
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        if(filteredData.count != 0){
            return 0
        }
        return index
    }
    
    // numberOfSection 로직 수정 필요
    func numberOfSections(in tableView: UITableView) -> Int {
        if(filteredData.count != 0){
            return 1
        }
        return sectionTitles.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(filteredData.count != 0){
            return nil
        }
        return sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let clockDataWithSectionArray = clockDataWithSection[sectionTitles[section]] else {
            return 0
        }
        
        if(filteredData.count > 0){
            return filteredData.count
        }else{
            return clockDataWithSectionArray.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorldClockSelectCell", for: indexPath) as! WorldClockSelectTableViewCell
        
        guard let clockDataWithSectionArray = clockDataWithSection[sectionTitles[indexPath.section]] else {
            return UITableViewCell()
        }
        if(filteredData.count == 0){
            cell.data = clockDataWithSectionArray[indexPath.row]
        }else{
            
            cell.data = filteredData[indexPath.row].0
        }
//        cell.data = clockDataWithSectionArray[indexPath.row]
        
        // 선택시 백그라운드 뷰 컬러 수정하는 부분
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(named: "CellSelectedColor")
        cell.selectedBackgroundView = backgroundView
        
        return cell
        
    }
}

extension WorldClockSelectViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(filteredData.count > 0){
            worldClockManager.saveWorldClockData(newRegion: filteredData[indexPath.row].0, newTimezone: filteredData[indexPath.row].1) {
                self.dismiss(animated: true)
            }
        }else{
            // indexPath.row가 섹션마다 0으로 초기화됨
            // 타임존 명은 clockDataWithSection에서 불러올 수 있는데
            // 타임존 객체를 불러오는 방법은?
            // flat을 시켜야되는게 아니라 section과 row의 조합으로 인덱싱할 수 있어야됨
            
            worldClockManager.saveWorldClockData(newRegion: clockDataWithSection[sectionTitles[indexPath.section]]![indexPath.row], newTimezone: timezoneDataWithSection[sectionTitles[indexPath.section]]![indexPath.row]) {
                self.dismiss(animated: true)
            }
        }
    }
}

extension WorldClockSelectViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = searchText.isEmpty ? clockData : clockData.filter({ tuple -> Bool in
            return tuple.0.range(of: searchText, options:[.caseInsensitive]) != nil
        })
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
