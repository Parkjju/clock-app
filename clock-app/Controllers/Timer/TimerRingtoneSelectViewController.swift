//
//  TimerRingtoneSelectViewController.swift
//  clock-app
//
//  Created by Jun on 2023/04/03.
//

import UIKit

class TimerRingtoneSelectViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var delegate: AlarmSoundDelegate?
    
    let sounds: [String] = ["daydream", "green", "playTime", "sea"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupController()
    }
    
    func setupUI(){
        view.backgroundColor = UIColor(named: "ModalColor")
        tableView.backgroundColor = UIColor(named:"ModalSettingTableViewColor")
        tableView.clipsToBounds = true
        tableView.layer.cornerRadius = 10
        tableView.heightAnchor.constraint(equalToConstant: CGFloat(50 * sounds.count)).isActive = true
        
        let leftBarButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancelButtonTapped))
        let rightBarButton = UIBarButtonItem(title: "설정", style: .plain, target: self, action: #selector(settingButtonTapped))
        leftBarButton.tintColor = .systemOrange
        rightBarButton.tintColor = .systemOrange
        self.navigationItem.leftBarButtonItem = leftBarButton
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    @objc func cancelButtonTapped(){
        self.dismiss(animated: true)
    }
    @objc func settingButtonTapped(){
        
    }
    
    func setupController(){
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    deinit{
        audioPlayer.stop()
    }
}

extension TimerRingtoneSelectViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sounds.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TimerRingtoneSelectTableViewCell", for: indexPath) as? TimerRingtoneSelectTableViewCell else {
            return UITableViewCell()
        }
        let soundName = translateSoundNameToKorean(text: sounds[indexPath.row])
        cell.soundLabel.text = soundName
        cell.accessoryType = .none
        cell.tintColor = .systemOrange
        
        return cell
    }
}

extension TimerRingtoneSelectViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        delegate?.soundUpdate(index: indexPath.row)
        
        guard let label = tableView.visibleCells[indexPath.row] as? TimerRingtoneSelectTableViewCell else {
            return
        }
        
        let _ = tableView.visibleCells.map { cell in
            if(cell.accessoryType == .checkmark){
                cell.accessoryType = .none
                return
            }
        }
        tableView.visibleCells[indexPath.row].accessoryType = .checkmark
        
        playSound(fileName: translateSoundName(text: label.soundLabel.text!))
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
