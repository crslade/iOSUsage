//
//  iOSUsageView.swift
//  iOSUsage
//
//  Created by Christopher Slade on 10/12/23.
//

import SwiftUI

struct iOSUsageView: View {
    @State private var selectedFile: URL? = nil
    @State private var reader = UsageReaderManager()
    
    @State private var selectedDevice = "All"
    
    var body: some View {
        VStack {
            HStack {
                VStack {
                    Text("Select KnowledgeC Folder:")
                    HStack {
                        Button("Select Folder") {
                            let panel = NSOpenPanel()
                            panel.allowsMultipleSelection = false
                            panel.canChooseDirectories = true
                            panel.canChooseFiles = false
                            if panel.runModal() == .OK {
                                let url = panel.url
                                print(url!)
                                selectedFile = url
                            }
                        }
                        Button("Read Data") {
                            Task {
                                do {
                                    try await reader.readData(folderURL: selectedFile!)
                                } catch {
                                    print(error)
                                }
                            }
                        }.disabled(selectedFile == nil)
                    }
                }
                Divider()
                VStack {
                    Text("Devices")
                    Picker("Select Device", selection: $selectedDevice) {
                        Text("All").tag("All")
                        ForEach(reader.devices, id: \.self) { device in
                            Text(device)
                        }
                    }
                }
            }
            Divider()
            Text("Screen Time Usage")
        }
        .padding()
    }
}

#Preview {
    iOSUsageView()
}
