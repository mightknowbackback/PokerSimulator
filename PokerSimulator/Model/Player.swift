//
//  Player.swift
//  PokerSimulator
//
//  Created by mightknow on 10/27/20.
//

import Foundation

struct Player {
    
    var isDealer : Bool = false
    
    let isComputerPlayer : Bool
    var cards : [Card] = []
    var hand : Hand
    
    func decide(forTurn model: GameModel) -> (Action, Int?) {
        return (.call, nil)
    }
}
