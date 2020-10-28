//
//  Hand.swift
//  PokerSimulator
//
//  Created by mightknow on 10/27/20.
//

import Foundation

enum HandRanking : Int, CaseIterable {
    
    case straightFlush = 9
    case fourOfAKind = 8
    case fullHouse = 7
    case flush = 6
    case straight = 5
    case threeOfAKind = 4
    case twoPair = 3
    case onePair = 2
    case highCard = 1
    case none = 0
    
    // MARK: HandRanking test
    private func test(_ cards: [Card]) -> (bool: Bool, values: [Int], unused: [Card]) {
        // Placeholder for final
        var result : (bool: Bool, values: [Int], unused: [Card]) = (false, [], [])
        
        // MARK: Straight checking
        // Sort by descending value
        func sort(_ cards: [Card]) -> [Card] {
            var result : [Card] = []
            for c in cards {
                for val in 2...14 {
                    if c.rank.rawValue == val {
                        result.insert(c, at: 0)
                    }
                }
            }
            return result
        }
        // Check for straight and provide high card
        func checkForStraight(_ cards: [Card]) -> Int? {
            let sorted = sort(cards)
            var values : [Int] = []
            for c in sorted {
                values.append(c.rank.rawValue)
            }
            if sorted[0].rank == .ace {
                values.append(1)
            }
            var uniqueValues : [Int] = []
            for v in values {
                if !uniqueValues.contains(v) {
                    uniqueValues.append(v)
                }
            }
            var valOfTop : Int? = nil
            if uniqueValues.count >= 5 {
                var lastIndex = 4
                var firstIndex = 0
                while lastIndex < uniqueValues.count {
                    let top = uniqueValues[firstIndex]
                    let spread =  top - uniqueValues[lastIndex]
                    if spread == 4 {
                        valOfTop = top
                        break
                    }
                    lastIndex += 1
                    firstIndex += 1
                }
            }
            return valOfTop
        }
        // MARK: Flush checking
        // Check for flush and provide suit
        func checkForFlush() -> Suit? {
            var counts : [Int] = [
                0, // spades
                0, // clubs
                0, // diamonds
                0 // hearts
            ]
            for card in cards {
                switch card.suit {
                case .spades:
                    counts[0] += 1
                case .clubs:
                    counts[1] += 1
                case .diamonds:
                    counts[2] += 1
                case .hearts:
                    counts[3] += 1
                }
            }
            for c in counts.enumerated() {
                if c.element >= 5 {
                    switch c.offset {
                    case 0:
                        return .spades
                    case 1:
                        return .clubs
                    case 2:
                        return .diamonds
                    default:
                        return .hearts
                    }
                }
            }
            return nil
        }
        let flushSuit = checkForFlush()
        let sortedFlushCards : [Card]? = {
            if let suit = flushSuit {
                var suitedCards : [Card] = []
                for c in cards {
                    if c.suit == suit {
                        suitedCards.append(c)
                    }
                }
                let sortedCards : [Card] = sort(suitedCards)
                for c in cards {
                    if c.suit != suit {
                        result.unused.append(c)
                    }
                }
                return sortedCards
            } else {
                return nil
            }
        }()
        
        // MARK: Case by case testing
        switch self {
        case .straightFlush:
            if let fCards = sortedFlushCards {
                if let val = checkForStraight(fCards) {
                    result.bool = true
                    result.values = [val]
                    var full = fCards
                    while full.count > 5 {
                        if full.first!.rank.rawValue != val {
                            result.unused.append(full.removeFirst())
                        }
                        if full.last?.rank.rawValue != val - 4 {
                            result.unused.append(full.popLast()!)
                        }
                    }
                } else {
                    break
                }
            } else {
                break
            }
        case .fourOfAKind:
            print("Complete Four-of-a-Kind!")
        case .fullHouse:
            print("Complete Full House!")
        case .flush:
            if let fCards = sortedFlushCards {
                result.bool = true
                var sortedCards = fCards
                while sortedCards.count > 5 {
                    result.unused.append(sortedCards.removeLast())
                }
                result.values = [fCards[0].rank.rawValue]
            } else {
                break
            }
        case .straight:
            if let val = checkForStraight(cards) {
                result.bool = true
                result.values = [val]
                var straight : [Card] = []
                while cards.count > 5 {
                    let values = [val, val - 1, val - 2, val - 3, val - 4]
                    for v in values {
                        straight.append(cards.first(where: {$0.rank.rawValue == v})!)
                    }
                    for c in cards {
                        if !straight.contains(c) {
                            result.unused.append(c)
                        }
                    }
                }
            } else {
                break
            }
        case .threeOfAKind:
            print("Complete Three-of-a-Kind!")
        case .twoPair:
            print("Complete Two Pair!")
        case .onePair:
            print("Complete One Pair!")
        case .highCard:
            if cards.count > 0 {
                result.bool = true
                let sorted = sort(cards)
                var values : [Int] = []
                for i in 0...4 {
                    values.append(sorted[i].rank.rawValue)
                }
                result.values = values
            }
        default:
            break
        }
        return result
    }
    
