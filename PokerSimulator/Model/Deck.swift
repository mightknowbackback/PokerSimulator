//
//  Deck.swift
//  PokerSimulator
//
//  Created by mightknow on 10/27/20.
//

import Foundation

struct Deck {
    var debugDescription : String {
        self.cards.debugDescription
    }
    static func newDeck() -> [Card] {
        var cards : [Card] = []
        for suit in Suit.allCases {
            for rank in Rank.allCases {
                let card = Card(suit: suit, rank: rank)
                cards.append(card)
            }
        }
        return cards
    }
    var cards : [Card]
    init(shuffleMethods: [ShuffleMethod], unshuffledCards: [Card] = Self.newDeck()) {
        var cards = unshuffledCards
        for method in shuffleMethods {
            cards = method.shuffle(cards)
        }
        self.cards = cards
    }
}

extension Array where Element == Card {
    var debugDescription : String {
        var result : String = "\nCARD COUNT: \(self.count)\n"
        for c in self {
            result.append(c.abbreviation + "\n")
        }
        return result
    }
}
