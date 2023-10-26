//
//  ExportView.swift
//  iOSUsage
//
//  Created by Christopher Slade on 10/24/23.
//

import SwiftUI
import SwiftData

struct ExportView: View {
    @Environment(\.modelContext) var context
    
    @State private var participantID: String = ""
    var selectedDevice: String
    
    @State private var outputFile: URL? = nil
    
    var body: some View {
        VStack {
            HStack {
                Text("Participant ID")
                TextField("Participant ID", text: $participantID)
            }
            Button("Export to CSV") {
                let panel = NSSavePanel()
                panel.nameFieldStringValue = "output-\(participantID).csv"
                panel.canCreateDirectories = true
                if panel.runModal() == .OK {
                    if let url = panel.url {
                        print("Saving to \(url)")
                        let exportManager = ExportManager(modelContainer: context.container)
                        Task {
                            do {
                                try await exportManager.exportToCSV(participantID: participantID, selectedDevice: selectedDevice, outputURL: url)
                            } catch {
                                print("Error: \(error.localizedDescription)")
                            }
                        }
                    }
                }
            }
            .disabled(participantID.isEmpty)
            
            
        }
    }
}

#Preview {
    ExportView(selectedDevice: "All")
}
