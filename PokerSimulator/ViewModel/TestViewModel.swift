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
    var leadingHandString : String {
        let top = self.gameModel.currentBest()
        var string = ""
        var numberString : String {
            var s = ""
            for p in top {
                if top.count >= 2 {
                    if p == top.last! {
                        s += " and "
                    }
                }
                s += String(p.playerNumber)
                if top.count > 2 {
                    if p != top.last! {
                        s += ", "
                    }
               }
            }
            return s
        }
        var conditionalA : String {
            var string = ""
            switch top[0].hand.ranking {
            case .straightFlush, .fullHouse, .flush, .straight:
                string = "a "
            default:
                break
            }
            return string
        }
        switch self.gameModel.round {
        case .river:
            if top.count > 1 {
                string = "Players \(numberString) tied with \(conditionalA)\(top[0].hand.description)"
            } else {
                string = "Player \(numberString) wins with \(conditionalA)\(top[0].hand.description)"
            }
        default:
            if top.count > 1 {
                string = "Players \(numberString) have the current top hand with \(conditionalA)\(top[0].hand.description)"
            } else {
                string = "Player \(numberString) has the current top hand with \(conditionalA)\(top[0].hand.description)"
            }
        }
        var str = ""
        for p in self.gameModel.players {
            
            let tHand = top[0].hand
            let pHand = p.hand
            if tHand.ranking == pHand.ranking && !top.contains(p) && str == "" {
                
                if let kicker = Hand.findKickerFor(lhs: tHand, rhs: pHand) {
                    print("Kicker Needed:")
                    tHand.usedCards.printList()
                    pHand.usedCards.printList()
                    print()
                    str = Hand.kickerDescription(forValue: kicker)
                    string.append(str)
                }
            }
        }
        return string
    }
}
