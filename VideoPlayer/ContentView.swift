//
//  ContentView.swift
//  VideoPlayer
//
//  Created by Jeff Smith on 5/6/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("Hello world")
                
                NavigationLink {
                    DLNAView()
                } label: {
                    Label("DLNA Devices", systemImage: "network")
                        .font(.headline)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
