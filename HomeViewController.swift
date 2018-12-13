//
//  HomeViewController.swift
//  zhiyouios
//
//  Created by Yun Fei Guo on 2018-10-30.
//  Copyright © 2018 Yun Fei Guo. All rights reserved.
//

import UIKit
import AWSMobileClient

class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func onSignOut(_ sender: Any) {
        AWSMobileClient.sharedInstance().signOut()
        performSegue(withIdentifier: "SignOut", sender: self)
    }
    
    
    @IBAction func onEditProfile(_ sender: Any) {
        performSegue(withIdentifier: "EditProfile", sender: self)
    }
    
    @IBAction func onBasicQuestions(_ sender: Any) {
        performSegue(withIdentifier: "BasicQuestions", sender: self)
    }
    
    @IBAction func onAdvancedQuestions(_ sender: Any) {
        performSegue(withIdentifier: "AdvancedQuestions", sender: self)
    }
}

