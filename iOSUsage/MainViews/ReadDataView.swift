//
//  ReadDataView.swift
//  iOSUsage
//
//  Created by Christopher Slade on 10/19/23.
//

import SwiftUI
import SwiftData

struct ReadDataView: View {
    @Environment(\.modelContext) var context
    @State private var selectedFolder: URL? = nil
    @Binding var selectedDevice: String
    
    @State var presentingError = false
    @State var errorMessage = ""
    @State var errorTitle = ""
    
    var body: some View {
        VStack {
            Text("Select KnowledgeC Folder:")
                .font(.title)
            HStack {
                Button("Select Folder") {
                    let panel = NSOpenPanel()
                    panel.allowsMultipleSelection = false
                    panel.canChooseDirectories = true
                    panel.canChooseFiles = false
                    if panel.runModal() == .OK {
                        let url = panel.url
                        selectedFolder = url
                        if selectedFolder != nil {
                            print("Reading data from: \(url!)")
                            let readerActor = UsageReader(modelContainer: context.container)
                            Task {
                                do {
                                    try await readData(into: readerActor)
                                } catch {
                                    print(error.localizedDescription)
                                    errorTitle="Error"
                                    errorMessage = error.localizedDescription
                                    presentingError = true
                                }
                            }
                        }
                    }
                }
                Button("Clear Data") {
                    selectedDevice = "All"
                    let readerActor = UsageReader(modelContainer: context.container)
                    Task {
                        do {
                            try await readerActor.clearData()
                            errorTitle="Data Cleared"
                            errorMessage=""
                            presentingError = true
                        } catch {
                            print(error.localizedDescription)
                            errorTitle="Error"
                            errorMessage = error.localizedDescription
                            presentingError = true
                        }
                    }
                }
            }
        }
        .alert(isPresented: $presentingError) {
            Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    private func readData(into reader: UsageReader) async throws{
        try await reader.readData(folderURL: selectedFolder!)
        print("Read Data")
    }

}

#Preview {
    ReadDataView(selectedDevice: .constant("All") )
}

