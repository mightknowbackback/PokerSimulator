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
    
    // MARK: Main Game Loop
    mutating func continuePlay() {
        // reset for next round
        func resetForNextBettingRound() {
            self.advanceButton()
            self.currentBet = 0
            self.didDealCards = false
            self.bettingIsOver = false
            self.handIsOver = false
            nextRound()
        }
        // advance round variable
        func nextRound() {
            if self.handIsOver {// skip remaining rounds and reset
                self.round = .preFlop
            } else { // continue to next round
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
        }
        // deal round (burn card and distribute)
        func deal() {
            // burn card
            self.discardPile.append(self.deck.cards.removeFirst())
            // deal appropriate number of cards for round
            switch self.round {
            case .preFlop:
                self.distribute(numberOfCards: 2, asHoleCards: true)
            case .flop:
                self.distribute(numberOfCards: 3, asHoleCards: false)
            case .turn:
                self.distribute(numberOfCards: 1, asHoleCards: false)
            case .river:
                self.distribute(numberOfCards: 1, asHoleCards: false)
            }
        }
        // betting round
        func runBettingLoop() {
            while self.activePlayer < self.players.count {
                let p : Player = self.players[self.activePlayer]
                if p.isComputerPlayer && p.isActive {
                    let decision = p.decide(for: self)
                    p.action = decision.action
                    switch decision.action {
                    case .check:
                        // no action
                        break
                    case .fold:
                        // make player inactive and discard cards
                        p.isActive = false
                        self.discardPile += p.cards
                        p.cards = []
                    case .call:
                        // get amount to call
                        let callingAmount : Int = decision.amount!
                        // remove calling chips from player and add them to pot. adjust player stake.
                        p.chips -= callingAmount
                        p.actionAmount = callingAmount
                        self.pot += callingAmount
                        p.stake += callingAmount
                    case .raise:
                        // get bet amount
                        let bet : Int = decision.amount!
                        // remove betting chips from player and add them to pot. adjust player stake.
                        p.chips -= bet
                        self.pot += bet
                        p.stake += bet
                    }
                    self.activePlayer += 1
                } else {
                    if !p.isComputerPlayer {
                        break
                    }
                }
            }
            // check if betting is done and update if so
            var bettingIsContinuing = false
            for p in self.players {
                
                if p.isActive && p.stake != self.currentBet {
                    bettingIsContinuing = true
                }
            }
            if !bettingIsContinuing {
                self.bettingIsOver = true
            }
        }
        // Deal cards if hasn't been done
        if !self.didDealCards {
            deal()
        }
        // Betting Round
        runBettingLoop()
        // See if had is over or continues to next round
        if handIsOver { // If hand is over
            // distribute pot
            self.distributePot(toWinners: self.getWinners())
            // reset deck
            // advance button
            // reset all player statuses
            // deal new hand
            resetForNextBettingRound()
            self.resetDeck()
        } else { // If hand is not over
            if self.bettingIsOver { // betting is over for round
                resetForNextBettingRound()
            }
            
            
        }
    }
    
    // deal cards to each available player, or to board
    private mutating func distribute(numberOfCards i: Int, asHoleCards: Bool) {
        // for each card
        for _ in 1...i {
            if asHoleCards { // for preflop deals
                // for each player
                for p in self.players {
                    // deal cards if they have chips
                    if p.hasChips {
                        // remove top card from deck and add to player cards
                        let card = self.deck.cards.removeFirst()
                        p.cards.append(card)
                    }
                }
            } else { // all post-flop deals
                // remove top card and add to board
                let card = self.deck.cards.removeFirst()
                self.board.append(card)
                for p in self.players {
                    // if player is still involved in hand, add board cards to player hand
                    if p.isActive {
                        p.cards.append(card)
                    }
                }
            }
        }
    }
    
    // Moves round property to next. Does NOT trigger new deal. Called by deal() method.
//    private mutating func updateRound() {
//        if self.handIsOver {// skip remaining rounds and reset
//            self.round = .preFlop
//        } else {
//            switch self.round {
//            case .preFlop:
//                self.round = .flop
//            case .flop:
//                self.round = .turn
//            case .turn:
//                self.round = .river
//            case .river:
//                self.round = .preFlop
//            }
//        }
//    }
//    private mutating func dealNextRound() {
//        
//    }
    
    // Main method for advancing to next round. Deals cards, moves button, updates round property. If hand is over, distributes pot and resets rake.
//    mutating func advance() {
//
//        if self.handIsOver { // if hand is over
//            self.distributePot(toWinners: self.getWinners())
//            self.resetDeck()
//            self.advanceButton()
//            self.handIsOver = false
//            self.advance()
//        } else {
//            self.updateRound()
//
//
//        }
//    }
    
    
    // Distribute chips to winning player(s) and reset rake.
    mutating private func distributePot(toWinners winners: [Player]) {
        // get number of winners (can be more than one for split pot)
        let num = winners.count
        if num > 1 {
            var remainder = self.pot%num
            let amt = self.pot/num
            for w in winners {
                w.chips += amt
                while remainder > 0 {
                    w.chips += 1
                    remainder -= 1
                }
            }
        } else {
            winners[0].chips += self.pot
        }
        self.rake = 0
        self.pot = 0
    }
    
    mutating private func resetDeck() {
        var cards : [Card] = []
        for p in players {
            if p.cards.count > 0 {
                cards.append(p.cards.removeFirst())
                cards.append(p.cards.removeFirst())
                p.cards = []
            }
            
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
    
    func getWinners() -> [Player] {
        var result : [Player] = []
        for p in self.players {
            if p.isActive {
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
        }
        return result
    }
    
    // MARK: Instance Variables
    // Shuffle method(s) used for game
    private let shuffleMethods : [ShuffleMethod]
    // Discard pile (burn cards and folded player hole cards)
    private var discardPile : [Card] = []
    // Board cards
    private var didDealCards : Bool = true
    var board : [Card] = []
    // Deck of undealt cards
    private var deck : Deck
    // Betting round
    var round : Round = .preFlop
    // Players
    var players : [Player]
    // Active player
    var activePlayer : Int = 0
    // Current bet amount for round
    var currentBet : Int = 0
    // User player
    var hero : Player
    // Pot value
    var pot : Int = 0
    // Rake taken by house
    var rake : Int = 0
    // there is a winner(s)
    var handIsOver : Bool = false
    var bettingIsOver : Bool = false
    
    
    init(shuffleMethods: ShuffleMethod..., numberOfPlayers: Int, startingChips: Int) {
        let deck = Deck(shuffleMethods: shuffleMethods)
        let player = Player(isComputerPlayer: false, playerNumber: 1, chips: startingChips)
        var players : [Player] = [player]
        for i in 1...numberOfPlayers {
            let player = Player(isComputerPlayer: true, playerNumber: i + 1, chips: startingChips)
            players.append(player)
        }
        self.shuffleMethods = shuffleMethods
        self.deck = deck
        self.players = players
        self.hero = player
        self.distribute(numberOfCards: 2, asHoleCards: true)
    }
}
