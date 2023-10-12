//
//  ContentView.swift
//  iOSUsage
//
//  Created by Christopher Slade on 10/12/23.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedFile: URL? = nil
    
    var body: some View {
        VStack {
            Button("Open File") {
                let panel = NSOpenPanel()
                panel.allowsMultipleSelection = false
                panel.canChooseDirectories = false
                if panel.runModal() == .OK {
                    let url = panel.url
                    print(url!)
                }
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
