//
//  ProfileImagesTableViewCell.swift
//  zhiyouios
//
//  Created by Yun Fei Guo on 2018-11-01.
//  Copyright © 2018 Yun Fei Guo. All rights reserved.
//

import UIKit

class ProfileImagesTableViewCell: UITableViewCell {

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
        var id: String?
        id = "ProfileImagesTableViewCell"
        super.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: id)
        self.contentView.widthAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 1.0).isActive = true
        self.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                         action: #selector(handleTap(sender:))))
        self.backgroundColor = UIColor.green
        self.initializeImages()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        print("Hello")
    }
    
    func initializeOneImage(x_coord: Double, y_coord: Double, isProfilePic: Bool) -> UIImageView {
        let cellWidth = Double(UIScreen.main.bounds.width)
        var widthMultiplier: Double
        if isProfilePic {
            widthMultiplier = 2.0 / 3.0
        }
        else {
            widthMultiplier = 1.0 / 3.0
        }
        let image = UIImage(named: "first")
        let imgView = UIImageView(image: image)
        imgView.isUserInteractionEnabled = true
        imgView.frame = CGRect(x: x_coord, y: y_coord, width: cellWidth * widthMultiplier,
                               height: cellWidth * widthMultiplier)
        imgView.backgroundColor = UIColor.red
        self.contentView.addSubview(imgView)
        return imgView
    }
    
    func initializeImages() {
        //Image TM (Top Middle)
        var x = Double(UIScreen.main.bounds.width * 1.0 / 3.0)
        var y = 0.0
        let imgViewTR = self.initializeOneImage(x_coord: x, y_coord: y, isProfilePic: true)
        //Image TL (Top Left)
        x = 0.0
        let imgViewTL = self.initializeOneImage(x_coord: x, y_coord: y, isProfilePic: false)
        //Image ML (Middle Left)
        y = Double(UIScreen.main.bounds.width * 1.0 / 3.0)
        let imgViewMR = self.initializeOneImage(x_coord: x, y_coord: y, isProfilePic: false)
        //Image BL (Bottom Left)
        y = Double(UIScreen.main.bounds.width * 2.0 / 3.0)
        let imgViewBR = self.initializeOneImage(x_coord: x, y_coord: y, isProfilePic: false)
        //Image BM (Bottom Middle)
        x = Double(UIScreen.main.bounds.width * 1.0 / 3.0)
        let imgViewBM = self.initializeOneImage(x_coord: x, y_coord: y, isProfilePic: false)
        //Image BL (Bottom Right)
        x = Double(UIScreen.main.bounds.width * 2.0 / 3.0)
        let imgViewBL = self.initializeOneImage(x_coord: x, y_coord: y, isProfilePic: false)
    }
    
    func addCustomView() {
        let image = UIImage(named: "first")
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.frame = CGRect(x: 50, y: 50, width: 50, height: 50)
        button.setImage(image, for: UIControl.State.normal)
        button.addTarget(self, action: "AddImage", for: UIControl.Event.touchUpInside)
        self.addSubview(button)
    }

}
