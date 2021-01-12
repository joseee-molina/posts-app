//
//  WelcomeViewController.swift
//  PlatziTweets
//
//  Created by Jose Octavio on 14/08/20.
//  Copyright © 2020 Jose Octavio. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

//    MARK - Outlets
    @IBOutlet weak var loginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    private func setupUI(){
        loginButton.layer.cornerRadius = 25
    }
}
