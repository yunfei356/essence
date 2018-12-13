//
//  SignUpButtonTableViewCell.swift
//  zhiyouios
//
//  Created by Yun Fei Guo on 2018-11-28.
//  Copyright © 2018 Yun Fei Guo. All rights reserved.
//

import UIKit

class SignUpButtonTableViewCell: UITableViewCell {
    
    //Properties
    let item: UIButton
    let marginSpace = 20.0
    
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
        self.item = UIButton(frame: CGRect(x: marginSpace, y: 2 * marginSpace + screenWidth * 0.05, width: screenWidth * 0.7, height: screenWidth * 0.1))
        self.item.backgroundColor = UIColor.blue
        self.item.setTitle("Sign Up", for: UIControl.State.normal)
        super.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: "SignUpButtonTableViewCell")
        self.contentView.addSubview(self.item)
        self.contentView.widthAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 3.75).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
