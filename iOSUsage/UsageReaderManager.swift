//
//  UsageReaderManager.swift
//  iOSUsage
//
//  Created by Christopher Slade on 10/12/23.
//

import Foundation

@Observable
class UsageReaderManager {

    private(set) var data: [Any]?
    private(set) var devices = [String]()
    
    private var reader = UsageReader()
    
    func readData(folderURL: URL) async throws {
        try await reader.readData(folderURL: folderURL)
        if let loadedDevices = reader.devices {
            devices = Array(loadedDevices)
        }
    }
    
}
