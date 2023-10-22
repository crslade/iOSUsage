//
//  UploadManager.swift
//  iOSUsage
//
//  Created by Christopher Slade on 10/20/23.
//

import Foundation
import SwiftData

import AWSDynamoDB
import AwsCAuth

actor UploadManager: ModelActor {
    let modelContainer: ModelContainer
    let modelExecutor: any ModelExecutor
    let dbName: String
    
    init(modelContainer: ModelContainer, dbName: String, clientId: String, dbSecret: String) {
        self.modelContainer = modelContainer
        let context = ModelContext(modelContainer)
        modelExecutor = DefaultSerialModelExecutor(modelContext: context)
        let region =  String(dbName.split(separator: ":")[0])
        self.dbName = String(dbName.split(separator: ":")[1])
        let provider = AWSServiceManager.default()
        let config = AWSCredentialsProviderStatic.config(withAccessKey: clientId, secretKey: dbSecret)
    }
    
    func uploadData() {
        let client = DynamoDB(region: .uswest2, accessKeyId: "YOUR_ACCESS_KEY", secretAccessKey: "YOUR_SECRET_KEY")
        
    }
    
}
