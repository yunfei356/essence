//
//  ProfileSelfIntroTableViewCell.swift
//  zhiyouios
//
//  Created by Yun Fei Guo on 2018-11-04.
//  Copyright © 2018 Yun Fei Guo. All rights reserved.
//

import UIKit

class ProfileSelfIntroTableViewCell: UITableViewCell {

    //Properties
    let itemLabel: UILabel
    let item: UITextView
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
        self.itemLabel.text = "Self-Introduction"
        self.item = UITextView(frame: CGRect(x: marginSpace, y: 2 * marginSpace + screenWidth * 0.05,
                                             width: screenWidth * 0.7, height: screenWidth * 0.3))
        self.item.backgroundColor = UIColor.yellow
        self.item.layer.cornerRadius = 10
        self.item.autocorrectionType = UITextAutocorrectionType.yes
        self.item.spellCheckingType = UITextSpellCheckingType.yes
        self.item.font = UIFont.boldSystemFont(ofSize: 20.0)
        self.item.font = UIFont(name: "Verdana", size: 17)
        super.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: "ProfileSelfIntroTableViewCell")
        self.contentView.addSubview(self.itemLabel)
        self.contentView.addSubview(self.item)
        self.contentView.widthAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 2.0).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
