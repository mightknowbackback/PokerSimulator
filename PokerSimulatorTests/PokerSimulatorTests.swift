//
//  PokerSimulatorTests.swift
//  PokerSimulatorTests
//
//  Created by mightknow on 10/27/20.
//

import XCTest
@testable import PokerSimulator

class PokerSimulatorTests: XCTestCase {
    
    func deckHasCorrectComposition(_ deck: Deck) -> Bool {
        let testDeck = Deck.newDeck()
        for c in testDeck {
            if !deck.cards.contains(c) {
                return false
            }
        }
        return true
    }
    func testShuffle() {
        for _ in 0...10 {
            let scrambledDeck = Deck(shuffleMethods: [.scramble])
            XCTAssertEqual(scrambledDeck.cards.count, 52)
            XCTAssertTrue(deckHasCorrectComposition(scrambledDeck))
            let riffledDeck = Deck(shuffleMethods: [.riffle])
            XCTAssertEqual(riffledDeck.cards.count, 52)
            XCTAssertTrue(deckHasCorrectComposition(riffledDeck))
            let machineDeck = Deck(shuffleMethods: [.machine])
            XCTAssertEqual(machineDeck.cards.count, 52)
            XCTAssertTrue(deckHasCorrectComposition(machineDeck))
            let randomDeck = Deck(shuffleMethods: [.random])
            XCTAssertEqual(randomDeck.cards.count, 52)
            XCTAssertTrue(deckHasCorrectComposition(randomDeck))
        }
    }
    
