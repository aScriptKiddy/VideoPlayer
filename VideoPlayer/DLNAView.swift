//
//  DLNAView.swift
//  VideoPlayer
//
//  Created by Jeff Smith on 5/6/26.
//

import SwiftUI

struct DLNAServer: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let address: String
    var isManuallyAdded: Bool = false
}

struct DLNAServerContent: Identifiable {
    let id = UUID()
    let name: String
    let type: ContentType
    let path: String
    
    enum ContentType {
        case folder
        case video
        case audio
        case image
        
        var iconName: String {
            switch self {
            case .folder: return "folder.fill"
            case .video: return "play.rectangle.fill"
            case .audio: return "music.note"
            case .image: return "photo.fill"
            }
        }
    }
}

struct DLNAServerContentsView: View {
    let server: DLNAServer
    @State private var contents: [DLNAServerContent] = []
    @State private var isLoading = false
    
    var body: some View {
        List {
            if isLoading {
                HStack {
                    ProgressView()
                        .padding(.trailing, 8)
                    Text("Loading contents...")
                }
            } else if contents.isEmpty {
                Text("No content available")
                    .foregroundStyle(.secondary)
            } else {
                ForEach(contents) { item in
                    NavigationLink {
                        if item.type == .folder {
                            // Navigate to subfolder
                            Text("Folder: \(item.name)")
                        } else {
                            // Show media player
                            Text("Playing: \(item.name)")
                        }
                    } label: {
                        HStack {
                            Image(systemName: item.type.iconName)
                                .foregroundStyle(item.type == .folder ? .blue : .green)
                                .frame(width: 30)
                            VStack(alignment: .leading, spacing: 4) {
                                Text(item.name)
                                    .font(.body)
                                Text(item.path)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle(server.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    loadContents()
                } label: {
                    Label("Refresh", systemImage: "arrow.clockwise")
                }
                .disabled(isLoading)
            }
        }
        .onAppear {
            loadContents()
        }
    }
    
    private func loadContents() {
        isLoading = true
        
        // Simulate loading server contents
        // TODO: Implement actual DLNA content browsing
        Task {
            try? await Task.sleep(for: .seconds(1))
            contents = [
                DLNAServerContent(name: "Movies", type: .folder, path: "/media/movies"),
                DLNAServerContent(name: "TV Shows", type: .folder, path: "/media/tv"),
                DLNAServerContent(name: "Music", type: .folder, path: "/media/music"),
                DLNAServerContent(name: "Photos", type: .folder, path: "/media/photos"),
                DLNAServerContent(name: "Sample Video.mp4", type: .video, path: "/media/sample.mp4"),
                DLNAServerContent(name: "Sample Audio.mp3", type: .audio, path: "/media/sample.mp3"),
            ]
            isLoading = false
        }
    }
}

struct DLNAView: View {
    @State private var isSearching = false
    @State private var discoveredServers: [DLNAServer] = []
    @State private var showAddServerSheet = false
    @State private var newServerName = ""
    @State private var newServerAddress = ""
    
    var body: some View {
        List {
            Section {
                if isSearching {
                    HStack {
                        ProgressView()
                            .padding(.trailing, 8)
                        Text("Searching for DLNA servers...")
                    }
                } else if discoveredServers.isEmpty {
                    Text("No servers found")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(discoveredServers) { server in
                        NavigationLink {
                            DLNAServerContentsView(server: server)
                        } label: {
                            HStack {
                                Image(systemName: server.isManuallyAdded ? "network" : "tv")
                                    .foregroundStyle(.blue)
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(server.name)
                                        .font(.body)
                                    Text(server.address)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                                if server.isManuallyAdded {
                                    Text("Manual")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                    .onDelete(perform: deleteServer)
                }
            } header: {
                Text("Available Servers")
            }
        }
        .navigationTitle("DLNA Servers")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    searchForDevices()
                } label: {
                    Label("Search", systemImage: "arrow.clockwise")
                }
                .disabled(isSearching)
            }
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showAddServerSheet = true
                } label: {
                    Label("Add Server", systemImage: "plus")
                }
            }
        }
        .sheet(isPresented: $showAddServerSheet) {
            NavigationStack {
                Form {
                    Section {
                        TextField("Server Name", text: $newServerName)
                        TextField("IP Address or Hostname", text: $newServerAddress)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                    } header: {
                        Text("Server Details")
                    } footer: {
                        Text("Enter the IP address or hostname of your DLNA server (e.g., 192.168.1.100 or server.local)")
                    }
                }
                .navigationTitle("Add DLNA Server")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            showAddServerSheet = false
                            resetForm()
                        }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Add") {
                            addServer()
                        }
                        .disabled(newServerName.isEmpty || newServerAddress.isEmpty)
                    }
                }
            }
            .presentationDetents([.medium])
        }
    }
    
    private func searchForDevices() {
        isSearching = true
        
        // Simulate server discovery
        // TODO: Implement actual DLNA server discovery
        Task {
            try? await Task.sleep(for: .seconds(2))
            let discoveredFromNetwork = [
                DLNAServer(name: "Living Room TV", address: "192.168.1.10"),
                DLNAServer(name: "Bedroom Media Player", address: "192.168.1.11"),
                DLNAServer(name: "Office Speaker", address: "192.168.1.12")
            ]
            
            // Keep manually added servers and add discovered ones
            let manualServers = discoveredServers.filter { $0.isManuallyAdded }
            discoveredServers = manualServers + discoveredFromNetwork
            isSearching = false
        }
    }
    
    private func addServer() {
        let newServer = DLNAServer(
            name: newServerName,
            address: newServerAddress,
            isManuallyAdded: true
        )
        discoveredServers.append(newServer)
        showAddServerSheet = false
        resetForm()
    }
    
    private func resetForm() {
        newServerName = ""
        newServerAddress = ""
    }
    
    private func deleteServer(at offsets: IndexSet) {
        discoveredServers.remove(atOffsets: offsets)
    }
}

#Preview {
    NavigationStack {
        DLNAView()
    }
}
