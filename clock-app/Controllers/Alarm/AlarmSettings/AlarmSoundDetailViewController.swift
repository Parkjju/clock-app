//
//  AlarmSoundDetailViewController.swift
//  clock-app
//
//  Created by 박경준 on 2023/02/24.
//

import UIKit

class AlarmSoundDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
    }
    
    func setupNavigationBar(){
        self.title = "사운드"
        self.navigationItem.leftBarButtonItem?.title = "뒤로"
        self.navigationController?.navigationBar.tintColor = .systemOrange
        
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
