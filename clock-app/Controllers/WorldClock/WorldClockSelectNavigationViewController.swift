//
//  WorldClockSelectNavigationViewController.swift
//  clock-app
//
//  Created by 박경준 on 2023/02/13.
//

import UIKit

class WorldClockSelectNavigationViewController: UINavigationController {
    
    var clockData: [(String, String)] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupUI()
    }
    
    func setupData(){
        let selectVC = self.viewControllers.first as! WorldClockSelectViewController
        
        selectVC.clockData = self.clockData
    }
    
    func setupUI(){
        let scrollAppearance = UINavigationBarAppearance()
        
        scrollAppearance.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white
            
        ]
        scrollAppearance.backgroundColor = UIColor(named: "ModalWithScrollColor")
        
        self.navigationBar.standardAppearance = scrollAppearance
        
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
