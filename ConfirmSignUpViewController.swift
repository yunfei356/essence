//
//  ConfirmSignUpViewController.swift
//  zhiyouios
//
//  Created by Yun Fei Guo on 2018-11-29.
//  Copyright © 2018 Yun Fei Guo. All rights reserved.
//

import UIKit
import AWSMobileClient

class ConfirmSignUpViewController: UIViewController {

    @IBOutlet weak var confirmCodeField: UITextField!
    
    var email: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.confirmCodeField.inputAccessoryView = createKeyboardDoneButton()
    }
    
    @IBAction func onSubmit(_ sender: Any) {
        print("Email: ", self.email!)
        print("code: ", self.confirmCodeField.text!)
        confirmSignUpCognito(email: self.email!, code: self.confirmCodeField.text!)
    }
    
    func confirmSignUpCognito(email: String, code: String) {
        AWSMobileClient.sharedInstance().confirmSignUp(username: email, confirmationCode: code) { (signUpResult, error) in
            if let signUpResult = signUpResult {
                switch(signUpResult.signUpConfirmationState) {
                case .confirmed:
                    print("User is signed up and confirmed.")
                    self.performSegue(withIdentifier: "ConfirmSuccess", sender: self)
                case .unconfirmed:
                    print("User is not confirmed and needs verification via \(signUpResult.codeDeliveryDetails!.deliveryMedium) sent at \(signUpResult.codeDeliveryDetails!.destination!)")
                    DispatchQueue.main.async {
                        self.displayErrorAlert()
                    }
                case .unknown:
                    print("Unexpected case")
                }
            } else if let error = error {
                print("\(error.localizedDescription)")
            }
        }
    }
    
    func displayErrorAlert() {
        let alertController = UIAlertController(title: "Confirm Error", message: "The confirmation code is incorrect. Please re-enter.", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Close", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func doneButtonAction(sender: UIBarButtonItem) {
        if self.confirmCodeField.isFirstResponder {
            self.confirmCodeField.resignFirstResponder()
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
