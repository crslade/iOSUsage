//
//  ScreenTimeUsagesView.swift
//  iOSUsage
//
//  Created by Christopher Slade on 10/19/23.
//
import SwiftUI
import SwiftData

struct ScreenTimeUsageView: View {
    @Environment(\.modelContext) var context
    @Query(sort: \Usage.startTime) private var usages: [Usage]
    var selectedDevice: String
    
    var body: some View {
        VStack {
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
        }
    }
}

#Preview {
    ScreenTimeUsageView(selectedDevice: "All")
}
