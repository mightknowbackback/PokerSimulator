//
//  GameModel.swift
//  PokerSimulator
//
//  Created by mightknow on 10/27/20.
//

import Foundation

enum Round : String {
    case preFlop = "Pre-Flop"
    case flop
    case turn
    case river
}

struct GameModel {
    
    mutating func deal() {
        func distribute(_ i: Int, toPlayer: Bool) {
            for _ in 1...i {
                if toPlayer {
                    for p in self.players {
                        p.hand.allCards.append(self.deck.cards.removeFirst())
                    }
                } else {
                    let card = self.deck.cards.removeFirst()
                    self.board.append(card)
                    for p in self.players {
                        p.hand.allCards.append(card)
                    }
                }
            }
        }
        self.advanceButton()
        self.discardPile.append(self.deck.cards.removeFirst())
        switch self.round {
        case .preFlop:
            distribute(2, toPlayer: true)
        case .flop:
            distribute(3, toPlayer: false)
        case .turn:
            distribute(1, toPlayer: false)
        case .river:
            distribute(1, toPlayer: false)
        }
    }
    mutating func advanceButton() {
        let newDealer = self.players.removeFirst()
        self.players.append(newDealer)
    }
    
    var discardPile : [Card] = []
    var board : [Card] = []
    var deck : Deck
    var round : Round = .preFlop
    var players : [Player]
    
    init(shuffleMethods: ShuffleMethod..., players: Int) {
        let deck = Deck(shuffleMethods: shuffleMethods)
        var computerPlayers : [Player] = []
        for _ in 0..<players {
            let player = Player(isComputerPlayer: true)
            computerPlayers.append(player)
        }
        self.deck = deck
        self.players = computerPlayers
    }
}
