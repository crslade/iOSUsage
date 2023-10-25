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
    @AppStorage(UploadManager.DefaultsKeys.uploadURIKey) var uploadURI: String?
    @AppStorage(UploadManager.DefaultsKeys.participantIDKey) var participantID: String?
    @Query private var usages: [Usage]
    var selectedDevice: String
    
    private var credentialsLoaded: Bool { uploadURI != nil }
    @State private var selectedFile: URL? = nil
    
    var participantBinding: Binding<String> {
            Binding<String>(
                get: {
                    return self.participantID ?? ""
            },
                set: { newString in
                    self.participantID = newString
            })
        }

    
    var body: some View {
        VStack {
            Text("Upload Database:")
                .font(.title)
            if uploadURI != nil {
                Text("Upload Destination Set")
                VStack(alignment: .leading) {
                    Text("ParticipantID:")
                    TextField("ParticipantID", text: participantBinding)
                        .textFieldStyle(.roundedBorder)
                        .layoutPriority(0.5)
                }
                Button("Upload Data") {
                    if participantID != nil {
                        print("Uploading for \(participantID!)")
                        Task {
                            do {
                                try await UploadManager.shared.uploadData()
                            } catch {
                                print("Error Uploading Data: \(error.localizedDescription)")
                            }
                        }
                    } else {
                        print("No ParticipantID set")
                    }
                }
                Button("Clear Upload Settings") {
                    UploadManager.shared.clearSettings()
                }
            } else {
                Button("Select Settings File") {
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
                                    try await readUploadSettings()
                                    print("Selected Device: \(selectedDevice)")
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
    
    private func readUploadSettings() async throws {
        try await UploadManager.shared.readUploadSettings(from: selectedFile!)
    }
    
}

#Preview {
    UploadView(selectedDevice: "All")
}

