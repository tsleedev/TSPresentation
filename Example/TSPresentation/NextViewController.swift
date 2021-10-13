//
//  NextViewController.swift
//  TSPresentation
//
//  Created by tsleedev on 10/14/2021.
//  Copyright (c) 2021 tsleedev. All rights reserved.
//

import UIKit

class NextViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.yellow
        
        let barButtonItem: UIBarButtonItem
        if #available(iOS 13.0, *) {
            barButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(close(_:)))
        } else {
            barButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(close(_:)))
        }
        navigationItem.rightBarButtonItem = barButtonItem
    }
    
    @objc func close(_ sender: Any) {
        dismiss(animated: true)
    }
}
