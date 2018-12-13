//
//  SignUpViewController.swift
//  zhiyouios
//
//  Created by Yun Fei Guo on 2018-11-28.
//  Copyright © 2018 Yun Fei Guo. All rights reserved.
//

import UIKit
import AWSMobileClient
import AWSAppSync

class SignUpViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,
UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    @IBAction func onCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    var appSyncClient: AWSAppSyncClient?
    
    // constants
    let nameCellIdentifier = "SignUpNameTableViewCell"
    let phoneCellIdentifier = "SignUpPhoneTableViewCell"
    let genderCellIdentifier = "SignUpGenderTableViewCell"
    let birthdateCellIdentifier = "SignUpBirthdateTableViewCell"
    let emailCellIdentifier = "SignUpEmailTableVieweCell"
    let passwordCellIdentifier = "SignUpPasswordTableViewCell"
    let buttonCellIdentifier = "SignUpButtonTableViewCell"
    let genderDropDown = ["Male", "Female"]
    
    var nameTextField: UITextField = UITextField()
    var phoneTextField: UITextField = UITextField()
    var genderPickerView: UIPickerView = UIPickerView()
    var birthdatePicker: UIDatePicker = UIDatePicker()
    var emailTextField: UITextField = UITextField()
    var passwordTextField: UITextField = UITextField()
    var signUpButton: UIButton = UIButton()
    
    // Values of fields to be saved to backend
    var selectedGender: String?
    var name: String?
    var phone: String?
    var birthdate: String?
    var email: String?
    var password: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appSyncClient = appDelegate.appSyncClient
    }
    
    // Functions that handle the keyboard
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else {return}
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardFrame = keyboardSize.cgRectValue
        if self.emailTextField.isFirstResponder || self.passwordTextField.isFirstResponder {
            if self.view.frame.origin.y == 0 {
                tableView.contentSize.height += keyboardFrame.height
                self.view.frame.origin.y -= keyboardFrame.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        guard let userInfo = notification.userInfo else {return}
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardFrame = keyboardSize.cgRectValue
        if self.view.frame.origin.y != 0 {
            tableView.contentSize.height -= keyboardFrame.height
            self.view.frame.origin.y += keyboardFrame.height
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
    
    @objc func doneButtonAction(sender: UIBarButtonItem) {
        if (self.nameTextField.isFirstResponder) {
            self.nameTextField.endEditing(true)
            self.nameTextField.resignFirstResponder()
        } else if (self.phoneTextField.isFirstResponder) {
            self.phoneTextField.endEditing(true)
            self.phoneTextField.resignFirstResponder()
        } else if (self.emailTextField.isFirstResponder) {
            self.emailTextField.endEditing(true)
            self.emailTextField.resignFirstResponder()
        } else if (self.passwordTextField.isFirstResponder) {
            self.passwordTextField.endEditing(true)
            self.passwordTextField.resignFirstResponder()
        }
    }
    
    // Tableview Functions
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 6
        } else if section == 1 {
            return 1
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        if indexPath.section == 0 && indexPath.row == 0 {
            tableView.register(SignUpNameTableViewCell.self,
                               forCellReuseIdentifier: self.nameCellIdentifier)
            cell = tableView.dequeueReusableCell(withIdentifier: self.nameCellIdentifier, for: indexPath)
            self.nameTextField = (cell as! SignUpNameTableViewCell).item
            self.nameTextField.delegate = self
            self.nameTextField.inputAccessoryView = createKeyboardDoneButton()
        } else if indexPath.section == 0 && indexPath.row == 1 {
            tableView.register(SignUpPhoneTableViewCell.self,
                               forCellReuseIdentifier: self.phoneCellIdentifier)
            cell = tableView.dequeueReusableCell(withIdentifier: self.phoneCellIdentifier, for: indexPath)
            self.phoneTextField = (cell as! SignUpPhoneTableViewCell).item
            self.phoneTextField.delegate = self
            self.phoneTextField.inputAccessoryView = createKeyboardDoneButton()
        } else if indexPath.section == 0 && indexPath.row == 2 {
            tableView.register(SignUpGenderTableViewCell.self,
                               forCellReuseIdentifier: self.genderCellIdentifier)
            cell = tableView.dequeueReusableCell(withIdentifier: self.genderCellIdentifier, for: indexPath)
            self.genderPickerView = (cell as! SignUpGenderTableViewCell).item
            self.genderPickerView.delegate = self
            self.genderPickerView.dataSource = self
        } else if indexPath.section == 0 && indexPath.row == 3 {
            tableView.register(SignUpBirthDateTableViewCell.self,
                               forCellReuseIdentifier: self.birthdateCellIdentifier)
            cell = tableView.dequeueReusableCell(withIdentifier: self.birthdateCellIdentifier, for: indexPath)
            self.birthdatePicker = (cell as! SignUpBirthDateTableViewCell).item
            self.birthdatePicker.addTarget(self, action: #selector(storeSelectedRow(sender:)), for: UIControl.Event.valueChanged)
        } else if indexPath.section == 0 && indexPath.row == 4 {
            tableView.register(SignUpEmailTableViewCell.self,
                               forCellReuseIdentifier: self.emailCellIdentifier)
            cell = tableView.dequeueReusableCell(withIdentifier: self.emailCellIdentifier, for: indexPath)
            self.emailTextField = (cell as! SignUpEmailTableViewCell).item
            self.emailTextField.delegate = self
            self.emailTextField.inputAccessoryView = createKeyboardDoneButton()
        }
        else if indexPath.section == 0 && indexPath.row == 5 {
            tableView.register(SignUpPasswordTableViewCell.self,
                               forCellReuseIdentifier: self.passwordCellIdentifier)
            cell = tableView.dequeueReusableCell(withIdentifier: self.passwordCellIdentifier, for: indexPath)
            self.passwordTextField = (cell as! SignUpPasswordTableViewCell).item
            self.passwordTextField.delegate = self
            self.passwordTextField.inputAccessoryView = createKeyboardDoneButton()
        }
        else if indexPath.section == 1 {
            tableView.register(SignUpButtonTableViewCell.self,
                               forCellReuseIdentifier: self.buttonCellIdentifier)
            cell = tableView.dequeueReusableCell(withIdentifier: self.buttonCellIdentifier, for: indexPath)
            self.signUpButton = (cell as! SignUpButtonTableViewCell).item
            self.signUpButton.addTarget(self, action: #selector(handleSignUp(sender:)), for: UIControl.Event.touchUpInside)
        }
        else {
            cell = UITableViewCell()
        }
        tableView.allowsSelection = false
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension;
    }
    
    // The next several functions handle the sign up process
    
    func textFieldDidEndEditing(_ textField: UITextField,
                                reason: UITextField.DidEndEditingReason) {
        if (self.nameTextField.accessibilityLabel == textField.accessibilityLabel) {
            print("Store Name")
            self.name = textField.text
        } else if (self.phoneTextField.accessibilityLabel == textField.accessibilityLabel) {
            self.phone = textField.text
        } else if (self.emailTextField.accessibilityLabel == textField.accessibilityLabel) {
            self.email = textField.text
        } else if (self.passwordTextField.accessibilityLabel == textField.accessibilityLabel) {
            self.password = textField.text
        }
    }
    
    @objc func storeSelectedRow(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        self.birthdate = formatter.string(from: sender.date)
    }
    
    @objc func handleSignUp(sender: UIButton) {
        print(self.selectedGender ?? "HI")
        print(self.name ?? "HI")
        print(self.phone ?? "HI")
        print(self.email ?? "HI")
        print(self.password ?? "HI")
        print(self.birthdate ?? "HI")
        
        signUpWithCognito(email: self.email!, password: self.password!, name: self.name!,
                          birthdate: self.birthdate!, gender: self.selectedGender!)
    }
    
    func signUpWithCognito(email: String, password: String, name: String, birthdate: String,
                           gender: String) {
        AWSMobileClient.sharedInstance().signUp(username: email, password: password, userAttributes: ["name": name, "birthdate": birthdate, "gender": gender]) { (signUpResult, error) in
            if let signUpResult = signUpResult {
                switch(signUpResult.signUpConfirmationState) {
                case .confirmed:
                    print("User is signed up and confirmed.")
                case .unconfirmed:
                    print("User is not confirmed and needs verification via \(signUpResult.codeDeliveryDetails!.deliveryMedium) sent at \(signUpResult.codeDeliveryDetails!.destination!)")
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "ConfirmSignUp", sender: self)
                    }
                case .unknown:
                    print("Unexpected case")
                }
            } else if let error = error {
                if let error = error as? AWSMobileClientError {
                    switch(error) {
                    case .usernameExists(let message):
                        print(message)
                    default:
                        break
                    }
                }
                print("\(error.localizedDescription)")
            }
        }
    }
    
    // The next three functions are used to render the gender pickerview in SignUpGenderTableViewCell.
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.genderDropDown.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.genderDropDown[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedGender = self.genderDropDown[row]
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        if let destinationViewController = segue.destination as? ConfirmSignUpViewController {
            destinationViewController.email = self.email
        }
    }
 

}
