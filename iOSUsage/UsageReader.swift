//
//  UsageReader.swift
//  iOSUsage
//
//  Created by Christopher Slade on 10/12/23.
//

import Foundation
import SQLite

struct UsageReader {

    private(set) var data: [Any]?
    private(set) var devices: Set<String>?
    
    mutating func readData(folderURL: URL) async throws {
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
        
        devices = Set<String>()
        
        for row in try db.prepare(query) {
            //print(row)
            if let deviceId = row[6] as? String {
                print(deviceId)
                devices!.insert(deviceId)
            }
        }
    }
    
}
