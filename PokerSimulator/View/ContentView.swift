//
//  ContentView.swift
//  PokerSimulator
//
//  Created by mightknow on 10/27/20.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var viewModel : ViewModel
    
    var body: some View {
        TestView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
