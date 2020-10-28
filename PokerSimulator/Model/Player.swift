//
//  Player.swift
//  PokerSimulator
//
//  Created by mightknow on 10/27/20.
//

import Foundation

class Player {
    
    let isComputerPlayer : Bool
    var cards : [Card] = []
    var hand : Hand = Hand([])
    
    func decide(forTurn model: GameModel) -> (Action, Int?) {
        return (.call, nil)
    }
    init(isComputerPlayer: Bool) {
        self.isComputerPlayer = isComputerPlayer
    }
}
