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
            for val in 2...14 {
                for c in cards {
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
        // MARK: Pair checking
        func sortForRankMatches() -> [[Card]] {
            var result : [[Card]] = []
            let rankCounts : [Int] = {
                var result : [Int] = [0, 0]
                var i = 2
                while i <= Rank.ace.rawValue {
                    result.append(0)
                    for c in cards {
                        if c.rank.rawValue == i {
                            let j = result.count - 1
                            result[j] = result[j] + 1
                        }
                    }
                    i += 1
                }
                return result
            }()
            var matchedRankValues : [Int] = []
            for e in rankCounts.enumerated() {
                if e.element > 1 {
                    matchedRankValues.append(e.offset)
                }
            }
            matchedRankValues = matchedRankValues.reversed()
            for val in matchedRankValues {
                var arr : [Card] = []
                for c in cards {
                    if c.rank.rawValue == val {
                        arr.append(c)
                    }
                }
                if !arr.isEmpty {
                    result.append(arr)
                }
            }
            return result
        }
        let matchedCards = sortForRankMatches()
        
        
        // MARK: Case by case testing
        // Cases assume all higher HandRankings tests failed 
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
                }
            }
        case .fourOfAKind:
            for set in matchedCards {
                if set.count == 4 {
                    result.bool = true
                    result.values.append(set[0].rank.rawValue)
                    let otherCards : [Card] = {
                        var result : [Card] = []
                        let val = set.first!.rank.rawValue
                        for c in cards {
                            if c.rank.rawValue != val {
                                result.append(c)
                            }
                        }
                        return result
                    }()
                    if !otherCards.isEmpty {
                        var othersSorted = sort(otherCards)
                        let first = othersSorted.removeFirst()
                        result.values.append(first.rank.rawValue)
                        result.unused = othersSorted
                    }
                }
            }
        case .fullHouse:
            if matchedCards.count >= 2 {
                for set in matchedCards {
                    if set.count == 3 {
                        result.bool = true
                        result.values.append(set[0].rank.rawValue)
                        break
                    }
                }
                if result.bool {
                    result.values.append(matchedCards.first(where: {$0[0].rank.rawValue != result.values[0]})![0].rank.rawValue)
                    var allMatched : [Card] = {// All cards that have a rank match (can be two sets of 3...)
                        var arr = [Card]()
                        for set in matchedCards {
                            for c in set {
                                arr.append(c)
                            }
                        }
                        return arr
                    }()
                    if allMatched.count > 5 {// For two sets of three or three sets
                        if matchedCards.count > 2 {// For three sets
                            for i in 0..<allMatched.count {
                                if !result.values.contains(allMatched[i].rank.rawValue) {
                                    result.unused.append(allMatched.remove(at: i))
                                }
                            }
                        } else {// For two sets of three
                            for c in cards {
                                if !allMatched.contains(c) {
                                    result.unused.append(c)
                                }
                                result.unused.append(allMatched.popLast()!)
                            }
                        }
                    }
                }
            }
        case .flush:
            if let fCards = sortedFlushCards {
                result.bool = true
                var sortedCards = fCards
                while sortedCards.count > 5 {
                    result.unused.append(sortedCards.removeLast())
                }
                result.values = [fCards[0].rank.rawValue]
            }
        case .straight:
            if let val = checkForStraight(cards) {
                result.bool = true
                result.values = [val]
                var straight : [Card] = []
                while cards.count < 5 {
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
            }
        case .threeOfAKind:
            for set in matchedCards {
                if set.count == 3 {
                    result.bool = true
                    result.values = [set[0].rank.rawValue]
                    var otherCards = [Card]()
                    for c in cards {
                        if c.rank.rawValue != set[0].rank.rawValue {
                            otherCards.append(c)
                        }
                    }
                    var othersSorted = sort(otherCards)
                    while othersSorted.count > 2 {
                        result.unused.append(othersSorted.popLast()!)
                    }
                    for c in othersSorted {
                        result.values.append(c.rank.rawValue)
                    }
                }
            }
        case .twoPair:
            if matchedCards.count > 1 {
                result.bool = true
                for set in matchedCards {
                    result.values.append(set[0].rank.rawValue)
                }
                if result.values.count == 3 {
                    result.values.removeLast()
                }
                for c in sort(cards) {
                    let val = c.rank.rawValue
                    if !result.values.contains(val) && result.values.count < 3 {
                        result.values.append(val)
                    }
                }
            }
        case .onePair:
            if !matchedCards.isEmpty {
                result.bool = true
                result.values.append(matchedCards[0][0].rank.rawValue)
                var sorted = sort(cards)
                sorted.removeAll(where: {$0.rank.rawValue == result.values[0]})
                while sorted.count > 3 {
                    result.unused.append(sorted.removeLast())
                }
                for c in sorted {
                    result.values.append(c.rank.rawValue)
                }
            }
            
        case .highCard:
            if cards.count > 0 {
                result.bool = true
                var sorted = sort(cards)
                var values : [Int] = []
                for i in 0...4 {
                    values.append(sorted[i].rank.rawValue)
                }
                result.values = values
                while sorted.count > 5 {
                    result.unused.append(sorted.removeLast())
                }
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
                    return rankingValueTest(1)
                } else {
                    return rankingValueTest(0)
                }
            case .fullHouse:
                if lhs.rankingValues == rhs.rankingValues {
                    return false
                } else if rankingValueEquality(0) {
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
