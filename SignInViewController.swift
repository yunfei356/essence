//
//  SignInViewController.swift
//  zhiyouios
//
//  Created by Yun Fei Guo on 2018-11-29.
//  Copyright © 2018 Yun Fei Guo. All rights reserved.
//

import UIKit
import AWSMobileClient

class SignInViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBAction func onCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func onSignIn(_ sender: Any) {
        print(self.emailTextField.text!)
        print(self.passwordTextField.text!)
        signInCognito(email: self.emailTextField.text!, password: self.passwordTextField.text!)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.emailTextField.inputAccessoryView = createKeyboardDoneButton()
        self.passwordTextField.inputAccessoryView = createKeyboardDoneButton()
    }

    func signInCognito(email: String, password: String) {
        AWSMobileClient.sharedInstance().signIn(username: email, password: password) { (signInResult, error) in
            if let error = error {
                print("\(error.localizedDescription)")
            } else if let signInResult = signInResult {
                switch (signInResult.signInState) {
                case .signedIn:
                    print("User is signed in.")
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "SignInSuccess", sender: self)
                    }
                default:
                    print("Sign In needs info which is not yet supported.")
                }
            }
        }
    }
    
    @objc func doneButtonAction(sender: UIBarButtonItem) {
        if self.emailTextField.isFirstResponder {
            self.emailTextField.resignFirstResponder()
        } else if self.passwordTextField.isFirstResponder {
            self.passwordTextField.resignFirstResponder()
        }
    }
    
    func createKeyboardDoneButton() -> UIToolbar {
        let toolbar:UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.view.frame.size.width, height: 30))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonAction(sender:)))
        toolbar.setItems([flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()
        return toolbar
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
