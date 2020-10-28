//
//  ShuffleMethod.swift
//  PokerSimulator
//
//  Created by mightknow on 10/27/20.
//

import Foundation

enum ShuffleMethod {
    case scramble, riffle, machine, random
    func shuffle(_ cards : [Card]) -> [Card] {
        
        var cards = cards
        
        
        func randomIntBelow(_ i: Int) -> Int {
            Int(arc4random_uniform(UInt32(i)))
        }
        func remove(_ num: Int, fromTop cards: inout [Card]) -> [Card] {
            var top : [Card] = []
            for _ in 0..<num {
                top.append(cards.removeFirst())
            }
            return top
        }
        
        func remove(_ num: Int, fromBottom cards: inout [Card]) -> [Card] {
            if !cards.isEmpty {
                var bottom : [Card] = [cards.removeLast()]
                if num > 0 {
                    for _ in 0..<num - 1 {
                        bottom.insert(cards.removeLast(), at: 0)
                    }
                }
                return bottom
            } else {
                return []
            }
        }
        
        func cut() {
            
            var randomPoint : Int {
                let random = Int(arc4random_uniform(UInt32(cards.count - 6)))
                return random + 3
            }
//            print("Cutting deck at index \(randomPoint)")
            let top = remove(randomPoint, fromTop: &cards)
            cards = cards + top
        }
        
        cut()
        
        switch self {
        case .scramble:
            let randomCount = Int(arc4random_uniform(UInt32(60))) + 30
            for _ in 0...randomCount {
                let randomStart = Int(arc4random_uniform(UInt32(cards.count)))
                let top = remove(randomStart, fromTop: &cards)
                let randomMiddle = Int(arc4random_uniform(UInt32(cards.count)))
                let middle = remove(randomMiddle, fromTop: &cards)
                cards = middle + top + cards
            }
        case .riffle:
            let randomCount = Int(arc4random_uniform(UInt32(5))) + 3 // number of shuffles
//            print("Number of shuffles: \(randomCount)")
            for _ in 0...randomCount {
//                print("Shuffle \(i)")
                let middleIndex = cards.count/2
                let middleVariance = randomIntBelow(6)
                let positive = Bool.random()
                let splitIndex = positive ? middleIndex + middleVariance : middleIndex - middleVariance
//                print("Splitting deck at card \(splitIndex)")
//                print("CARDS: \(cards.debugDescription)")
                var left = remove(splitIndex, fromTop: &cards)
//                print("LEFT: " + left.debugDescription)
                var right = cards
//                print("RIGHT: " + right.debugDescription)
                var newOrder : [Card] = []
                newOrder = remove(randomIntBelow(5), fromBottom: &right)
//                print("NEW DECK: " + newOrder.debugDescription)
                while !left.isEmpty || !right.isEmpty {
                    
                    if !left.isEmpty {
                        let slice = left.count < 5 ? remove(randomIntBelow(left.count), fromBottom: &left) : remove(randomIntBelow(5), fromBottom: &left)
                        newOrder.insert(contentsOf: slice, at: 0)
                    }
                    
                    if !right.isEmpty {
                        let slice = right.count < 5 ? remove(randomIntBelow(right.count), fromBottom: &right) : remove(randomIntBelow(5), fromBottom: &right)
                        newOrder.insert(contentsOf: slice, at: 0)
                    }
//                    print("Left count: \(left.count)")
//                    print("Right count: \(right.count)")
//                    print("NEW DECK: \(newOrder.debugDescription)")
                }
//                print("Left while loop...")
                cards = newOrder
            }
        case .machine:
            cards = ShuffleMethod.random.shuffle(cards)
            cards = ShuffleMethod.riffle.shuffle(cards)
        case .random:
            for _ in 0...2 {
                var newDeck : [Card] = [cards.removeFirst()]
                while !cards.isEmpty {
                    let card = cards.removeFirst()
                    let randomIndex = randomIntBelow(newDeck.count + 1)
                    newDeck.insert(card, at: randomIndex)
                }
                cards = newDeck
            }
        }
        return cards
    }
}
