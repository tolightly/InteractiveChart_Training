//
//  ContentView.swift
//  InteractiveChart
//
//  Created by Denys Nazymok on 16.12.2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            Home()
                .navigationTitle("Interactive Charts")
        }
    }
}

#Preview {
    ContentView()
}
