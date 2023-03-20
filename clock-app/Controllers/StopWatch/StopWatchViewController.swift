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
    
    var timer = Timer()
    
    var isStarted: Bool = false
    
    var labArray: [String] = ["00:00.87"]
    
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
        
    }
    
    func setupController(){
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        timer.invalidate()
        
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        
        isStarted = !isStarted
        if(isStarted){
            startButton.setTitle("중단", for: .normal)
            startButton.backgroundColor = UIColor(named: "stopColor")
            startButton.setTitleColor(UIColor(named: "stopTextColor"), for: .normal)
        }else{
            startButton.setTitle("시작", for: .normal)
            startButton.setTitleColor( #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 0.76), for: .normal)
            startButton.backgroundColor = #colorLiteral(red: 0.1882352941, green: 0.8196078431, blue: 0.3450980392, alpha: 0.3461299669)
        }
    }
    
    @objc func updateTime(){
        elapsedMiliSecond += 1
        
        if(elapsedMiliSecond >= 100){
            elapsedSecond += 1
            elapsedMiliSecond = 0
        }
        
        if(elapsedSecond >= 60){
            elapsedMinute += 1
            elapsedSecond = 0
        }
        
        let miliSecondString = elapsedMiliSecond / 10 < 1 ? "0\(elapsedMiliSecond)" : "\(elapsedMiliSecond)"
        let secondString = elapsedSecond / 10 < 1 ? "0\(elapsedSecond)" : "\(elapsedSecond)"
        let minuteString = elapsedMinute / 10 < 1 ? "0\(elapsedMinute)" : "\(elapsedMinute)"
        
        
        timeLabel.text = "\(minuteString):\(secondString).\(miliSecondString)"
    }
    
    @IBAction func stopButtonTapped(_ sender: UIButton) {
        timer.invalidate()
        
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
        cell.timeLabel.text = "\(labArray[indexPath.row])"
        
        return cell
    }
}

extension StopWatchViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
