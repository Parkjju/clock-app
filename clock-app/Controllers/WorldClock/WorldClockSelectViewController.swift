//
//  WorldClockSelectViewController.swift
//  clock-app
//
//  Created by Jun on 2023/02/09.
//

import UIKit

class WorldClockSelectViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        
    }
    
    func setupNavigationBar(){
        self.title = "도시 선택"
        
        let rightBarButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(rightBarButtonTapped))
        rightBarButton.tintColor = .systemOrange
        
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    @objc func rightBarButtonTapped(){
        print("hi")
        for tz in TimeZone.knownTimeZoneIdentifiers{
            
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
