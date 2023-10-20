//
//  SelectDeviceView.swift
//  iOSUsage
//
//  Created by Christopher Slade on 10/19/23.
//

import SwiftUI
import SwiftData

struct SelectDeviceView: View {
    @Environment(\.modelContext) var context
    @Query private var usages: [Usage]
    @Binding var selectedDevice: String
    
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
            Text("Devices")
                .font(.title)
            Picker("Select Device", selection: $selectedDevice) {
                Text("All").tag("All")
                ForEach(uniqueDevices, id: \.self) { device in
                    Text(device)
                }
            }
        }
    }
}

#Preview {
    SelectDeviceView(selectedDevice: .constant("All"))
}