    func testHandRanking() {
        
        // MARK: Detecting Hands
        // MARK: Straight Flush
        let straightFlushA = Hand([
            Card(suit: .hearts, rank: .seven),
            Card(suit: .hearts, rank: .eight),
            Card(suit: .hearts, rank: .four),
            Card(suit: .hearts, rank: .five),
            Card(suit: .hearts, rank: .six),
            Card(suit: .clubs, rank: .two),
            Card(suit: .diamonds, rank: .king),
        ])
        XCTAssertEqual(straightFlushA.ranking, .straightFlush)
        XCTAssertEqual(straightFlushA.rankingValues, [8])
        let straightFlushB = Hand([
            Card(suit: .hearts, rank: .three),
            Card(suit: .hearts, rank: .two),
            Card(suit: .hearts, rank: .four),
            Card(suit: .hearts, rank: .five),
            Card(suit: .hearts, rank: .six),
            Card(suit: .clubs, rank: .two),
            Card(suit: .diamonds, rank: .king),
        ])
        XCTAssertEqual(straightFlushB.ranking, .straightFlush)
        XCTAssertEqual(straightFlushB.rankingValues, [6])
        let straightFlushC = Hand([
            Card(suit: .hearts, rank: .three),
            Card(suit: .hearts, rank: .two),
            Card(suit: .hearts, rank: .four),
            Card(suit: .hearts, rank: .five),
            Card(suit: .hearts, rank: .ace),
            Card(suit: .clubs, rank: .two),
            Card(suit: .diamonds, rank: .king),
        ])
        XCTAssertEqual(straightFlushC.ranking, .straightFlush)
        XCTAssertEqual(straightFlushC.rankingValues, [5])
        XCTAssertTrue(straightFlushA > straightFlushB)
        XCTAssertTrue(straightFlushB > straightFlushC)
        
        // MARK: Four of a Kind
        let fourOfAKindA = Hand([
            Card(suit: .clubs, rank: .six),
            Card(suit: .diamonds, rank: .two),
            Card(suit: .spades, rank: .three),
            Card(suit: .hearts, rank: .jack),
            Card(suit: .diamonds, rank: .jack),
            Card(suit: .spades, rank: .jack),
            Card(suit: .clubs, rank: .jack),
        ])
        XCTAssertEqual(fourOfAKindA.ranking, .fourOfAKind)
        XCTAssertEqual(fourOfAKindA.rankingValues, [11, 6])
        let fourOfAKindB = Hand([
            Card(suit: .clubs, rank: .five),
            Card(suit: .diamonds, rank: .two),
            Card(suit: .spades, rank: .three),
            Card(suit: .hearts, rank: .jack),
            Card(suit: .diamonds, rank: .jack),
            Card(suit: .spades, rank: .jack),
            Card(suit: .clubs, rank: .jack),
        ])
        XCTAssertEqual(fourOfAKindB.ranking, .fourOfAKind)
        XCTAssertEqual(fourOfAKindB.rankingValues, [11, 5])
        let fourOfAKindC = Hand([
            Card(suit: .clubs, rank: .ace),
            Card(suit: .diamonds, rank: .three),
            Card(suit: .spades, rank: .three),
            Card(suit: .hearts, rank: .three),
            Card(suit: .diamonds, rank: .three),
            Card(suit: .spades, rank: .jack),
            Card(suit: .clubs, rank: .jack),
        ])
        XCTAssertEqual(fourOfAKindC.ranking, .fourOfAKind)
        XCTAssertEqual(fourOfAKindC.rankingValues, [3, 14])
        XCTAssertTrue(fourOfAKindA > fourOfAKindB)
        XCTAssertTrue(fourOfAKindB > fourOfAKindC)
        XCTAssertTrue(Hand.findKickerFor(lhs: fourOfAKindA, rhs: fourOfAKindB) == 6)
        XCTAssertTrue(Hand.findKickerFor(lhs: fourOfAKindB, rhs: fourOfAKindC) == nil)
        
        // MARK: Full House
        let fullHouseA = Hand([
            Card(suit: .clubs, rank: .six),
            Card(suit: .diamonds, rank: .two),
            Card(suit: .spades, rank: .three),
            Card(suit: .hearts, rank: .three),
            Card(suit: .diamonds, rank: .jack),
            Card(suit: .spades, rank: .jack),
            Card(suit: .clubs, rank: .jack),
        ])
        XCTAssertEqual(fullHouseA.ranking, .fullHouse)
        XCTAssertEqual(fullHouseA.rankingValues, [11, 3])
        let fullHouseB = Hand([
            Card(suit: .clubs, rank: .six),
            Card(suit: .diamonds, rank: .two),
            Card(suit: .spades, rank: .jack),
            Card(suit: .hearts, rank: .jack),
            Card(suit: .diamonds, rank: .three),
            Card(suit: .spades, rank: .three),
            Card(suit: .clubs, rank: .three),
        ])
        XCTAssertEqual(fullHouseB.ranking, .fullHouse)
        XCTAssertEqual(fullHouseB.rankingValues, [3, 11])
        let fullHouseC = Hand([
            Card(suit: .clubs, rank: .six),
            Card(suit: .diamonds, rank: .two),
            Card(suit: .spades, rank: .ten),
            Card(suit: .hearts, rank: .ten),
            Card(suit: .diamonds, rank: .three),
            Card(suit: .spades, rank: .three),
            Card(suit: .clubs, rank: .three),
        ])
        XCTAssertEqual(fullHouseC.ranking, .fullHouse)
        XCTAssertEqual(fullHouseC.rankingValues, [3, 10])
        XCTAssertTrue(fullHouseA > fullHouseB)
        XCTAssertTrue(fullHouseB > fullHouseC)
        
        // MARK: Flush
        let flushA = Hand([
            Card(suit: .hearts, rank: .ace),
            Card(suit: .hearts, rank: .eight),
            Card(suit: .hearts, rank: .four),
            Card(suit: .hearts, rank: .five),
            Card(suit: .hearts, rank: .jack),
            Card(suit: .clubs, rank: .two),
            Card(suit: .diamonds, rank: .king),
        ])
        XCTAssertEqual(flushA.ranking, .flush)
        XCTAssertEqual(flushA.rankingValues, [14, 11, 8, 5, 4])
        let flushB = Hand([
            Card(suit: .hearts, rank: .ace),
            Card(suit: .hearts, rank: .eight),
            Card(suit: .hearts, rank: .four),
            Card(suit: .hearts, rank: .five),
            Card(suit: .hearts, rank: .ten),
            Card(suit: .clubs, rank: .two),
            Card(suit: .diamonds, rank: .king),
        ])
        XCTAssertEqual(flushB.ranking, .flush)
        XCTAssertEqual(flushB.rankingValues, [14, 10, 8, 5, 4])
        let flushC = Hand([
            Card(suit: .hearts, rank: .ace),
            Card(suit: .hearts, rank: .eight),
            Card(suit: .hearts, rank: .four),
            Card(suit: .hearts, rank: .five),
            Card(suit: .hearts, rank: .nine),
            Card(suit: .clubs, rank: .two),
            Card(suit: .diamonds, rank: .king),
        ])
        XCTAssertEqual(flushC.ranking, .flush)
        XCTAssertEqual(flushC.rankingValues, [14, 9, 8, 5, 4])
        XCTAssertTrue(flushA > flushB)
        XCTAssertTrue(flushB > flushC)
        
        // MARK: Straight
        let straightA = Hand([
            Card(suit: .clubs, rank: .six),
            Card(suit: .diamonds, rank: .seven),
            Card(suit: .spades, rank: .three),
            Card(suit: .clubs, rank: .five),
            Card(suit: .diamonds, rank: .four),
            Card(suit: .spades, rank: .jack),
            Card(suit: .clubs, rank: .jack),
        ])
        XCTAssertEqual(straightA.ranking, .straight)
        XCTAssertEqual(straightA.rankingValues, [7])
        let straightB = Hand([
            Card(suit: .clubs, rank: .six),
            Card(suit: .diamonds, rank: .two),
            Card(suit: .spades, rank: .three),
            Card(suit: .clubs, rank: .five),
            Card(suit: .diamonds, rank: .four),
            Card(suit: .spades, rank: .jack),
            Card(suit: .clubs, rank: .jack),
        ])
        XCTAssertEqual(straightB.ranking, .straight)
        XCTAssertEqual(straightB.rankingValues, [6])
        let straightC = Hand([
            Card(suit: .clubs, rank: .ace),
            Card(suit: .diamonds, rank: .two),
            Card(suit: .spades, rank: .three),
            Card(suit: .clubs, rank: .five),
            Card(suit: .diamonds, rank: .four),
            Card(suit: .spades, rank: .jack),
            Card(suit: .clubs, rank: .jack),
        ])
        XCTAssertEqual(straightC.ranking, .straight)
        XCTAssertEqual(straightC.rankingValues, [5])
        XCTAssertTrue(straightA > straightB)
        XCTAssertTrue(straightB > straightC)
        
        // MARK: Three of a Kind
        let threeOfAKindA = Hand([
            Card(suit: .clubs, rank: .six),
            Card(suit: .diamonds, rank: .two),
            Card(suit: .spades, rank: .three),
            Card(suit: .clubs, rank: .five),
            Card(suit: .diamonds, rank: .jack),
            Card(suit: .spades, rank: .jack),
            Card(suit: .clubs, rank: .jack),
        ])
        XCTAssertEqual(threeOfAKindA.ranking, .threeOfAKind)
        XCTAssertEqual(threeOfAKindA.rankingValues, [11, 6, 5])
        let threeOfAKindB = Hand([
            Card(suit: .clubs, rank: .six),
            Card(suit: .diamonds, rank: .two),
            Card(suit: .spades, rank: .three),
            Card(suit: .clubs, rank: .five),
            Card(suit: .diamonds, rank: .six),
            Card(suit: .spades, rank: .six),
            Card(suit: .clubs, rank: .jack),
        ])
        XCTAssertEqual(threeOfAKindB.ranking, .threeOfAKind)
        XCTAssertEqual(threeOfAKindB.rankingValues, [6, 11, 5])
        let threeOfAKindC = Hand([
            Card(suit: .clubs, rank: .six),
            Card(suit: .diamonds, rank: .two),
            Card(suit: .spades, rank: .three),
            Card(suit: .clubs, rank: .five),
            Card(suit: .diamonds, rank: .six),
            Card(suit: .spades, rank: .six),
            Card(suit: .clubs, rank: .ten),
        ])
        XCTAssertEqual(threeOfAKindC.ranking, .threeOfAKind)
        XCTAssertEqual(threeOfAKindC.rankingValues, [6, 10, 5])
        XCTAssertTrue(threeOfAKindA > threeOfAKindB)
        XCTAssertTrue(threeOfAKindB > threeOfAKindC)
        
        // MARK: Two Pair
        let twoPairA = Hand([
            Card(suit: .clubs, rank: .six),
            Card(suit: .diamonds, rank: .two),
            Card(suit: .spades, rank: .three),
            Card(suit: .clubs, rank: .five),
            Card(suit: .diamonds, rank: .five),
            Card(suit: .spades, rank: .jack),
            Card(suit: .clubs, rank: .jack),
        ])
        XCTAssertEqual(twoPairA.ranking, .twoPair)
        XCTAssertEqual(twoPairA.rankingValues, [11, 5, 6])
        let twoPairB = Hand([
            Card(suit: .clubs, rank: .six),
            Card(suit: .diamonds, rank: .two),
            Card(suit: .spades, rank: .three),
            Card(suit: .clubs, rank: .four),
            Card(suit: .diamonds, rank: .four),
            Card(suit: .spades, rank: .jack),
            Card(suit: .clubs, rank: .jack),
        ])
        XCTAssertEqual(twoPairB.ranking, .twoPair)
        XCTAssertEqual(twoPairB.rankingValues, [11, 4, 6])
        let twoPairC = Hand([
            Card(suit: .clubs, rank: .six),
            Card(suit: .diamonds, rank: .two),
            Card(suit: .spades, rank: .three),
            Card(suit: .clubs, rank: .five),
            Card(suit: .diamonds, rank: .five),
            Card(suit: .spades, rank: .ten),
            Card(suit: .clubs, rank: .ten),
        ])
        XCTAssertEqual(twoPairC.ranking, .twoPair)
        XCTAssertEqual(twoPairC.rankingValues, [10, 5, 6])
        XCTAssertTrue(twoPairA > twoPairB)
        XCTAssertTrue(twoPairB > twoPairC)
        
        // MARK: One Pair
        let onePairA = Hand([
            Card(suit: .clubs, rank: .six),
            Card(suit: .diamonds, rank: .two),
            Card(suit: .spades, rank: .three),
            Card(suit: .clubs, rank: .ace),
            Card(suit: .diamonds, rank: .five),
            Card(suit: .spades, rank: .jack),
            Card(suit: .clubs, rank: .jack),
        ])
        XCTAssertEqual(onePairA.ranking, .onePair)
        XCTAssertEqual(onePairA.rankingValues, [11, 14, 6, 5])
        let onePairB = Hand([
            Card(suit: .clubs, rank: .six),
            Card(suit: .diamonds, rank: .two),
            Card(suit: .spades, rank: .three),
            Card(suit: .clubs, rank: .king),
            Card(suit: .diamonds, rank: .five),
            Card(suit: .spades, rank: .jack),
            Card(suit: .clubs, rank: .jack),
        ])
        XCTAssertEqual(onePairB.ranking, .onePair)
        XCTAssertEqual(onePairB.rankingValues, [11, 13, 6, 5])
        let onePairC = Hand([
            Card(suit: .clubs, rank: .six),
            Card(suit: .diamonds, rank: .two),
            Card(suit: .spades, rank: .three),
            Card(suit: .clubs, rank: .ace),
            Card(suit: .diamonds, rank: .five),
            Card(suit: .spades, rank: .ten),
            Card(suit: .clubs, rank: .ten),
        ])
        XCTAssertEqual(onePairC.ranking, .onePair)
        XCTAssertEqual(onePairC.rankingValues, [10, 14, 6, 5])
        XCTAssertTrue(onePairA > onePairB)
        XCTAssertTrue(onePairB > onePairC)
        
        // MARK: High Card
        let highCardA = Hand([
            Card(suit: .clubs, rank: .six),
            Card(suit: .diamonds, rank: .two),
            Card(suit: .spades, rank: .three),
            Card(suit: .clubs, rank: .ace),
            Card(suit: .diamonds, rank: .five),
            Card(suit: .spades, rank: .jack),
            Card(suit: .clubs, rank: .king),
        ])
        XCTAssertEqual(highCardA.ranking, .highCard)
        XCTAssertEqual(highCardA.rankingValues, [14, 13, 11, 6, 5])
        let highCardB = Hand([
            Card(suit: .clubs, rank: .six),
            Card(suit: .diamonds, rank: .two),
            Card(suit: .spades, rank: .three),
            Card(suit: .clubs, rank: .queen),
            Card(suit: .diamonds, rank: .five),
            Card(suit: .spades, rank: .jack),
            Card(suit: .clubs, rank: .king),
        ])
        XCTAssertEqual(highCardB.ranking, .highCard)
        XCTAssertEqual(highCardB.rankingValues, [13, 12, 11, 6, 5])
        let highCardC = Hand([
            Card(suit: .clubs, rank: .six),
            Card(suit: .diamonds, rank: .two),
            Card(suit: .spades, rank: .three),
            Card(suit: .clubs, rank: .ten),
            Card(suit: .diamonds, rank: .five),
            Card(suit: .spades, rank: .jack),
            Card(suit: .clubs, rank: .king),
        ])
        XCTAssertEqual(highCardC.ranking, .highCard)
        XCTAssertEqual(highCardC.rankingValues, [13, 11, 10, 6, 5])
        XCTAssertTrue(highCardA > highCardB)
        XCTAssertTrue(highCardB > highCardC)
        
        // MARK: Incomplete Hands
        let fourCardTrips = Hand([
            Card(suit: .hearts, rank: .ten),
            Card(suit: .diamonds, rank: .ten),
            Card(suit: .clubs, rank: .ten),
            Card(suit: .hearts, rank: .ace)
        ])
        XCTAssertEqual(fourCardTrips.ranking, .threeOfAKind)
        XCTAssertEqual(fourCardTrips.rankingValues, [10, 14])
        XCTAssertEqual(fourCardTrips.unUsedCards, [])
        
        // MARK: Ranking Hands
        XCTAssertTrue(straightFlushA > fourOfAKindA)
        XCTAssertTrue(fourOfAKindA > fullHouseA)
        XCTAssertTrue(fullHouseA > flushA)
        XCTAssertTrue(flushA > threeOfAKindA)
        XCTAssertTrue(threeOfAKindA > twoPairA)
        XCTAssertTrue(twoPairA > onePairA)
        XCTAssertTrue(onePairA > highCardA)
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
