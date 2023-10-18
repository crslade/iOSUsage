//
//  SecureStoreManager.swift
//  iOSUsage
//
//  Created by Christopher Slade on 10/17/23.
//

import Foundation
import Security

actor SecureStoreManager {
    
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
    
    func store(clientId: String, secret: String) throws {
        let secretData = secret.data(using: .utf8)!
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassInternetPassword,
            kSecAttrAccount as String: clientId,
            kSecValueData as String: secretData,
            kSecAttrServer as String: KeyConstants.server
        ]
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            print(SecCopyErrorMessageString(status, nil) ?? "swd")
            throw KeychainError.unhandledError(status: status)
        }
    }
    
    func retriveSecret() throws -> (clientID: String, secret: String) {
        let query = KeyConstants.searchQuery
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status != errSecItemNotFound else {
            print(SecCopyErrorMessageString(status, nil) ?? "swd2")
            throw KeychainError.noPassword
        }
        guard status == errSecSuccess else {
            print(SecCopyErrorMessageString(status, nil) ?? "swd3")
            throw KeychainError.unhandledError(status: status)
        }
        guard let exisitingItem = item as? [String: Any],
              let secretData = exisitingItem[kSecValueData as String] as? Data,
              let secret = String(data: secretData, encoding: .utf8),
              let clientId = exisitingItem[kSecAttrAccount as String] as? String else {
            print(SecCopyErrorMessageString(status, nil) ?? "swd4")
            throw KeychainError.unexpectedPasswordData
        }
        return (clientId, secret)
    }
    
    func deleteSecret() throws {
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
