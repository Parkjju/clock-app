//
//  AlarmSoundDetailViewController.swift
//  clock-app
//
//  Created by 박경준 on 2023/02/24.
//

import UIKit
import AVFoundation

class AlarmSoundDetailViewController: UIViewController {
    
    var audioPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        displaySoundsAlert()
    }
    
    func setupNavigationBar(){
        self.title = "사운드"
        self.navigationItem.leftBarButtonItem?.title = "뒤로"
        self.navigationController?.navigationBar.tintColor = .systemOrange
        
    }
    
    func displaySoundsAlert() {
        guard let path = Bundle.main.path(forResource: "part1", ofType: "m4a") else {
            return
        }
        
        let url  = URL(fileURLWithFileSystemRepresentation: <#T##UnsafePointer<Int8>#>, isDirectory: <#T##Bool#>, relativeTo: <#T##URL?#>)
        
        do{
            let sound = try AVAudioPlayer(contentsOf: url)
            
            
            sound.play()
        }catch{
            print("audio load error")
        }
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
