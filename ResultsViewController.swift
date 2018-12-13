//
//  ResultsViewController.swift
//  zhiyouios
//
//  Created by Yun Fei Guo on 2018-10-30.
//  Copyright © 2018 Yun Fei Guo. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController, SwipeableCardViewDataSource {

    @IBOutlet weak var cardDeck: SwipeableCardViewContainer!
    
    
    var viewModels: [SampleCardViewModel] {
        
        let hamburger = SampleCardViewModel(title: "McDonalds", subtitle: "Hamburger",
                                            color: UIColor(red:0.96, green:0.81, blue:0.46, alpha:1.0))
        
        let panda = SampleCardViewModel(title: "Panda", subtitle: "Animal",
                                        color: UIColor(red:0.29, green:0.64, blue:0.96, alpha:1.0))
        let puppy = SampleCardViewModel(title: "Puppy", subtitle: "Pet",
                                        color: UIColor(red:0.29, green:0.63, blue:0.49, alpha:1.0))
        let puppy1 = SampleCardViewModel(title: "Puppy", subtitle: "Pet1",
                                         color: UIColor(red:0.29, green:0.63, blue:0.49, alpha:1.0))
        let puppy2 = SampleCardViewModel(title: "Puppy", subtitle: "Pet2",
                                         color: UIColor(red:0.29, green:0.63, blue:0.49, alpha:1.0))
        let puppy3 = SampleCardViewModel(title: "Puppy", subtitle: "Pet3",
                                         color: UIColor(red:0.29, green:0.63, blue:0.49, alpha:1.0))
        let puppy4 = SampleCardViewModel(title: "Puppy", subtitle: "Pet4",
                                         color: UIColor(red:0.29, green:0.63, blue:0.49, alpha:1.0))
        let puppy5 = SampleCardViewModel(title: "Puppy", subtitle: "Pet5",
                                         color: UIColor(red:0.29, green:0.63, blue:0.49, alpha:1.0))
        let puppy6 = SampleCardViewModel(title: "Puppy", subtitle: "Pet6",
                                         color: UIColor(red:0.29, green:0.63, blue:0.49, alpha:1.0))
        return [hamburger, panda, puppy, puppy1, puppy2, puppy3, puppy4, puppy5, puppy6]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardDeck.dataSource = self
    }
    
    func numberOfCards() -> Int {
        return viewModels.count
    }
    
    func card(forItemAtIndex index: Int) -> SwipeableCardViewCard {
        let viewModel = viewModels[index]
        let cardView = SampleCard()
        cardView.viewModel = viewModel
        return cardView
    }
    
    func viewForEmptyCards() -> UIView? {
        return nil
    }
    
    func saveData(cardView card: SwipeableCardViewCard) {
        
    }
}

