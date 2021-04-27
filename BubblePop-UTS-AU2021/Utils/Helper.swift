//
//  Helper.swift
//  BubblePop-UTS-AU2021
//
//  Created by Trung Duc on 24/04/2021.
//

import UIKit

extension PlayerEntity {
    func toPlayer() -> Player {
        let player = Player(name : self.name!, score : Int(self.score) )
        return player
    }
}

struct Helper {

    static func retrivePlayers() -> [Player] {
        var players: [Player] = []
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let result : [PlayerEntity] = appDelegate.getPlayers()
        players = result.map({$0.toPlayer()})
        players.sort() { $0.score > $1.score }
        return players
    }
    
    static func getHighestScore() -> Int {
        let players = retrivePlayers()
        return Int(players[0].score)
    }

}
