//
//  iOSUsageView.swift
//  iOSUsage
//
//  Created by Christopher Slade on 10/12/23.
//

import SwiftUI
import SwiftData

struct iOSUsageView: View {
    @Environment(\.modelContext) var context
    @Query private var usages: [Usage]
    @State private var selectedFile: URL? = nil
    
    @State private var selectedDevice = "All"
    
    var uniqueDevices: [String] {
        var devices = Set<String>()
        for usage in usages {
            if usage.device != nil {
                devices.insert(usage.device!)
            }
        }
        return Array(devices)
    }
    
    var body: some View {
        VStack {
            HStack(alignment: .top) {
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
                                let readerActor = UsageReader(modelContainer: context.container)
                                do {
                                    try await readerActor.readData(folderURL: selectedFile!)
                                } catch {
                                    print(error.localizedDescription)
                                }
                            }
                        }.disabled(selectedFile == nil)
                        Button("Clear Data") {
                            selectedDevice = "All"
                            Task {
                                let readerActor = UsageReader(modelContainer: context.container)
                                do {
                                    try await readerActor.clearData()
                                } catch {
                                    print(error.localizedDescription)
                                }
                            }
                        }
                    }
                }
                Divider()
                VStack {
                    Text("Devices")
                    Picker("Select Device", selection: $selectedDevice) {
                        Text("All").tag("All")
                        ForEach(uniqueDevices, id: \.self) { device in
                            Text(device)
                        }
                    }
                }
            }
            Divider()
            Text("Screen Time Usage")
                .font(.title)
            List(usages.filter { selectedDevice == "All" ? true : $0.device == selectedDevice }) { usage in
                VStack(alignment: .leading) {
                    Text(usage.appName)
                        .font(.title2)
                    Group {
                        HStack {
                            Text("Total Time: ")
                                .fontWeight(.bold)
                            Text(usage.totalTimeStr)
                        }
                        HStack {
                            Text("Start Time: ")
                                .fontWeight(.bold)
                            Text(usage.startTimeStr)
                        }
                        HStack {
                            Text("End Time: ")
                                .fontWeight(.bold)
                            Text(usage.endTimeStr)
                        }
                    }
                    .font(.footnote)
                }
            }
            Spacer()
        }
        .padding()
    }
}

#Preview {
    iOSUsageView()
}
