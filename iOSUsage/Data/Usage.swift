//
//  Usage.swift
//  iOSUsage
//
//  Created by Christopher Slade on 10/17/23.
//

import Foundation
import SwiftData

@Model
final class Usage {
    @Attribute(.unique) var id: String
    var startTime: Date?
    var endTime: Date?
    var totalTime: Int?
    var appName: String
    var device: String?
    
    init(id: String = UUID().uuidString, startTime: Date?, endTime: Date?, totalTime: Int?, appName: String, device: String?) {
        self.id = id
        self.startTime = startTime
        self.endTime = endTime
        self.totalTime = totalTime
        self.appName = appName
        self.device = device
    }
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .short
        return formatter
    }()
    
    var startTimeStr: String {
        if startTime != nil {
            return Usage.dateFormatter.string(from: startTime!)
        } else {
            return "none"
        }
    }
    
    var endTimeStr: String {
        if startTime != nil {
            return Usage.dateFormatter.string(from: endTime!)
        } else {
            return "none"
        }
    }
    
    var totalTimeStr: String {
        if totalTime != nil {
            return "\(totalTime!)"
        } else {
            return "Missing"
        }
    }
    
    func toDictionary(using formatter: DateFormatter, with participantID: String) -> [String: String] {
        let formattedStartTime = self.startTime != nil ? formatter.string(from: self.startTime!) : "None"
        let formattedEndTime = self.endTime != nil ? formatter.string(from: self.endTime!) : "None"
        var dict = [String: String]()
        dict["participantID"] = participantID
        dict["startTime"] = formattedStartTime
        dict["endTime"] = formattedEndTime
        dict["totalTime"] = totalTimeStr
        dict["appName"] = appName
        dict["device"] = device
        return dict
    }
}
