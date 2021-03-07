//
//  GameModel.swift
//  PokerSimulator
//
//  Created by mightknow on 10/27/20.
//

import Foundation

enum Round : String {
    case preFlop = "Pre-Flop"
    case flop = "Flop"
    case turn = "Turn"
    case river = "River"
}

struct GameModel {
    
    private mutating func distribute(numberOfCards i: Int, asHoleCards: Bool) {
        for _ in 1...i {
            if asHoleCards {
                for p in self.players {
                    if p.hasChips {
                        let card = self.deck.cards.removeFirst()
                        p.cards.append(card)
                    }
                }
            } else {
                let card = self.deck.cards.removeFirst()
                self.board.append(card)
                for p in self.players {
                    if p.hasChips {
                        p.cards.append(card)
                    }
                }
            }
        }
    }
    
    private mutating func advanceRound() {
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
            distribute(numberOfCards: 2, asHoleCards: true)
        case .flop:
            distribute(numberOfCards: 3, asHoleCards: false)
        case .turn:
            distribute(numberOfCards: 1, asHoleCards: false)
        case .river:
            distribute(numberOfCards: 1, asHoleCards: false)
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
    
    init(shuffleMethods: ShuffleMethod..., players: Int, startingChips: Int) {
        let deck = Deck(shuffleMethods: shuffleMethods)
        var computerPlayers : [Player] = []
        for i in 0..<players {
            let player = Player(isComputerPlayer: true, playerNumber: i + 1, chips: startingChips)
            computerPlayers.append(player)
        }
        self.shuffleMethods = shuffleMethods
        self.deck = deck
        self.players = computerPlayers
        self.distribute(numberOfCards: 2, asHoleCards: true)
    }
}
