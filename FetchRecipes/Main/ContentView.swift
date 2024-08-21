//
//  ContentView.swift
//  FetchRecipes
//
//  Created by Gina Mullins on 8/17/24.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        HomeView(
            viewModel: HomeViewModel(api: API())
        )
        .onAppear {
            NetworkMonitor.shared.startMonitoring()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
