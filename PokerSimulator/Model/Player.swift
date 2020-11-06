//
//  Player.swift
//  PokerSimulator
//
//  Created by mightknow on 10/27/20.
//

import Foundation

class Player : Equatable {
    
    static func == (lhs: Player, rhs: Player) -> Bool {
        return lhs === rhs
    }
    
    let id = UUID()
    let isComputerPlayer : Bool
    var playerNumber : Int
    var cards : [Card] = []
    var chips : Int
    var hasChips : Bool {self.chips > 0}
    var hand : Hand {
        return Hand(self.cards)
    }
    
    func decide(forTurn model: GameModel) -> (Action, Int?) {
        return (.call, nil)
    }
    init(isComputerPlayer: Bool, playerNumber: Int, chips: Int) {
        self.isComputerPlayer = isComputerPlayer
        self.playerNumber = playerNumber
        self.chips = chips
    }
}
