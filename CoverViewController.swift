//
//  CoverViewController.swift
//  zhiyouios
//
//  Created by Yun Fei Guo on 2018-11-28.
//  Copyright © 2018 Yun Fei Guo. All rights reserved.
//

import UIKit
import AWSMobileClient

class CoverViewController: UIViewController {

    @IBAction func onSignIn(_ sender: Any) {
        performSegue(withIdentifier: "SignIn", sender: self)
    }
    
    @IBAction func onSignUp(_ sender: Any) {
        performSegue(withIdentifier: "SignUp", sender: self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        AWSMobileClient.sharedInstance().initialize { (userState, error) in
            if let userState = userState {
                switch(userState) {
                case .signedIn:
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "SignedInAlready", sender: self)
                    }
                case .signedOut:
                    break
                default:
                    AWSMobileClient.sharedInstance().signOut()
                }
            } else if let error = error {
                print(error.localizedDescription)
            }
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
