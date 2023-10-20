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
    
    @State private var selectedDevice = "All"
    
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                ReadDataView(selectedDevice: $selectedDevice)
                Divider()
                SelectDeviceView(selectedDevice: $selectedDevice)
            }
            .layoutPriority(0)
            Divider()
            HStack(alignment: .top) {
                ScreenTimeUsageView(selectedDevice: selectedDevice)
                Divider()
                UploadView()
            }
            .layoutPriority(1)
        }
        .padding()
    }
}



#Preview {
    iOSUsageView()
}
