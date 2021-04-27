//
//  Distance.swift
//  BubblePop-UTS-AU2021
//
//  Created by Trung Duc on 23/04/2021.
//

import Foundation
import UIKit

enum Distance {
    static func Distance(_ from: (x: Double, y: Double), _ to: (x: Double, y:Double)) -> Double {
        let diffX = to.x - from.x
        let diffY = to.y - from.y
        return sqrt(pow(diffX, 2) + pow(diffY, 2))
    }
    
    static func Distance(_ from: CGPoint, _ to: CGPoint) -> Double {
        return self.Distance((x: Double(from.x), y: Double(from.y)), (x: Double(to.x), y: Double(to.y)))
    }
}
