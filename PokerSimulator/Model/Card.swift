//
//  Card.swift
//  PokerSimulator
//
//  Created by mightknow on 10/27/20.
//

import Foundation

enum Suit : String, CaseIterable {
    case spades = "Spades", clubs = "Clubs", diamonds = "Diamonds", hearts = "Hearts"
    var abbreviation : String {
        switch self {
        case .spades:
            return "s"
        case .clubs:
            return "c"
        case .diamonds:
            return "d"
        case .hearts:
            return "h"
        }
    }
}
enum Rank : Int, CaseIterable {
    
    case ace = 14, two = 2, three = 3, four = 4, five = 5, six = 6, seven = 7, eight = 8, nine = 9, ten = 10, jack = 11, queen = 12, king = 13
    var abbreviation : String {
        switch self {
        case .ace:
            return "A"
        case .king:
            return "K"
        case .queen:
            return "Q"
        case .jack:
            return "J"
        default:
            return "\(self.rawValue)"
        
        }
    }

}

struct Card : Equatable {
    let abbreviation : String
    let suit : Suit
    let rank : Rank
    init(suit: Suit, rank: Rank) {
        self.suit = suit
        self.rank = rank
        self.abbreviation = rank.abbreviation + suit.abbreviation
    }
}
