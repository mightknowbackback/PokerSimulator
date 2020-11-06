//
//  TestView.swift
//  PokerSimulator
//
//  Created by mightknow on 11/5/20.
//

import SwiftUI

struct TestView: View {
    
    @EnvironmentObject var viewModel : ViewModel
    
    func deal() {
        self.viewModel.gameModel.deal()
    }
    
    var body: some View {
        VStack {
            Text("ROUND:")
            Text(self.viewModel.gameModel.round.rawValue.capitalized).padding(.bottom)
            Text("BOARD:")
            Text(self.viewModel.boardString).padding(.bottom)
            ForEach(0..<self.viewModel.gameModel.players.count) {i in
                HStack {
                    Text(self.viewModel.testViewPlayerStrings[i].player)
                    Text(self.viewModel.testViewPlayerStrings[i].cards)
                }
            }
            Text(self.viewModel.stateString).padding()
            Button(action: self.deal) {
                Text("Deal").padding()
            }
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static let viewModel : ViewModel = ViewModel(gameModel: GameModel(shuffleMethods: .machine, players: 9))
    static var previews: some View {
        TestView().environmentObject(Self.viewModel)
    }
}
