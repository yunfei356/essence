//
//  SwipeableCardViewContainer.swift
//  zhiyouios
//
//  Created by Yun Fei Guo on 2018-11-05.
//  Copyright © 2018 Yun Fei Guo. All rights reserved.
//

import UIKit

class SwipeableCardViewContainer: UIView, SwipeableViewDelegate {
    
    static let horizontalInset: CGFloat = 12.0
    
    static let verticalInset: CGFloat = 12.0

    var dataSource: SwipeableCardViewDataSource? {
        didSet {
            reloadData()
        }
    }
    
    var cardViews: [SwipeableCardViewCard] = []
    
    var visibleCardViews: [SwipeableCardViewCard] {
        return subviews as? [SwipeableCardViewCard] ?? []
    }
    
    var remainingCards: Int = 0
    
    let numberOfVisibleCards: Int = 3
    /// Reloads the data used to layout card views in the
    /// card stack. Removes all existing card views and
    /// calls the dataSource to layout new card views.
    func reloadData() {
        removeAllCardViews()
        guard let dataSource = dataSource else {
            return
        }
        
        let numberOfCards = dataSource.numberOfCards()
        remainingCards = numberOfCards
        
        for index in 0..<min(numberOfCards, self.numberOfVisibleCards) {
            addCardView(cardView: dataSource.card(forItemAtIndex: index), atIndex: index)
        }
        
        /*
        if let emptyView = dataSource.viewForEmptyCards() {
            addEdgeConstrainedSubView(view: emptyView)
        }*/
        setNeedsLayout()
    }
    
    private func addCardView(cardView: SwipeableCardViewCard, atIndex index: Int) {
        setFrame(forCardView: cardView, atIndex: index)
        cardView.ownDelegate = self
        cardViews.append(cardView)
        cardView.contentSize.height = self.bounds.size.height * 2.0
        cardView.clipsToBounds = true
        cardView.layer.cornerRadius = 10.0
        cardView.backgroundColor = UIColor.yellow
        insertSubview(cardView, at: 0)
        remainingCards -= 1
    }
    
    private func removeAllCardViews() {
        for cardView in visibleCardViews {
            cardView.removeFromSuperview()
        }
        cardViews = []
    }
    
    /// Sets the frame of a card view provided for a given index. Applies a specific
    /// horizontal and vertical offset relative to the index in order to create an
    /// overlay stack effect on a series of cards.
    ///
    /// - Parameters:
    ///   - cardView: card view to update frame on
    ///   - index: index used to apply horizontal and vertical insets
    private func setFrame(forCardView cardView: SwipeableCardViewCard, atIndex index: Int) {
        var cardViewFrame = bounds
        let horizontalInset = (CGFloat(index) * SwipeableCardViewContainer.horizontalInset)
        let verticalInset = CGFloat(index) * SwipeableCardViewContainer.verticalInset
        
        cardViewFrame.size.width -= 2 * horizontalInset
        cardViewFrame.origin.x += horizontalInset
        cardViewFrame.origin.y += verticalInset
        
        cardView.frame = cardViewFrame
    }

    func didEndSwipe(onView view: SwipeableView) {
        guard let dataSource = dataSource, let dragDirection = view.dragDirection else {
            return
        }
        
        self.handleSwipeDirection(direction: dragDirection, view: view)
        
        // Remove swiped card
        view.removeFromSuperview()
        
        // Only add a new card if there are cards remaining
        if remainingCards > 0 {
            
            // Calculate new card's index
            let newIndex = dataSource.numberOfCards() - remainingCards
            
            // Add new card as Subview
            addCardView(cardView: dataSource.card(forItemAtIndex: newIndex), atIndex: 2)
        }
        
        for (cardIndex, cardView) in visibleCardViews.reversed().enumerated() {
            UIView.animate(withDuration: 0.2, animations: {
                cardView.center = self.center
                self.setFrame(forCardView: cardView, atIndex: cardIndex)
                self.layoutIfNeeded()
            })
        }
    }
    
    func handleSwipeDirection(direction: SwipeDirection, view: SwipeableView) {
        if direction.horizontalPosition.rawValue > 0 {
            print("Right")
            dataSource?.saveData(cardView: view as! SwipeableCardViewCard)
        }
        else if direction.horizontalPosition.rawValue < 0 {
            //handle swiping left
            print("Left")
        }
    }
}
