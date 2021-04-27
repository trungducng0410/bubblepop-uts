//
//  Bubble.swift
//  BubblePop-UTS-AU2021
//
//  Created by Trung Duc on 21/04/2021.
//

import UIKit

class Bubble: CircularButton {
    
    public var pointValue = 1
    
    // default maximum size of the bubble
    var maxFrame = CGRect(x: 0, y: 0, width: 75, height: 75)
    
    // indicating if the bubble is being removed
    var isRemoving = false
    
    // default moving speed
    var moveSpeed = 1.0
    
    // default bubble type is red
    private var _bubbleType = BubbleType.red
    // base image for bubble
    private var bgImage = UIImage(named: "red")!
    
    var bubbleType: BubbleType {
        get { _bubbleType }
        set {
            _bubbleType = newValue
            updateImageAndPoints()
        }
    }
    
    var textColor: UIColor = UIColor.black
    
    // presenting approx center of the button, can be nil
    var presentationCenter: CGPoint? {
        get {
            if let frame = layer.presentation()?.frame {
                let haftWidth = CGFloat(frame.width / 2.0)
                return CGPoint(x: frame.minX + haftWidth, y: frame.minY + haftWidth)
            }
            
            return nil
        }
    }
    
    // optional closure to allow consumer to hook into the completion
    // of the successfulTouch event
    private var onPopped: ((_ bubble: Bubble) -> Void)?
    
    // constructor
    init(center: CGPoint, size: Double, type: BubbleType, onPopped: @escaping (_ bubble: Bubble) -> Void) {
        super.init(frame: CGRect(x: 0, y: 0, width: size, height: size))
        
        self.center = center
        self.onPopped = onPopped
        bubbleType = type
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        updateImageAndPoints()
        commonInit()
    }
    
    private func commonInit() {
        // bubble is invisible with scale = 0 initially
        alpha = 0
        maxFrame = frame
        transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        // prevents the parent class from handling touch functionality
        self.shoudHandleTouches = false
    }
    
    override func successfulTouch() {
        self.isRemoving = true
        
        UIView.animate(withDuration: 0.15) {
            self.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
            self.alpha = 0
        } completion: { (Void) in
            self.onPopped?(self)
            self.removeFromSuperview()
        }

    }
    
    func appear() {
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
            self.transform = CGAffineTransform.identity
        }
        
        moveUpwards()
    }
    
    private func moveUpwards() {
        if (!isRemoving) {
            let animMoveSpeed = -maxFrame.height * CGFloat(moveSpeed)
            let animDuration: CGFloat = 1.0
            let animYOffset = animMoveSpeed * animDuration
            
            UIView.animate(withDuration: 1, delay: 0, options: [.curveLinear, .allowUserInteraction, .beginFromCurrentState]) {
                self.center.y += animYOffset
            } completion: { (_) in
                self.moveUpwards()
            }

        }
    }
    
    func disappear(onAnimComplate: ((_ bubble: Bubble) -> Void)? = nil) {
        self.isRemoving = true
        UIView.animate(withDuration: 0.15, delay: 0, options: .beginFromCurrentState) {
            self.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        } completion: { (Void) in
            onAnimComplate?(self)
            self.removeFromSuperview()
        }
    }
    
    private func updateImageAndPoints() {
        switch bubbleType {
        case .red:
            pointValue = 1
            moveSpeed = 1.0
            setBubbleImage(name: "red")
            textColor = UIColor.red
        case .pink:
            pointValue = 2
            moveSpeed = 1.5
            setBubbleImage(name: "pink")
            textColor = UIColor.magenta
        case .green:
            pointValue = 5
            moveSpeed = 1.75
            setBubbleImage(name: "green")
            textColor = UIColor.green
        case .blue:
            pointValue = 8
            moveSpeed = 2.0
            setBubbleImage(name: "blue")
            textColor = UIColor.blue
        case .black:
            pointValue = 10
            moveSpeed = 5.0
            setBubbleImage(name: "black")
            textColor = UIColor.black
        case .boom:
            pointValue = -10
            moveSpeed = 2.5
            setBubbleImage(name: "boom")
            textColor = UIColor.red
        case .clock:
            pointValue = 0
            moveSpeed = 3.0
            setBubbleImage(name: "clock")
            textColor = UIColor.green
        }
    }
    
    private func setBubbleImage(name: String) {
        if let image = UIImage(named: name) {
            bgImage = image
            setBackgroundImage(bgImage, for: .normal)
        }
    }
}
