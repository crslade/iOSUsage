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
    
    private var readyForUpload: Bool { uploadURL != nil && uploadURL != "" && participantID != nil && participantID != "" }
    @State private var settingsFile: URL? = nil
    @State private var uploadURL: String? = nil
    @State private var participantID: String? = nil
    
    var participantBinding: Binding<String> {
        Binding<String>(
            get: {
                return self.participantID ?? ""
        },
            set: { newString in
                self.participantID = newString
        })
    }
    
    var uploadURLBinding: Binding<String> {
        Binding<String>(
            get: {
                return self.uploadURL ?? ""
        },
            set: { newString in
                self.participantID = newString
        })
    }

    @State private var presentingError = false
    @State private var errorMessage = ""
    
    var body: some View {
        VStack {
            Button("Select Settings File") {
                let panel = NSOpenPanel()
                panel.allowsMultipleSelection = false
                panel.canChooseDirectories = false
                if panel.runModal() == .OK {
                    let url = panel.url
                    print(url!)
                    settingsFile = url
                    if settingsFile != nil {
                        Task {
                            let uploadManager = UploadManager(modelContainer: context.container)
                            if let settings = try? await uploadManager.readUploadSettings(from: settingsFile!) {
                                uploadURL = settings.uploadURL
                                participantID = settings.participantID
                            } else {
                                print("Error reading settings")
                                errorMessage = "Wrong file format"
                                presentingError = true
                            }
                        }
                    }
                }
            }
            HStack {
                Text("Upload URL:")
                TextField("https://example.com", text: uploadURLBinding)
                    .textFieldStyle(.roundedBorder)
            }
            HStack {
                Text("Participant ID:")
                TextField("1", text: participantBinding)
                    .textFieldStyle(.roundedBorder)
            }
            Button("Upload Data") {
                print("Will Upload Data")
            }.disabled(!readyForUpload)
        }
        .alert(isPresented: $presentingError) {
            Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
        }
    }
    
}

#Preview {
    UploadView(selectedDevice: "All")
}

