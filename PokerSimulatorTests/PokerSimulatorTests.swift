//
//  PokerSimulatorTests.swift
//  PokerSimulatorTests
//
//  Created by mightknow on 10/27/20.
//

import XCTest
@testable import PokerSimulator

class PokerSimulatorTests: XCTestCase {
    
    func shuffleTest() {
        for _ in 0...10 {
            let scrambledDeck = Deck(shuffleMethods: [.scramble])
            XCTAssertEqual(scrambledDeck.cards.count, 52)
            let riffledDeck = Deck(shuffleMethods: [.riffle])
            XCTAssertEqual(riffledDeck.cards.count, 52)
            let machineDeck = Deck(shuffleMethods: [.machine])
            XCTAssertEqual(machineDeck.cards.count, 52)
            let randomDeck = Deck(shuffleMethods: [.random])
            XCTAssertEqual(randomDeck.cards.count, 52)
        }
        
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
