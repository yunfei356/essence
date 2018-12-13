//
//  SwipeableView.swift
//  zhiyouios
//
//  Created by Yun Fei Guo on 2018-11-05.
//  Copyright © 2018 Yun Fei Guo. All rights reserved.
//

import UIKit

class SwipeableView: UIScrollView, UIGestureRecognizerDelegate {
    
    // Mark: Own Delegate
    var ownDelegate: SwipeableViewDelegate?
    
    // Mark: Gesture Recognizer
    private var panRecognizer: UIPanGestureRecognizer?
    private var panGestureTranslation: CGPoint = .zero
    private var cumPanVect: CGPoint = .zero // cumulative vector from beginning of pan
    private var cumPanGestureVect: CGPoint = .zero // cumulative vector from beginning of swipe
    
    // Mark: Subviews (Decision Indicators)
    private var xMark: UIImageView = UIImageView()
    private var checkMark: UIImageView = UIImageView()
    
    // MARK: Animation settings
    static var rotationAngle: CGFloat = CGFloat(Double.pi) / 10.0
    static var swipePercentageMargin: CGFloat = 0.4
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        prepareDecisionIndicators()
        setupGestureRecognizers()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareDecisionIndicators()
        setupGestureRecognizers()
    }
    
    deinit {
        if let panGestureRecognizer = panRecognizer {
            removeGestureRecognizer(panGestureRecognizer)
        }
    }
    
    private func prepareDecisionIndicators() {
        xMark.image = UIImage(named: "first")
        checkMark.image = UIImage(named: "second")
        addSubview(xMark)
        addSubview(checkMark)
        xMark.frame = CGRect(x: -1.0 * screenWidth * 0.25, y: screenHeight / 3.0, width: 100.0, height: 100.0)
        checkMark.frame = CGRect(x: screenWidth * 1.1, y: screenHeight / 3.0, width: 100.0, height: 100.0)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    private func setupGestureRecognizers() {
        // Pan Gesture Recognizer
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(SwipeableView.panRecognized(_:)))
        panGestureRecognizer.delegate = self
        self.panRecognizer = panGestureRecognizer
        addGestureRecognizer(panGestureRecognizer)
        self.panGestureRecognizer.addTarget(self, action: #selector(SwipeableView.panGestureRecognizer(_:)))
    }


    @objc private func panGestureRecognizer(_ gestureRecognizer: UIPanGestureRecognizer) {
        panGestureTranslation = gestureRecognizer.translation(in: self)
        switch gestureRecognizer.state {
        case .began:
            self.cumPanGestureVect = panGestureTranslation
        case .changed:
            self.cumPanGestureVect.x += panGestureTranslation.x
            self.cumPanGestureVect.y += panGestureTranslation.y
            if abs(self.cumPanGestureVect.y / self.cumPanGestureVect.x) < 0.3 {
                self.isScrollEnabled = false
                return
            }
        default:
            return
        }
    }
    
    @objc private func panRecognized(_ gestureRecognizer: UIPanGestureRecognizer) {
        panGestureTranslation = gestureRecognizer.translation(in: self)
        var rotationPoint = CGPoint(x: 0.0, y: bounds.size.height)
        switch gestureRecognizer.state {
        case .began:
            self.cumPanVect = panGestureTranslation
            let initialTouchPoint = gestureRecognizer.location(in: self)
            let newAnchorPoint = CGPoint(x: initialTouchPoint.x / bounds.width, y: initialTouchPoint.y / bounds.height)
            let oldPosition = CGPoint(x: bounds.size.width * layer.anchorPoint.x, y: bounds.size.height * layer.anchorPoint.y)
            let newPosition = CGPoint(x: bounds.size.width * newAnchorPoint.x, y: bounds.size.height * newAnchorPoint.y)
            layer.anchorPoint = newAnchorPoint
            layer.position = CGPoint(x: layer.position.x - oldPosition.x + newPosition.x, y: layer.position.y - oldPosition.y + newPosition.y)
            layer.rasterizationScale = UIScreen.main.scale
            layer.shouldRasterize = true
        case .changed:
            self.cumPanVect.x += panGestureTranslation.x
            self.cumPanVect.y += panGestureTranslation.y
            if abs(self.cumPanVect.y / self.cumPanVect.x) > 0.3 {
                self.isScrollEnabled = true
                return
            }
            if panGestureTranslation.x > 0 {
                rotationPoint.x = bounds.size.width
            }
            let rotationStrength = panGestureTranslation.x / frame.width
            let rotationAngle = SwipeableView.rotationAngle * rotationStrength
            var transform = CATransform3DIdentity
            transform = CATransform3DTranslate(transform, rotationPoint.x-center.x, rotationPoint.y-center.y, 0.0);
            transform = CATransform3DRotate(transform, rotationAngle, 0.0, 0.0, 1.0);
            transform = CATransform3DTranslate(transform, center.x-rotationPoint.x, center.y-rotationPoint.y, 0.0);
            layer.transform = transform
            if self.isScrollEnabled == false {
                UIView.animate(withDuration: 0.2, animations: {
                    self.layoutIfNeeded()
                    if self.cumPanVect.x < 0.0 {
                        self.xMark.frame = CGRect(x: self.screenWidth / 4.0, y: self.screenHeight / 3.0 , width: 100.0, height: 100.0)
                    }
                    else {
                        self.checkMark.frame = CGRect(x: self.screenWidth / 2.4, y: self.screenHeight / 3.0, width: 100.0, height: 100.0)
                    }
                }, completion: nil)
            }
        case .ended:
            print("Inside ended")
            endedPanAnimation()
            layer.shouldRasterize = false
        default:
            resetCardViewPosition()
            layer.shouldRasterize = false
        }
    }
    
    var dragDirection: SwipeDirection? {
        let normalizedDragPoint = CGPoint(x: panGestureTranslation.x / bounds.size.width,
                                          y: panGestureTranslation.y / bounds.size.height)
        return SwipeDirection.allDirections.reduce((distance: CGFloat.infinity, direction: nil), { closest, direction -> (CGFloat, SwipeDirection?) in
            let distance = self.distBtwTwoPoints(point1: direction.point, point2: normalizedDragPoint)
            if distance < closest.distance {
                return (distance, direction)
            }
            return closest
        }).direction
    }
    
    private func distBtwTwoPoints(point1: CGPoint, point2: CGPoint) -> CGFloat {
        let x_dist = point1.x - point2.x
        let y_dist = point1.y - point2.y
        return sqrt(x_dist * x_dist + y_dist * y_dist)
    }
    
    private func scalarProjection(point1: CGPoint, point2: CGPoint) -> CGPoint {
        let angle = abs(atan2(point2.y, point2.x) - atan2(point1.y, point1.x))
        let x = cos(angle) * point2.x * sqrt(point1.x * point1.x + point1.y * point1.y)
        let y = cos(angle) * point2.y * sqrt(point1.x * point1.x + point1.y * point1.y)
        return CGPoint(x: x, y: y)
    }
    
    // Finds distance between the line (swipePoint, CGPoint.zero) and the perimeter
    // of SwipeDirection.boundsRect. The intersection at the perimeter must have coordinates <= 1.
    private func rectIntersect(swipePoint: CGPoint) -> CGFloat {
        var resultSet = [CGPoint]()
        var xSet = [swipePoint.x / swipePoint.y, 1.0, 1.0, swipePoint.x / swipePoint.y,
                    -1 * swipePoint.x / swipePoint.y, -1.0, -1.0, -1 * swipePoint.x / swipePoint.y]
        var ySet = [-1.0, -1 * swipePoint.y / swipePoint.x, swipePoint.y / swipePoint.x,
                    1.0, 1.0, swipePoint.y / swipePoint.x, -1 * swipePoint.y / swipePoint.x, -1.0]
        
        for i in 0...7 {
            if xSet[i] >= -1 && xSet[i] <= 1 && ySet[i] >= -1 && ySet[i] <= 1 {
                resultSet.append(CGPoint(x: xSet[i], y: ySet[i]))
            }
        }
        return resultSet.reduce((distance: CGFloat.infinity, currPoint: nil), { closest,
            currPoint -> (CGFloat, CGPoint?) in
            let distance = self.distBtwTwoPoints(point1: currPoint, point2: swipePoint)
            if distance < closest.0 {
                return (distance, currPoint)
            }
            return closest
        }).0
    }
    
    private var dragPercentage: CGFloat {
        guard let dragDirection = dragDirection else { return 0.0 }
        
        let normalizedDragPoint = CGPoint(x: panGestureTranslation.x / frame.size.width,
                                          y: panGestureTranslation.y / frame.size.height)
        let swipePoint = self.scalarProjection(point1: normalizedDragPoint, point2: dragDirection.point)
        
        let rect = SwipeDirection.boundsRect
        
        if !rect.contains(swipePoint) {
            return 1.0
        } else {
            let centerDistance = self.distBtwTwoPoints(point1: swipePoint, point2: .zero)
            let intersectDistance = self.rectIntersect(swipePoint: swipePoint)
            return centerDistance / (centerDistance + intersectDistance)
        }
    }
    
    private func endedPanAnimation() {
        print("Inside EndedPanAnimation")
        if let dragDirection = dragDirection, dragPercentage >= SwipeableView.swipePercentageMargin {
            UIView.animate(withDuration: 0.5, animations: {
                self.layoutIfNeeded()
                self.center.x += self.bounds.width * dragDirection.horizontalPosition.rawValue
            }, completion: { (finished: Bool) in
                self.ownDelegate?.didEndSwipe(onView: self)})
        } else {
            resetCardViewPosition()
        }
    }
    
     private func resetCardViewPosition() {
        UIView.animate(withDuration: 0.5, animations: {
            self.layoutIfNeeded()
            self.layer.transform = CATransform3DIdentity
            self.xMark.frame = CGRect(x: -1.0 * self.screenWidth * 0.25, y: self.screenHeight / 3.0, width: 100.0, height: 100.0)
            self.checkMark.frame = CGRect(x: self.screenWidth * 1.1, y: self.screenHeight / 3.0, width: 100.0, height: 100.0)
        })
    }
    
    private func moveCardOffScreen(dragDirection: SwipeDirection) {
        var transform = CATransform3DIdentity
        transform = CATransform3DTranslate(transform, 50.0 * dragDirection.horizontalPosition.rawValue, 50.0 * dragDirection.verticalPosition.rawValue, 0.0);
        layer.transform = transform
    }
    
}


