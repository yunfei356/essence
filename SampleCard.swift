//
//  SampleCard.swift
//  zhiyouios
//
//  Created by Yun Fei Guo on 2018-11-08.
//  Copyright © 2018 Yun Fei Guo. All rights reserved.
//

import UIKit

class SampleCard: SwipeableCardViewCard {

    var titleLabel: UILabel!
    var subtitleLabel: UILabel!
    
    var viewModel: SampleCardViewModel? {
        didSet {
            configure(forViewModel: viewModel)
        }
    }
    
    func configure(forViewModel viewModel: SampleCardViewModel?) {
        if let viewModel = viewModel {
            let marginSpace = 10.0
            let screenWidth = Double(UIScreen.main.bounds.width)
            self.titleLabel = UILabel(frame: CGRect(x: marginSpace, y: marginSpace, width: screenWidth * 0.6,
                                                    height: screenWidth * 0.1))
            self.subtitleLabel = UILabel(frame: CGRect(x: marginSpace, y: 2 * marginSpace + screenWidth * 0.05, width: screenWidth * 0.6, height: screenWidth * 0.1))
            titleLabel.text = viewModel.title
            subtitleLabel.text = viewModel.subtitle
            self.addSubview(self.titleLabel)
            self.addSubview(self.subtitleLabel)
        }
    }
}
