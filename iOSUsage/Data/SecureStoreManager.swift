//
//  SecureStoreManager.swift
//  iOSUsage
//
//  Created by Christopher Slade on 10/17/23.
//

import Foundation
import Security

actor SecureStoreManager {
    
    //MARK: - Secure Storage
    
    private struct KeyConstants {
        static let server = "dev.slades.iOSUsage.DynoPass"
        static let searchQuery: [String: Any] = [
            kSecClass as String: kSecClassInternetPassword,
            kSecAttrServer as String: KeyConstants.server,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnAttributes as String: true,
            kSecReturnData as String: true
        ]
    }
    
    func readAndStore(fileName: URL) async throws -> (dbName: String, clientID: String, secret: String){
        let credentials = try String(contentsOf: fileName, encoding: .utf8).split(separator: /,/)
        guard credentials.count == 3 else {
            throw KeychainError.unexpectedPasswordData
        }
        try delete()
        try store(dbName: String(credentials[0]), clientId: String(credentials[1]), secret: String(credentials[2]))
        return (String(credentials[0]), String(credentials[1]), String(credentials[2]))
    }
    
    private func store(dbName: String, clientId: String, secret: String) throws {
        let secretData = secret.data(using: .utf8)!
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassInternetPassword,
            kSecAttrAccount as String: clientId,
            kSecValueData as String: secretData,
            kSecAttrServer as String: KeyConstants.server,
            kSecAttrLabel as String: dbName
        ]
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw KeychainError.unhandledError(status: status)
        }
    }
    
    func retrive() throws -> (dbName: String, clientID: String, secret: String)? {
        let query = KeyConstants.searchQuery
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        if status == errSecItemNotFound {
            return nil
        }
        guard status == errSecSuccess else {
            throw KeychainError.unhandledError(status: status)
        }
        guard let exisitingItem = item as? [String: Any],
              let secretData = exisitingItem[kSecValueData as String] as? Data,
              let secret = String(data: secretData, encoding: .utf8),
              let clientId = exisitingItem[kSecAttrAccount as String] as? String,
              let dbName = exisitingItem[kSecAttrLabel as String] as? String else {
            throw KeychainError.unexpectedPasswordData
        }
        return (dbName, clientId, secret)
    }
    
    func delete() throws {
        let query = KeyConstants.searchQuery
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.unhandledError(status: status)
        }
    }
    
    enum KeychainError: Error {
        case noPassword
        case unexpectedPasswordData
        case unhandledError(status: OSStatus)
    }
    

    
}