    static func get(forCards cards: [Card]) -> (ranking: HandRanking, values: [Int], unused: [Card]) {
        var result : (HandRanking, [Int], [Card]) = (.none, [], [])
        for r in HandRanking.allCases {
            let test = r.test(cards)
            if test.bool {
                result.0 = r
                result.1 = test.values
                result.2 = test.unused
                break
            }
        }
        return result
    }
    
}
struct Hand : Equatable, Comparable {
    
    static func == (lhs: Hand, rhs: Hand) -> Bool {
        if lhs.ranking != rhs.ranking {
            return false
        } else {
            return lhs.rankingValues == rhs.rankingValues
        }
    }
    static func < (lhs: Hand, rhs: Hand) -> Bool {
        func rankingValueEquality(_ i: Int) -> Bool {
            lhs.rankingValues[i] == rhs.rankingValues[i]
        }
        func rankingValueTest(_ i: Int) -> Bool {
            lhs.rankingValues[i] < rhs.rankingValues[i]
        }
        
        if lhs.ranking != rhs.ranking { // Different HandRanking
            return lhs.ranking.rawValue < rhs.ranking.rawValue
        } else if lhs == rhs { // Same exact hand value
            return false
        } else { // Same HandRanking needs to be sorted by kickers.
            switch lhs.ranking {
            case .straightFlush, .flush:
                return rankingValueTest(0)
            case .fourOfAKind:
                if lhs.rankingValues == rhs.rankingValues {
                    return false
                } else if rankingValueEquality(0) {
                    return rankingValueTest(4)
                } else {
                    return rankingValueTest(0)
                }
            case .fullHouse:
                if lhs.rankingValues == rhs.rankingValues {
                    return false
                } else if lhs.rankingValues[0] == rhs.rankingValues[0] {
                    return rankingValueTest(1)
                } else {
                    return rankingValueTest(0)
                }
            case .straight:
                return rankingValueTest(0)
            case .highCard, .onePair, .twoPair, .threeOfAKind:
                for i in 0..<lhs.rankingValues.count {
                    if !rankingValueEquality(i) {
                        return rankingValueTest(i)
                    }
                }
                return false
            case .none:
                return false
            }
        }
    }
    
    var allCards : [Card]
    var usedCards : [Card]
    var unUsedCards : [Card]
    var ranking : HandRanking
    var rankingValues : [Int]
    
    init(_ cards: [Card]) {
        self.allCards = cards
        let rankingAndValues = HandRanking.get(forCards: cards)
        self.ranking = rankingAndValues.ranking
        self.rankingValues = rankingAndValues.values
        let unUsed = rankingAndValues.unused
        self.unUsedCards = unUsed
        var used = cards
        for card in unUsed {
            used.removeAll(where: {$0 == card})
        }
        self.usedCards = used
    }
}
