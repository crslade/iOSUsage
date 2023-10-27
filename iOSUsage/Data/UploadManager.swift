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
    
    func upload(to uploadURL: String, participantID: String, selectedDevice: String) async throws {
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
        let uploadDictionary = generateUploadDictionary(for: usages, with: participantID)
        let data = try JSONSerialization.data(withJSONObject: uploadDictionary, options: .prettyPrinted)
        print ("Uploading: \(data)")
        try await uploadData(data: data, to: uploadURL)
        //send request
        
    }
    
    private func uploadData(data: Data, to urlString: String) async throws {
        guard let url = URL(string: urlString) else {
            throw UploadError.invalidURL
        }
        print("creating URL")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let (resData, response) = try await URLSession.shared.upload(for: request, from: data)
        if let response = response as? HTTPURLResponse {
            if (200...299).contains(response.statusCode) {
                print("Upload Successful")
            } else {
                print("Status code: \(response.statusCode)")
                print(resData)
                throw UploadError.uploadFailed("Upload failed with status code \(response.statusCode)")
            }
        } else {
            print("No response")
            throw UploadError.uploadFailed("No response")
        }
    }
    
    enum UploadError: Error {
        case uploadFailed(String)
        case invalidURL
    }
    
    private func generateUploadDictionary(for usages: [Usage], with participantID: String) -> [String: Any] {
        var usagesDictionary = [[String: String]]()
        for usage in usages {
            let usageDict = usage.toDictionary(using: dateFormatter, with: participantID)
            usagesDictionary.append(usageDict)
        }
        
        return ["data": usagesDictionary]
    }

}
