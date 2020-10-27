//
//  Deck.swift
//  PokerSimulator
//
//  Created by mightknow on 10/27/20.
//

import Foundation

struct Deck {
    
    var cards : [Card]
    init(shuffleMethods: [ShuffleMethod]) {
        var cards : [Card] = []
        for suit in Suit.allCases {
            for rank in Rank.allCases {
                let card = Card(suit: suit, rank: rank)
                cards.append(card)
            }
        }
        for method in shuffleMethods {
            cards = method.shuffle(cards)
        }
        self.cards = cards
    }
}
