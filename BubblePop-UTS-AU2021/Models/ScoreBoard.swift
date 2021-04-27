//
//  ScoreBoard.swift
//  BubblePop-UTS-AU2021
//
//  Created by Trung Duc on 24/04/2021.
//

import UIKit

struct ScoreBoard {
    var scoreBoard = [(String, Int)]()
    
    mutating func addScore(name: String, score: Int) {
        self.scoreBoard.append((name, score))
        sortScoreBoard()
    }
    
    mutating func sortScoreBoard() {
        self.scoreBoard = self.scoreBoard.sorted{ $0.1 > $1.1 }
    }
    
    func getScoreBoard() -> [(String, Int)] {
        return self.scoreBoard
    }
    
    func getHighestScore() -> Int {
        return self.scoreBoard[0].1
    }
    
}
