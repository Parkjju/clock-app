//
//  AlarmSoundDetailViewController.swift
//  clock-app
//
//  Created by 박경준 on 2023/02/24.
//

import UIKit
import AVFoundation
var audioPlayer:AVAudioPlayer!

class AlarmSoundDetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var delegate: AlarmSoundDelegate?
    
    let sounds: [String] = ["daydream", "green", "playTime", "sea"]
    
    var checkedIndex:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupUI()
        setupController()
    }
    
    func setupNavigationBar(){
        self.title = "사운드"
        self.navigationController?.navigationBar.tintColor = .systemOrange
        self.navigationItem.leftBarButtonItem?.title = "뒤로"
    }
    
    func setupUI(){
        self.tableView.layer.cornerRadius = 10
    }
    
    func setupController(){
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func playSound(fileName: String) {
        guard let path = Bundle.main.path(forResource: fileName, ofType:"mp3") else {
                print("bundle error")
                return
            
        }
            let url = URL(fileURLWithPath: path)
        
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            
            guard let player = audioPlayer else {
                print("player load error")
                return
            }
            
            // play atTime 
            player.prepareToPlay()
            player.play()
        }catch{
            print("audio load error")
            print(error.localizedDescription)
        }
    }
    deinit {
        audioPlayer.stop()
    }

}


extension AlarmSoundDetailViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmSoundDetailTableViewCell", for: indexPath) as? AlarmSoundDetailTableViewCell else {
            return UITableViewCell()
        }
        switch sounds[indexPath.row]{
        case sounds[0]:
            cell.text = "공상음"
        case sounds[1]:
            cell.text = "녹차"
        case sounds[2]:
            cell.text = "놀이 시간"
        case sounds[3]:
            cell.text = "물결"
        default:
            break
        }
        cell.accessoryType = .none
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sounds.count
    }
}

extension AlarmSoundDetailViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        for cell in tableView.visibleCells{
            cell.accessoryType = .none
        }
        
        // 사운드 선택 대상 커스텀 델리게이트로 인덱스 전달
        self.delegate?.soundUpdate(index: indexPath.row)
        
        // 액세서리 타입 지정 로직
        tableView.visibleCells[indexPath.row].accessoryType = .checkmark
        
        // 선택 후 바로 deselect하여 깜빡이는 효과 부여
        tableView.deselectRow(at: indexPath, animated: true)
        
        // 노래재생
        playSound(fileName: sounds[indexPath.row])
    }
}

