//
//  ViewController.swift
//  TSPresentation
//
//  Created by tsleedev on 10/14/2021.
//  Copyright (c) 2021 tsleedev. All rights reserved.
//

import UIKit
import TSPresentation

class ViewController: UIViewController {
    private var presentationManager: TSPresentationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

// MARK: - Helper
private extension ViewController {
    func moveToNext() {
        guard let presentationManager = presentationManager else { return }
        let destination = NextViewController()
        let navigationController = UINavigationController(rootViewController: destination)
        navigationController.modalPresentationStyle = .custom
        navigationController.transitioningDelegate = presentationManager
        present(navigationController, animated: true)
    }
}

// MARK: - IBAction
private extension ViewController {
    @IBAction func none(_ sender: UIButton) {
        self.presentationManager = TSPresentationManager(transitionStyle: .none,
                                                        frameSize: .full,
                                                        gesture: .none)
        moveToNext()
    }
    
    @IBAction func topToBottom(_ sender: UIButton) {
        self.presentationManager = TSPresentationManager(transitionStyle: .topToBottom,
                                                        frameSize: .full,
                                                        gesture: .none)
        moveToNext()
    }
    
    @IBAction func leftToRight(_ sender: UIButton) {
        self.presentationManager = TSPresentationManager(transitionStyle: .leftToRight,
                                                        frameSize: .length(320),
                                                        gesture: .pan)
        moveToNext()
    }
    
    @IBAction func rightToLeft(_ sender: UIButton) {
        self.presentationManager = TSPresentationManager(transitionStyle: .rightToLeft,
                                                        frameSize: .full,
                                                        gesture: .pan)
        moveToNext()
    }
    
    @IBAction func bottomToTop(_ sender: UIButton) {
        self.presentationManager = TSPresentationManager(transitionStyle: .bottomToTop,
                                                        frameSize: .half,
                                                        gesture: .pan)
        moveToNext()
    }
    
    @IBAction func fadeIn(_ sender: UIButton) {
        self.presentationManager = TSPresentationManager(transitionStyle: .fadeIn,
                                                        frameSize: .full,
                                                        gesture: .none)
        moveToNext()
    }
    
    @IBAction func push(_ sender: UIButton) {
        self.presentationManager = TSPresentationManager(transitionStyle: .push,
                                                        frameSize: .full,
                                                        gesture: .pan)
        moveToNext()
    }
}
