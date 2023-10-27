//
//  UploadManager.swift
//  iOSUsage
//
//  Created by Christopher Slade on 10/21/23.
//

import Foundation
import SwiftData

actor UploadManager: ModelActor {
   
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
    
    func readUploadSettings(from fileURL: URL) async throws -> (uploadURL: String, participantID: String?)? {
        let credentials = try String(contentsOf: fileURL, encoding: .utf8).split(separator: /,/)
        if credentials.count == 1 {
            return (uploadURL: String(credentials[0]), nil)
        } else if credentials.count == 2 {
            return (uploadURL: String(credentials[1]), participantID: String(credentials[0]))
        } else {
            return nil
        }
    }
    
    func uploadData(to uploadURL: URL, with participantID: String) async throws {
        print("Uploading to \(uploadURL) for \(participantID)")
    }
    
    
    

}
