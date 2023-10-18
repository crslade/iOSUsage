//
//  iOSUsageApp.swift
//  iOSUsage
//
//  Created by Christopher Slade on 10/12/23.
//

import SwiftUI
import SwiftData

@main
struct iOSUsageApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Usage.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            iOSUsageView()
        }
        .modelContainer(sharedModelContainer)
    }
}
