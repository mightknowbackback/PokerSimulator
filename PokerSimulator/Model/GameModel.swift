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
    
    private mutating func distribute(_ i: Int, toPlayer: Bool) {
        for _ in 1...i {
            if toPlayer {
                for p in self.players {
                    let card = self.deck.cards.removeFirst()
                    p.cards.append(card)
                }
            } else {
                let card = self.deck.cards.removeFirst()
                self.board.append(card)
                for p in self.players {
                    p.cards.append(card)
                }
            }
        }
    }
    mutating func advanceRound() {
        
        switch self.round {
        case .preFlop:
            self.round = .flop
        case .flop:
            self.round = .turn
        case .turn:
            self.round = .river
        case .river:
            self.round = .preFlop
        }
        
    }
    mutating func deal() {
        if self.round == .river {
            self.resetDeck()
            self.advanceButton()
        }
        self.advanceRound()
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
    
    mutating private func resetDeck() {
        var cards : [Card] = []
        for p in players {
            cards.append(p.cards.removeFirst())
            cards.append(p.cards.removeFirst())
            p.cards = []
        }
        cards += self.discardPile
        self.discardPile = []
        cards += self.board
        self.board = []
        cards += self.deck.cards
        self.deck = Deck(shuffleMethods: self.shuffleMethods, unshuffledCards: cards)
    }
    
    mutating func advanceButton() {
        let newDealer = self.players.removeFirst()
        self.players.append(newDealer)
    }
    
    func currentBest() -> [Player] {
        var result : [Player] = []
        for p in self.players {
            if result.isEmpty {
                result = [p]
            } else {
                if p.hand > result[0].hand {
                    result = [p]
                } else if p.hand == result[0].hand {
                    result.append(p)
                }
            }
        }
        return result
    }
    
    let shuffleMethods : [ShuffleMethod]
    var discardPile : [Card] = []
    var board : [Card] = []
    var deck : Deck
    var round : Round = .preFlop
    var players : [Player]
    
    init(shuffleMethods: ShuffleMethod..., players: Int) {
        let deck = Deck(shuffleMethods: shuffleMethods)
        var computerPlayers : [Player] = []
        for i in 0..<players {
            let player = Player(isComputerPlayer: true, playerNumber: i + 1)
            computerPlayers.append(player)
        }
        self.shuffleMethods = shuffleMethods
        self.deck = deck
        self.players = computerPlayers
        self.distribute(2, toPlayer: true)
    }
}
