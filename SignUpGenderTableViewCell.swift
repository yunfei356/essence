//
//  SignUpGenderTableViewCell.swift
//  zhiyouios
//
//  Created by Yun Fei Guo on 2018-11-28.
//  Copyright © 2018 Yun Fei Guo. All rights reserved.
//

import UIKit

class SignUpGenderTableViewCell: UITableViewCell {
    
    //Properties
    let itemLabel: UILabel
    let item: UIPickerView
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
        self.itemLabel = UILabel(frame: CGRect(x: marginSpace, y: marginSpace, width: screenWidth * 0.6, height: screenWidth * 0.05))
        self.itemLabel.text = "Gender"
        self.item = UIPickerView(frame: CGRect(x: marginSpace, y: 2 * marginSpace + screenWidth * 0.05, width: screenWidth * 0.7, height: screenWidth * 0.1))
        //self.item = UIPickerView()
        super.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: "SignUpGenderTableViewCell")
        self.contentView.addSubview(self.itemLabel)
        self.contentView.addSubview(self.item)
        self.contentView.widthAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 4.0).isActive = true
        //let itemCenter = CGPoint(x: screenWidth / 2.0, y: screenWidth / 3.25 / 2)
        //self.item.center = itemCenter
        //self.item.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        //self.item.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
