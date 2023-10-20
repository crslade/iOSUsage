//
//  UploadView.swift
//  iOSUsage
//
//  Created by Christopher Slade on 10/19/23.
//

import SwiftUI
import SwiftData

struct UploadView: View {
    @Environment(\.modelContext) var context
    @Query private var usages: [Usage]
    var selectedDevice: String
    
    @State private var credentialsLoaded = false
    @State private var selectedFile: URL? = nil
    
    var body: some View {
        VStack {
            Text("Credentials:")
                .font(.title)
            if credentialsLoaded {
                Text("Loaded")
            } else {
                Button("Select File") {
                    let panel = NSOpenPanel()
                    panel.allowsMultipleSelection = false
                    panel.canChooseDirectories = false
                    if panel.runModal() == .OK {
                        let url = panel.url
                        print(url!)
                        selectedFile = url
                        if selectedFile != nil {
                            Task {
                                do {
                                    try await loadCredentials()
                                } catch {
                                    print("Error: \(error.localizedDescription)")
                                }
                            }
                        }
                        
                    }
                }
            }
        }
    }
    
    private func loadCredentials() async throws {
        let storeManager = SecureStoreManager()
        try await storeManager.delete()
        print("Deleted")
        try await storeManager.store(dbName: "TestDB", clientId: "clientID", secret: "secret123")
        print("Stored")
        if let stored = try await storeManager.retrive() {
            print("DBName: \(stored.dbName) Client: \(stored.clientID) Secret:  \(stored.secret)")
        } else {
            print("No credentials found")
        }
    }
}

#Preview {
    UploadView(selectedDevice: "All")
}

