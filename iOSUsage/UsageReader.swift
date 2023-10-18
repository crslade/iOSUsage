//
//  UsageReader.swift
//  iOSUsage
//
//  Created by Christopher Slade on 10/12/23.
//

import Foundation
import SQLite
import SwiftData

actor UsageReader: ModelActor {

    let modelContainer: ModelContainer
    let modelExecutor: any ModelExecutor
    
    init(modelContainer: ModelContainer) {
        self.modelContainer = modelContainer
        let context = ModelContext(modelContainer)
        modelExecutor = DefaultSerialModelExecutor(modelContext: context)
        //Date Formatter Init
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current
    }
    
    func readData(folderURL: URL) async throws {
        try await clearData()
        let dbURL = folderURL.appendingPathComponent("KnowledgeC").appendingPathExtension("db")
        let db = try Connection(dbURL.path)
        print("Connection made")
        let query = """
        SELECT
            ZOBJECT.ZVALUESTRING AS "app",
            (ZOBJECT.ZENDDATE - ZOBJECT.ZSTARTDATE) AS "usage",
            datetime(ZOBJECT.ZSTARTDATE+978307200,'UNIXEPOCH', 'LOCALTIME') as "start_time",
            datetime(ZOBJECT.ZENDDATE+978307200,'UNIXEPOCH', 'LOCALTIME') as "end_time",
            ZOBJECT.ZSTARTDAYOFWEEK as "day_of_week",
            ZOBJECT.ZSECONDSFROMGMT AS "tz",
            ZSOURCE.ZDEVICEID AS "device_id",
            ZMODEL AS "device_model"
        FROM
            ZOBJECT
            LEFT JOIN
            ZSTRUCTUREDMETADATA
            ON ZOBJECT.ZSTRUCTUREDMETADATA = ZSTRUCTUREDMETADATA.Z_PK
            LEFT JOIN
            ZSOURCE
            ON ZOBJECT.ZSOURCE = ZSOURCE.Z_PK
            LEFT JOIN
            ZSYNCPEER
            ON ZSOURCE.ZDEVICEID = ZSYNCPEER.ZDEVICEID
        WHERE
            ZSTREAMNAME = "/app/usage" AND
            ZSOURCE.ZDEVICEID IS NOT NULL
        ORDER BY
            ZSTARTDATE DESC
        """
        

        
        for row in try db.prepare(query) {
            if let appName = row[0] as? String{
                let deviceId = row[6] as? String
                var totalTime: Int? = nil
                if let totalTime64 = row[1] as? Int64 {
                    totalTime = Int(totalTime64)
                }
                let startTime = dateFromString(dateStr: row[2] as? String)
                let endTime = dateFromString(dateStr: row[3] as? String)
                let newUsage = Usage(startTime: startTime, endTime: endTime, totalTime: totalTime, appName: appName, device: deviceId)
                modelContext.insert(newUsage)
            }
        }
        //try modelContext.save()
    }
    
    func clearData() async throws {
        try modelContext.delete(model: Usage.self)
    }
    
    //MARK: - Date Converter
    
    private let dateFormatter = DateFormatter()
    
    private func dateFromString(dateStr: String?) -> Date? {
        if dateStr != nil {
            return dateFormatter.date(from: dateStr!)
        } else {
            return nil
        }
    }
    
}
