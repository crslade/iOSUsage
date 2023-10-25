//
//  UploadManager.swift
//  iOSUsage
//
//  Created by Christopher Slade on 10/21/23.
//

import Foundation

actor UploadManager {
    //MARK: - Upload to API
    static let shared = UploadManager()
    
    struct DefaultsKeys {
        static let uploadURIKey = "UploadURIKey"
        static let participantIDKey = "ParticipantIDKey"
    }
    
    @MainActor
    var uploadURI: String? {
        get {
            UserDefaults.standard.string(forKey: DefaultsKeys.uploadURIKey)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: DefaultsKeys.uploadURIKey)
        }
    }
    
    @MainActor
    var participantID: String? {
        get {
            UserDefaults.standard.string(forKey: DefaultsKeys.participantIDKey)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: DefaultsKeys.participantIDKey)
        }
    }
    
    func readUploadSettings(from fileURL: URL) async throws {
        let credentials = try String(contentsOf: fileURL, encoding: .utf8).split(separator: /,/)
        if credentials.count == 1 {
            await setSettings(uploadURI: String(credentials[0]))
        } else if credentials.count == 2 {
            await setSettings(uploadURI: String(credentials[1]), participantID: String(credentials[0]))
            print("Credentials Set")
        } else {
            throw UploadManagerError.unexpectedData
        }
    }
    
    func uploadData() async throws {
        guard let uploadURI = await uploadURI, let participantID = await participantID else {
            throw UploadManagerError.noData
        }
        print("Uploading to \(uploadURI) for \(participantID)")
    }
    
    @MainActor
    func clearSettings() {
        participantID = nil
        uploadURI = nil
    }
    
    @MainActor
    private func setSettings(uploadURI: String, participantID: String? = nil) {
        self.uploadURI = uploadURI
        if participantID != nil {
            self.participantID = participantID
        }
        self.participantID = participantID
    }
    
    enum UploadManagerError: Error {
        case noData
        case unexpectedData
    }
}
