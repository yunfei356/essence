//
//  AnswerTableViewCell.swift
//  zhiyouios
//
//  Created by Yun Fei Guo on 2018-12-04.
//  Copyright © 2018 Yun Fei Guo. All rights reserved.
//

import UIKit

class AnswerTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        accessoryType = selected ? .checkmark : .none
    }

}
