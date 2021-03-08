//
//  Player.swift
//  PokerSimulator
//
//  Created by mightknow on 10/27/20.
//

import Foundation

class Player : Equatable {
    
    // MARK: Equatable Protocol
    static func == (lhs: Player, rhs: Player) -> Bool {
        return lhs === rhs
    }
    
    // MARK: Instance Properties
    // Unique ID
    let id = UUID()
    // Distinguish bots from real player(s)
    let isComputerPlayer : Bool
    // Position at table
    var playerNumber : Int
    // Player cards for hand (including communal board cards)
    var cards : [Card] = []
    // Player chips
    var chips : Int
    // Amount player has contributed to current betting round
    var stake : Int = 0
    // Player has chips
    var hasChips : Bool {self.chips > 0}
    // Is active in betting round (hasn't folded)
    var isActive : Bool = true
    // Player hand
    var hand : Hand {
        return Hand(self.cards)
    }
    
    // MARK: Player Action
    var action : Action?
    var actionAmount : Int = 0
    // Main function for computer player check/fold/call/raise
    func decide(for gameModel: GameModel) -> (action: Action, amount: Int?) {
        // Initialize variable for result
        var result : (action: Action, amount: Int?) = (action: .check, amount: nil)
        // Check if player cannot check:
        let amount = gameModel.currentBet
        if amount != self.stake {
            result = (action: .call, amount: amount - self.stake)
        }
        return result
    }
    // Reset player for next hand
    func reset() {
        self.action = nil
        self.actionAmount = 0
        self.isActive = true
    }
    
    // MARK: Initializer
    init(isComputerPlayer: Bool, playerNumber: Int, chips: Int) {
        self.isComputerPlayer = isComputerPlayer
        self.playerNumber = playerNumber
        self.chips = chips
    }
}
