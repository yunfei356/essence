//
//  ChatViewController.swift
//  zhiyouios
//
//  Created by Yun Fei Guo on 2018-10-30.
//  Copyright © 2018 Yun Fei Guo. All rights reserved.
//

import UIKit
import AWSMobileClient
import AWSAppSync

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,
UITextViewDelegate {
    
    //Mark: Properties
    var appSyncClient: AWSAppSyncClient?
    
    @IBOutlet weak var tableView: UITableView!
    let imagesCellIdentifier = "ProfileImagesTableViewCell"
    let birthdateCellIdentifier = "ProfileBirthDateTableViewCell"
    let selfIntroCellIdentifier = "ProfileSelfIntroTableViewCell"
    let nameCellIdentifier = "ProfileNameTableViewCell"
    let phoneCellIdentifier = "ProfilePhoneTableViewCell"
    var selfIntroTextView: UITextView = UITextView()
    var nameTextField: UITextField = UITextField()
    var phoneTextField: UITextField = UITextField()
    private var personId: String = "fa1db430-705f-47c2-9b84-1f18ddd64ce6"
    private var name: String?
    private var phone: String?
    
    //Mark: Navigations
    
    @IBAction func onCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appSyncClient = appDelegate.appSyncClient
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
        
        getProfileFromAPI()
    }
    
    func getProfileFromAPI() {
        let getProfileInput = GetProfileInput(personId: self.personId)
        print(self.personId)
        appSyncClient?.fetch(query: GetProfileQuery(input: getProfileInput)) { (result, error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
                return
            }
            print("result: ", result?.data ?? "No data")
            let profile = result?.data?.getProfile
            self.name = profile?.profileBase.name
            self.phone = profile?.profileBase.phone
        }
        print("Name: ", self.name ?? "HI")
        print("Phone: ", self.phone ?? "HI")
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else {return}
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardFrame = keyboardSize.cgRectValue
        tableView.contentSize.height += keyboardFrame.height
        if self.view.frame.origin.y == 0 {
            self.view.frame.origin.y -= keyboardFrame.height
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        guard let userInfo = notification.userInfo else {return}
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardFrame = keyboardSize.cgRectValue
        tableView.contentSize.height -= keyboardFrame.height
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y += keyboardFrame.height
        }
    }
    
    // The following four functions render the tableview and its contents
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        if indexPath.section == 0 {
            tableView.register(ProfileImagesTableViewCell.self,
                               forCellReuseIdentifier: self.imagesCellIdentifier)
            cell = tableView.dequeueReusableCell(withIdentifier: self.imagesCellIdentifier, for: indexPath)
        }
        else if indexPath.section == 2 && indexPath.row == 0 {
            tableView.register(ProfileBirthDateTableViewCell.self,
                               forCellReuseIdentifier: self.birthdateCellIdentifier)
            cell = tableView.dequeueReusableCell(withIdentifier: self.birthdateCellIdentifier, for: indexPath)
        }
        else if indexPath.section == 2 && indexPath.row == 1{
            tableView.register(ProfileNameTableViewCell.self,
                               forCellReuseIdentifier: self.nameCellIdentifier)
            cell = tableView.dequeueReusableCell(withIdentifier: self.nameCellIdentifier, for: indexPath)
            self.nameTextField = (cell as! ProfileNameTableViewCell).item
            self.nameTextField.inputAccessoryView = createKeyboardDoneButton()
        }
        else if indexPath.section == 2 && indexPath.row == 2 {
            tableView.register(ProfilePhoneTableViewCell.self,
                               forCellReuseIdentifier: self.phoneCellIdentifier)
            cell = tableView.dequeueReusableCell(withIdentifier: self.phoneCellIdentifier, for: indexPath)
            self.phoneTextField = (cell as! ProfilePhoneTableViewCell).item
            self.phoneTextField.inputAccessoryView = createKeyboardDoneButton()
        }
        else if indexPath.section == 2 && indexPath.row == 3 {
            tableView.register(ProfileSelfIntroTableViewCell.self,
                               forCellReuseIdentifier: self.selfIntroCellIdentifier)
            cell = tableView.dequeueReusableCell(withIdentifier: self.selfIntroCellIdentifier, for: indexPath)
            self.selfIntroTextView = (cell as! ProfileSelfIntroTableViewCell).item
            self.selfIntroTextView.delegate = self
            self.selfIntroTextView.inputAccessoryView = createKeyboardDoneButton()
        }
        else {
            cell = UITableViewCell()
        }
        tableView.allowsSelection = false
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 || section == 1 {
            return 1
        }
        else if section == 2 {
            return 4
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension;
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
        if (self.selfIntroTextView.isFirstResponder) {
            self.selfIntroTextView.endEditing(true)
        } else if self.nameTextField.isFirstResponder {
            self.nameTextField.resignFirstResponder()
        } else if self.phoneTextField.isFirstResponder {
            self.phoneTextField.resignFirstResponder()
        }
    }
}
