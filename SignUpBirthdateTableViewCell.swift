//
//  SignUpBirthdateTableViewCell.swift
//  zhiyouios
//
//  Created by Yun Fei Guo on 2018-11-28.
//  Copyright © 2018 Yun Fei Guo. All rights reserved.
//

import UIKit

class SignUpBirthDateTableViewCell: UITableViewCell {
    
    //Properties
    let itemLabel: UILabel
    let item: UIDatePicker
    let marginSpace = 10.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {
        let screenWidth = Double(UIScreen.main.bounds.width)
        self.itemLabel = UILabel(frame: CGRect(x: marginSpace, y: marginSpace, width: screenWidth * 0.6,
                                               height: screenWidth * 0.05))
        self.itemLabel.text = "Birthdate"
        self.item = UIDatePicker(frame: CGRect(x: marginSpace, y: 2 * marginSpace + screenWidth * 0.05,
                                               width: screenWidth * 0.7, height: screenWidth * 0.1))
        self.item.timeZone = NSTimeZone.local
        self.item.backgroundColor = UIColor.white
        self.item.datePickerMode = UIDatePicker.Mode.date
        super.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: "SignUpBirthDateTableViewCell")
        self.item.addTarget(self, action: #selector(datePickerValueChanged(sender:)), for: UIControl.Event.valueChanged)
        self.contentView.addSubview(self.itemLabel)
        self.contentView.addSubview(self.item)
        self.contentView.widthAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 3.75).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func datePickerValueChanged(sender: UIDatePicker){
        print("Great")
    }
}
