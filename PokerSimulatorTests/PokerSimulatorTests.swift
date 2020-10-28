//
//  PokerSimulatorTests.swift
//  PokerSimulatorTests
//
//  Created by mightknow on 10/27/20.
//

import XCTest
@testable import PokerSimulator

class PokerSimulatorTests: XCTestCase {
    
//    func testShuffle() {
//        for _ in 0...10 {
//            let scrambledDeck = Deck(shuffleMethods: [.scramble])
//            XCTAssertEqual(scrambledDeck.cards.count, 52)
//            let riffledDeck = Deck(shuffleMethods: [.riffle])
//            XCTAssertEqual(riffledDeck.cards.count, 52)
//            let machineDeck = Deck(shuffleMethods: [.machine])
//            XCTAssertEqual(machineDeck.cards.count, 52)
//            let randomDeck = Deck(shuffleMethods: [.random])
//            XCTAssertEqual(randomDeck.cards.count, 52)
//        }
//    }
    
    func testHandRanking() {
        let flush = Hand(
            [
                Card(suit: .hearts, rank: .ace),
                Card(suit: .hearts, rank: .eight),
                Card(suit: .hearts, rank: .four),
                Card(suit: .hearts, rank: .five),
                Card(suit: .hearts, rank: .jack),
                Card(suit: .clubs, rank: .two),
                Card(suit: .diamonds, rank: .king),
        ])
        XCTAssertEqual(flush.ranking, .flush)
        let straight = Hand(
            [
                Card(suit: .clubs, rank: .six),
                Card(suit: .diamonds, rank: .two),
                Card(suit: .spades, rank: .three),
                Card(suit: .clubs, rank: .five),
                Card(suit: .diamonds, rank: .four),
                Card(suit: .spades, rank: .jack),
                Card(suit: .clubs, rank: .ten),
        ])
        XCTAssertEqual(straight.ranking, .straight)
        XCTAssertTrue(flush > straight)
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
