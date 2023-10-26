//
//  ExportManager.swift
//  iOSUsage
//
//  Created by Christopher Slade on 10/25/23.
//

import Foundation
import SwiftData

actor ExportManager: ModelActor {
    
    let modelContainer: ModelContainer
    let modelExecutor: any ModelExecutor
    
    private let dateFormatter = DateFormatter()
    
    init(modelContainer: ModelContainer) {
        self.modelContainer = modelContainer
        let context = ModelContext(modelContainer)
        modelExecutor = DefaultSerialModelExecutor(modelContext: context)
        //Date Formatter Init
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current
    }
    
    func exportToCSV(participantID: String, selectedDevice: String, outputURL: URL) async throws {
        let fetchDescriptor: FetchDescriptor<Usage>
        if selectedDevice == "All" {
            fetchDescriptor = FetchDescriptor<Usage>(
                sortBy: [SortDescriptor(\.startTime, order: .forward)]
            )
        } else {
            fetchDescriptor = FetchDescriptor<Usage>(
                predicate: #Predicate { $0.device == selectedDevice },
                sortBy: [SortDescriptor(\.startTime, order: .forward)]
            )
        }
        let usages = try modelContext.fetch(fetchDescriptor)
        
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: outputURL.path) {
            fileManager.createFile(atPath: outputURL.path, contents: nil, attributes: nil)
        }
        
        let fileHandle = try FileHandle(forWritingTo: outputURL)
        var headers = "Participant ID,App Name,Start Time,End Time,Total Time"
        if selectedDevice == "All" {
            headers = "\(headers),Device\n"
        } else {
            headers = "\(headers)\n"
        }
        let headerData = headers.data(using: .utf8)!
        fileHandle.write(headerData)
        
        for usage in usages {
            let startTime = usage.startTime != nil ? dateFormatter.string(from: usage.startTime!) : "None"
            let endTime = usage.endTime != nil ? dateFormatter.string(from: usage.endTime!) : "None"
            print("\(participantID),\(usage.appName),\(startTime),\(endTime),\(usage.totalTimeStr),\(selectedDevice)")
            var row = "\(participantID),\(usage.appName),\(startTime),\(endTime),\(usage.totalTimeStr)"
            if selectedDevice == "All" {
                row = "\(row),\(usage.device ?? "nil")\n"
            } else {
                row = "\(row)\n"
            }
            if let rowData = row.data(using: .utf8) {
                fileHandle.write(rowData)
            } else {
                print("Error converting row to data")
                throw ExportError.illegalData
            }
        }
        fileHandle.closeFile()
    }
    
    enum ExportError: Error {
        case illegalData
    }
    
}
