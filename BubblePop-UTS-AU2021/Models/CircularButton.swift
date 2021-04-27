//
//  CircularButton.swift
//  BubblePop-UTS-AU2021
//
//  Created by Trung Duc on 23/04/2021.
//

import UIKit

class CircularButton: UIButton {
    
    var shoudHandleTouches = true
    
    final override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if shoudHandleTouches, let touch = touches.first, isPointInside(touch.location(in: self.superview)) {
            successfulTouch()
            super.touchesBegan(touches, with: event)
        }
    }
    
    func isPointInside(_ point: CGPoint) -> Bool {
        let currFrame = layer.presentation()?.frame ?? frame
        let radius = CGFloat(currFrame.width / 2.0)
        let center = CGPoint(x: currFrame.minX + radius, y: currFrame.minY + radius)
        
        return Distance.Distance(point, center) <= Double(radius)
    }
    
    func successfulTouch() {
        
    }
}
