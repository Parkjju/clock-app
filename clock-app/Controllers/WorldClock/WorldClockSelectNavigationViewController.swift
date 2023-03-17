//
//  WorldClockSelectNavigationViewController.swift
//  clock-app
//
//  Created by 박경준 on 2023/02/13.
//

import UIKit

class WorldClockSelectNavigationViewController: UINavigationController {
    
    var clockData: [(String, TimeZone)] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        
        guard let tabVC = self.presentingViewController as? UITabBarController else {
            return
        }

        guard let firstNavigationVC = tabVC.viewControllers?.first as? UINavigationController else {
            return
        }
        guard let firstVC = firstNavigationVC.viewControllers.first as? WorldClockViewController else {
            return
        }
        firstVC.tableView.reloadData()
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
        self.navigationBar.compactAppearance = scrollAppearance
        
    }

}
