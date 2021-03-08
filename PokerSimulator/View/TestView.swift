//
//  TestView.swift
//  PokerSimulator
//
//  Created by mightknow on 11/5/20.
//

import SwiftUI

struct TestView: View {
    
    @EnvironmentObject var viewModel : ViewModel
    
    @State private var betAmount : Float = 0
    
    func deal() {
        self.viewModel.gameModel.continuePlay()
    }
    func check() {
        print("CHECK")
        self.viewModel.gameModel.hero.action = .check
        self.viewModel.gameModel.currentBet += 0
        self.viewModel.gameModel.continuePlay()
    }
    func fold() {
        print("FOLD")
        self.viewModel.gameModel.hero.action = .fold
        self.viewModel.gameModel.currentBet += 0
        self.viewModel.gameModel.continuePlay()
    }
    func call() {
        print("CALL")
        self.viewModel.gameModel.hero.action = .call
        self.viewModel.gameModel.hero.actionAmount = self.viewModel.gameModel.currentBet
        self.viewModel.gameModel.currentBet += 0
        self.viewModel.gameModel.continuePlay()
    }
    func bet() {
        print("BET $\(Int(self.betAmount))")
        self.viewModel.gameModel.hero.action = .raise
        self.viewModel.gameModel.hero.actionAmount = Int(self.betAmount)
        self.viewModel.gameModel.currentBet += Int(self.betAmount)
        self.viewModel.gameModel.continuePlay()
    }
    
    var body: some View {
        VStack {
            Text("ROUND:")
            Text(self.viewModel.gameModel.round.rawValue.capitalized).padding(.bottom)
            Text("BOARD:")
            Text(self.viewModel.boardString).padding(.bottom)
            ForEach(0..<self.viewModel.gameModel.players.count) {i in
                HStack {
                    Text(self.viewModel.testViewPlayerStrings[i].player).frame(maxWidth: .infinity)
                    Text(self.viewModel.testViewPlayerStrings[i].cards).frame(maxWidth: .infinity)
                    Text(self.viewModel.testViewPlayerStrings[i].action).frame(maxWidth: .infinity)
                }
            }
            HStack {
                Button(action: self.check) {
                    Text("CHECK")
                }.frame(maxWidth: .infinity)
                Button(action: self.fold) {
                    Text("FOLD")
                }.frame(maxWidth: .infinity)
                Button(action: self.call) {
                    Text("CALL")
                }.frame(maxWidth: .infinity)
                Button(action: self.bet) {
                    Text("BET")
                }.frame(maxWidth: .infinity)
            }.padding()
            Text("Amount: " + String(Int(self.betAmount)))
            Slider(value: self.$betAmount, in: 0...500).padding()
            Button(action: self.deal) {
                Text("Deal").padding()
            }
            Text(self.viewModel.gameStateString).padding()
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static let viewModel : ViewModel = ViewModel(gameModel: GameModel(shuffleMethods: .machine, numberOfPlayers: 9, startingChips: 500))
    static var previews: some View {
        TestView().environmentObject(Self.viewModel)
    }
}
