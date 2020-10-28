//
//  PokerSimulatorTests.swift
//  PokerSimulatorTests
//
//  Created by mightknow on 10/27/20.
//

import XCTest
@testable import PokerSimulator

class PokerSimulatorTests: XCTestCase {
    
    func testShuffle() {
        for _ in 0...10 {
            let scrambledDeck = Deck(shuffleMethods: [.scramble])
            XCTAssertEqual(scrambledDeck.cards.count, 52)
//            let riffledDeck = Deck(shuffleMethods: [.riffle])
//            XCTAssertEqual(riffledDeck.cards.count, 52)
//            let machineDeck = Deck(shuffleMethods: [.machine])
//            XCTAssertEqual(machineDeck.cards.count, 52)
            let randomDeck = Deck(shuffleMethods: [.random])
            XCTAssertEqual(randomDeck.cards.count, 52)
        }
    }
    
    func testHandRanking() {
        
        // MARK: Detecting Hands
//        let straightFlush = Hand([
//                Card(suit: .hearts, rank: .seven),
//                Card(suit: .hearts, rank: .eight),
//                Card(suit: .hearts, rank: .four),
//                Card(suit: .hearts, rank: .five),
//                Card(suit: .hearts, rank: .six),
//                Card(suit: .clubs, rank: .two),
//                Card(suit: .diamonds, rank: .king),
//        ])
//        XCTAssertEqual(straightFlush.ranking, .straightFlush)
        
        let fourOfAKind = Hand([
                Card(suit: .clubs, rank: .six),
                Card(suit: .diamonds, rank: .two),
                Card(suit: .spades, rank: .three),
                Card(suit: .hearts, rank: .jack),
                Card(suit: .diamonds, rank: .jack),
                Card(suit: .spades, rank: .jack),
                Card(suit: .clubs, rank: .jack),
        ])
        XCTAssertEqual(fourOfAKind.ranking, .fourOfAKind)
        //XCTAssertEqual(fourOfAKind.rankingValues, [11, 6])
        
        let fullHouse = Hand([
            Card(suit: .clubs, rank: .six),
            Card(suit: .diamonds, rank: .two),
            Card(suit: .spades, rank: .three),
            Card(suit: .hearts, rank: .three),
            Card(suit: .diamonds, rank: .jack),
            Card(suit: .spades, rank: .jack),
            Card(suit: .clubs, rank: .jack),
        ])
        XCTAssertEqual(fullHouse.ranking, .fullHouse)
        XCTAssertEqual(fullHouse.rankingValues, [11, 3])
        
        let flush = Hand([
                Card(suit: .hearts, rank: .ace),
                Card(suit: .hearts, rank: .eight),
                Card(suit: .hearts, rank: .four),
                Card(suit: .hearts, rank: .five),
                Card(suit: .hearts, rank: .jack),
                Card(suit: .clubs, rank: .two),
                Card(suit: .diamonds, rank: .king),
        ])
        XCTAssertEqual(flush.ranking, .flush)
        XCTAssertEqual(flush.rankingValues, [14])
        
//        let straight = Hand([
//                Card(suit: .clubs, rank: .six),
//                Card(suit: .diamonds, rank: .two),
//                Card(suit: .spades, rank: .three),
//                Card(suit: .clubs, rank: .five),
//                Card(suit: .diamonds, rank: .four),
//                Card(suit: .spades, rank: .jack),
//                Card(suit: .clubs, rank: .jack),
//        ])
//        XCTAssertEqual(straight.ranking, .straight)
        
        let threeOfAKind = Hand([
                Card(suit: .clubs, rank: .six),
                Card(suit: .diamonds, rank: .two),
                Card(suit: .spades, rank: .three),
                Card(suit: .clubs, rank: .five),
                Card(suit: .diamonds, rank: .jack),
                Card(suit: .spades, rank: .jack),
                Card(suit: .clubs, rank: .jack),
        ])
        XCTAssertEqual(threeOfAKind.ranking, .threeOfAKind)
        XCTAssertEqual(threeOfAKind.rankingValues, [11, 6, 5])
        
        let twoPair = Hand([
                Card(suit: .clubs, rank: .six),
                Card(suit: .diamonds, rank: .two),
                Card(suit: .spades, rank: .three),
                Card(suit: .clubs, rank: .five),
                Card(suit: .diamonds, rank: .five),
                Card(suit: .spades, rank: .jack),
                Card(suit: .clubs, rank: .jack),
        ])
        XCTAssertEqual(twoPair.ranking, .twoPair)
        XCTAssertEqual(twoPair.rankingValues, [11, 5, 6])
        
        let onePair = Hand([
                Card(suit: .clubs, rank: .six),
                Card(suit: .diamonds, rank: .two),
                Card(suit: .spades, rank: .three),
                Card(suit: .clubs, rank: .ace),
                Card(suit: .diamonds, rank: .five),
                Card(suit: .spades, rank: .jack),
                Card(suit: .clubs, rank: .jack),
        ])
        XCTAssertEqual(onePair.ranking, .onePair)
        XCTAssertEqual(onePair.rankingValues, [11, 14, 6, 5])
        
        let highCard = Hand([
                Card(suit: .clubs, rank: .six),
                Card(suit: .diamonds, rank: .two),
                Card(suit: .spades, rank: .three),
                Card(suit: .clubs, rank: .ace),
                Card(suit: .diamonds, rank: .five),
                Card(suit: .spades, rank: .jack),
                Card(suit: .clubs, rank: .king),
        ])
        XCTAssertEqual(highCard.ranking, .highCard)
        XCTAssertEqual(highCard.rankingValues, [14, 13, 11, 6, 5])
        
        
        // MARK: Ranking Hands
        XCTAssertTrue(fourOfAKind > fullHouse)
        XCTAssertTrue(fullHouse > flush)
        XCTAssertTrue(flush > threeOfAKind)
        XCTAssertTrue(threeOfAKind > twoPair)
        XCTAssertTrue(twoPair > highCard)
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
