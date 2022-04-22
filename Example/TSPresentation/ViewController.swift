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
    private let presentationManager = TSPresentationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

// MARK: - Helper
private extension ViewController {
    func moveToNext() {
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
        presentationManager.transitionStyle = .none
        presentationManager.frameSize = .full
        presentationManager.isNeedPanGesture = false
        moveToNext()
    }
    
    @IBAction func topToBottom(_ sender: UIButton) {
        presentationManager.transitionStyle = .topToBottom
        presentationManager.frameSize = .full
        presentationManager.isNeedPanGesture = false
        moveToNext()
    }
    
    @IBAction func leftToRight(_ sender: UIButton) {
        presentationManager.transitionStyle = .leftToRight
        presentationManager.frameSize = .length(320)
        presentationManager.isNeedPanGesture = true
        moveToNext()
    }
    
    @IBAction func rightToLeft(_ sender: UIButton) {
        presentationManager.transitionStyle = .rightToLeft
        presentationManager.frameSize = .full
        presentationManager.isNeedPanGesture = true
        moveToNext()
    }
    
    @IBAction func bottomToTop(_ sender: UIButton) {
        presentationManager.transitionStyle = .bottomToTop
        presentationManager.frameSize = .half
        presentationManager.isNeedPanGesture = true
        moveToNext()
    }
    
    @IBAction func fadeIn(_ sender: UIButton) {
        presentationManager.transitionStyle = .fadeIn
        presentationManager.frameSize = .full
        presentationManager.isNeedPanGesture = false
        moveToNext()
    }
    
    @IBAction func push(_ sender: UIButton) {
        presentationManager.transitionStyle = .push
        presentationManager.frameSize = .full
        presentationManager.isNeedPanGesture = true
        moveToNext()
    }
}
