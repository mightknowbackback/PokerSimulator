//
//  ViewModel.swift
//  PokerSimulator
//
//  Created by mightknow on 11/5/20.
//

import Foundation

class ViewModel : ObservableObject {
    
    @Published var gameModel : GameModel
    
    init(gameModel : GameModel) {
        self.gameModel = gameModel
    }
}
