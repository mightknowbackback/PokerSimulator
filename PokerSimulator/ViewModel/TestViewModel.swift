//
//  TestViewModel.swift
//  PokerSimulator
//
//  Created by mightknow on 11/5/20.
//

import Foundation

extension ViewModel {
    var testViewPlayerStrings : [(player: String, cards: String)] {
        var result : [(player: String, cards: String)] = []
        for p in self.gameModel.players {
            let player = "Player \(p.playerNumber):"
            let cards : String = {
                var result = ""
                if p.cards.count != 0 {
                    let c1 = p.cards[0].abbreviation
                    let c2 = p.cards[1].abbreviation
                    result = c1 + " " + c2
                }
                return result
            }()
            result.append((player: player, cards: cards))
        }
        return result
    }
    var boardString : String {
        var result = ""
        if self.gameModel.board.isEmpty {
            result = "-"
        }
        for c in self.gameModel.board {
            result.append(c.abbreviation)
            if c != self.gameModel.board.last {
                result.append(" ")
            }
        }
        return result
    }
    var stateString : String {
        let top = self.gameModel.currentBest()
        var string = ""
        var numberString : String {
            var s = ""
            for p in top {
                s += String(p.playerNumber)
                if p != top.last {
                    s += ", "
                }
            }
            return s
        }
        switch self.gameModel.round {
        case .river:
            if top.count > 1 {
                string = "Players \(numberString) tied with a \(top[0].hand.description)"
            } else {
                string = "Player \(numberString) wins with a \(top[0].hand.description)"
            }
        default:
            if top.count > 1 {
                string = "Players \(numberString) have the current top hand with a \(top[0].hand.description)"
            } else {
                string = "Player \(numberString) has the current top hand with a \(top[0].hand.description)"
            }
        }
        return string
    }
}
