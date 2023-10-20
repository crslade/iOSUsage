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
    
    private var credentialsLoaded: Bool { dbName != nil }
    @State private var selectedFile: URL? = nil
    
    @State private var dbName: String? = nil
    @State private var clientId: String? = nil
    @State private var dbSecret: String? = nil
    
    var body: some View {
        VStack {
            Text("Upload Database:")
                .font(.title)
            if credentialsLoaded {
                Text(dbName!)
                Button("Clear Credentials") {
                    Task {
                        do {
                            try await clearCredentials()
                        } catch {
                            print("Error: \(error.localizedDescription)")
                        }
                    }
                }
            } else {
                Button("Select Credential File") {
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
                                    try await readCredentials()
                                    print("Selected Device: \(selectedDevice)")
                                } catch {
                                    print("Error: \(error.localizedDescription)")
                                }
                            }
                        }
                        
                    }
                }
            }
        }.onAppear {
            Task {
                do {
                    try await loadCredentials()
                } catch {
                    print("Error Loading Credentiasls: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func readCredentials() async throws {
        if let fileURL = selectedFile {
            let storeManager = SecureStoreManager()
            let credentials = try await storeManager.readAndStore(fileName: fileURL)
            dbName = credentials.dbName
            clientId = credentials.clientID
            dbSecret = credentials.secret
        }
    }
    
    private func loadCredentials() async throws {
        let storeManager = SecureStoreManager()
        if let credentials = try await storeManager.retrive() {
            dbName = credentials.dbName
            clientId = credentials.clientID
            dbSecret = credentials.secret
        } else {
            print("No credentials found")
        }
    }
    
    private func clearCredentials() async throws {
        let storeManager = SecureStoreManager()
        try await storeManager.delete()
        dbName = nil
        clientId = nil
        dbSecret = nil
    }
}

#Preview {
    UploadView(selectedDevice: "All")
}

