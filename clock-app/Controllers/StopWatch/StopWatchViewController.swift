//
//  StopWatchViewController.swift
//  clock-app
//
//  Created by 박경준 on 2023/03/18.
//

import UIKit

class StopWatchViewController: UIViewController {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var updatingCellIndexPath: IndexPath?
    
    var timer = Timer()
    
    var isStarted: Bool = false
    
    var labArray: [String] = []
    
    var elapsedMiliSecond = 0
    var elapsedSecond = 0
    var elapsedMinute = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupController()
    }
    
    func setupUI(){
        resetButton.layer.cornerRadius = 40
        startButton.layer.cornerRadius = 40
        resetButton.setTitle("랩", for: .disabled)
        resetButton.setTitle("랩", for: .normal)
        resetButton.isEnabled = false
        timeLabel.textAlignment = .justified
        timeLabel.lineBreakMode = .byWordWrapping
        
        let screenSize = UIScreen.main.bounds.size
        switch screenSize.width {
        case 320: // iPhone 5, 5s, SE
            timeLabel.font = UIFont.systemFont(ofSize: 45, weight: .thin)
            timeLabel.preferredMaxLayoutWidth = 280
        case 375: // iPhone 6, 6s, 7, 8, X, XS, 11 Pro, 12 Mini
            timeLabel.font = UIFont.systemFont(ofSize: 86, weight: .thin)
            
        case 414: // iPhone 6 Plus, 6s Plus, 7 Plus, 8 Plus, XR, XS Max, 11, 11 Pro Max, 12, 12 Pro
            timeLabel.font = UIFont.systemFont(ofSize: 90, weight: .thin)
        default:
            break
        }
    }
    
    func setupController(){
        tableView.dataSource = self
        tableView.delegate = self
        scrollView.delegate = self
    }
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        if(labArray.count == 0){
            labArray.append("")
            tableView.reloadData()
        }
        
        createTimer()
        
        isStarted = !isStarted
        if(isStarted){
            resetButton.isEnabled = true
            resetButton.setTitle("랩", for: .normal)
            startButton.setTitle("중단", for: .normal)
            startButton.backgroundColor = UIColor(named: "stopColor")
            startButton.setTitleColor(UIColor(named: "stopTextColor"), for: .normal)
        }else{
            timer.invalidate()
            resetButton.isEnabled = true
            resetButton.setTitle("재설정", for: .normal)
            startButton.setTitle("시작", for: .normal)
            startButton.setTitleColor( #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 0.76), for: .normal)
            startButton.backgroundColor = #colorLiteral(red: 0.1882352941, green: 0.8196078431, blue: 0.3450980392, alpha: 0.3461299669)
        }
    }
    
    // 밀리세컨드 업데이트 로직 - 0.04초로 타협
    func createTimer(){
        timer.invalidate()
        
        timer = Timer.scheduledTimer(timeInterval: 0.03, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        RunLoop.current.add(timer, forMode: .common)
    }
    
    @objc func updateTime(){
        // 0.03초가 한계
        elapsedMiliSecond += 3
        
        if(elapsedMiliSecond >= 100){
            elapsedSecond += 1
            elapsedMiliSecond = 0
        }

        if(elapsedSecond >= 60){
            elapsedMinute += 1
            elapsedSecond = 0
        }
        
        timeLabel.attributedText = NSAttributedString(string: createTimeString(), attributes: [.kern: 1.2])
        tableView.reloadData()
    }
    
    func createTimeString() -> String{
        let miliSecondString = elapsedMiliSecond / 10 < 1 ? "0\(elapsedMiliSecond)" : "\(elapsedMiliSecond)"
        let secondString = elapsedSecond / 10 < 1 ? "0\(elapsedSecond)" : "\(elapsedSecond)"
        let minuteString = elapsedMinute / 10 < 1 ? "0\(elapsedMinute)" : "\(elapsedMinute)"
        
        return "\(minuteString):\(secondString).\(miliSecondString)"
    }
    
    @IBAction func stopButtonTapped(_ sender: UIButton) {
        if(!isStarted){
            labArray.removeAll()
            elapsedMinute = 0
            elapsedSecond = 0
            elapsedMiliSecond = 0
            timeLabel.text = "00:00.00"
            tableView.reloadData()
            return
        }
        if(labArray.first! == ""){
            let _ = labArray.popLast()
            labArray.append(createTimeString())
            labArray.append("")
        }else{
            let _ = labArray.popLast()
            labArray.append(createTimeString())
            labArray.append("")
        }
    }
    
    // labArray count가 6 이상일때 컨텐츠뷰 heightAnchor 동적 조정 로직 필요

}

extension StopWatchViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return labArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StopWatchTableViewCell", for: indexPath) as? StopWatchTableViewCell else {
            return UITableViewCell()
        }
        
        cell.lapLabel.text = "랩 \(indexPath.row + 1)"
        if(indexPath.row == labArray.count - 1){
            updatingCellIndexPath = indexPath
            cell.timeLabel.text = timeLabel.text
        }else{
            cell.timeLabel.text = "\(labArray[indexPath.row])"
        }

        
        return cell
    }
}

extension StopWatchViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension StopWatchViewController: UIScrollViewDelegate{
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate{
            scrollView.setContentOffset(scrollView.contentOffset, animated: true)
        }
    }
}
