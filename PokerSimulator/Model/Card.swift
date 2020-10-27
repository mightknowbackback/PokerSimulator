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
enum Rank : String, CaseIterable {
    
    case ace = "Ace", two = "Two", three = "Three", four = "Four", five = "Five", six = "Six", seven = "Seven", eight = "Eight", nine = "Nine", ten = "Ten", jack = "Jack", queen = "Queen", king = "King"
    
}

struct Card {
    let suit : Suit
    let rank : Rank
}
