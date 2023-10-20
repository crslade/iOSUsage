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
    @State private var selectedFile: URL? = nil
    
    var body: some View {
        VStack {
            Text("Credentials:")
                .font(.title)
            Button("Select File") {
                let panel = NSOpenPanel()
                panel.allowsMultipleSelection = false
                panel.canChooseDirectories = false
                if panel.runModal() == .OK {
                    let url = panel.url
                    print(url!)
                    selectedFile = url
                }
            }
        }
    }
}

#Preview {
    UploadView()
}

