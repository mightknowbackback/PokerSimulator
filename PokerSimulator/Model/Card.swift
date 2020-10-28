//
//  Card.swift
//  PokerSimulator
//
//  Created by mightknow on 10/27/20.
//

import Foundation

enum Suit : String, CaseIterable {
    case spades = "Spades", clubs = "Clubs", diamonds = "Diamonds", hearts = "Hearts"
}
enum Rank : Int, CaseIterable {
    
    case ace = 14, two = 2, three = 3, four = 4, five = 5, six = 6, seven = 7, eight = 8, nine = 9, ten = 10, jack = 11, queen = 12, king = 13
    

}

struct Card : Equatable {
    let suit : Suit
    let rank : Rank
}
