//
//  playSound.swift
//  clock-app
//
//  Created by Jun on 2023/04/07.
//

import Foundation
import AVFoundation

var audioPlayer:AVAudioPlayer!
func playSound(fileName: String) {
    if(fileName == ""){
        return
    }
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
