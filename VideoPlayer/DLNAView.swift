//
//  DLNAView.swift
//  VideoPlayer
//
//  Created by Jeff Smith on 5/6/26.
//

import SwiftUI

struct DLNAView: View {
    @State private var isSearching = false
    @State private var discoveredDevices: [String] = []
    
    var body: some View {
        List {
            Section {
                if isSearching {
                    HStack {
                        ProgressView()
                            .padding(.trailing, 8)
                        Text("Searching for DLNA devices...")
                    }
                } else if discoveredDevices.isEmpty {
                    Text("No devices found")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(discoveredDevices, id: \.self) { device in
                        HStack {
                            Image(systemName: "tv")
                                .foregroundStyle(.blue)
                            Text(device)
                        }
                    }
                }
            } header: {
                Text("Available Devices")
            }
        }
        .navigationTitle("DLNA Devices")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    searchForDevices()
                } label: {
                    Label("Search", systemImage: "arrow.clockwise")
                }
                .disabled(isSearching)
            }
        }
    }
    
    private func searchForDevices() {
        isSearching = true
        
        // Simulate device discovery
        // TODO: Implement actual DLNA device discovery
        Task {
            try? await Task.sleep(for: .seconds(2))
            discoveredDevices = [
                "Living Room TV",
                "Bedroom Media Player",
                "Office Speaker"
            ]
            isSearching = false
        }
    }
}

#Preview {
    NavigationStack {
        DLNAView()
    }
}
