//
//  ViewController.swift
//  clock-app
//
//  Created by 박경준 on 2023/02/08.
//

import UIKit

class WorldClockViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }
    
    func setupNavigationBar(){
        self.title = "세계 시계"
        
        let leftBarButton = UIBarButtonItem(title: "편집", style: .plain, target: self, action:#selector(leftBarButtonTapped))
        let rightBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(rightBarButtonTapped))
        
        leftBarButton.tintColor = .systemOrange
        rightBarButton.tintColor = .systemOrange
        
        self.navigationItem.rightBarButtonItem = rightBarButton
        self.navigationItem.leftBarButtonItem = leftBarButton
        
    }
    
    @objc func leftBarButtonTapped(){
        print("hi")
    }
    
    @objc func rightBarButtonTapped(){
        let selectVC = storyboard?.instantiateViewController(withIdentifier: "WorldClockSelectNavigationController") as! UINavigationController
        
        
        self.navigationController?.present(selectVC, animated: true)
    }


}

