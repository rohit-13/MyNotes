//
//  KeyChainHelper.swift
//  MyNotes
//
//  Created by Rohit Kumar on 09/07/23.
//

import Foundation

class KeychainHelper {
    static let shared = KeychainHelper()
    private init() {}
    
    private func save(data: Data, service: String, account: String) {
        let query = [
            kSecValueData: data,
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account,
        ] as CFDictionary
        
        let status = SecItemAdd(query, nil)
        if status != errSecSuccess {
            print("Error: \(status)")
        }
        if status == errSecDuplicateItem {
            let query = [
                kSecAttrService: service,
                kSecAttrAccount: account,
                kSecClass: kSecClassGenericPassword,
            ] as CFDictionary
            
            let attributesToUpdate = [kSecValueData: data] as CFDictionary
            SecItemUpdate(query, attributesToUpdate)
        }
    }
    
    private func read(service: String, account: String) -> Data? {
        let query = [
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword,
            kSecReturnData: true
        ] as CFDictionary
        
        var itemCopy: AnyObject?
        let status = SecItemCopyMatching(query, &itemCopy)
        
        if status == errSecItemNotFound {
            print("Error: ItemNotFound")
            return nil
        }
        if status != errSecSuccess {
            print("Error: UnexpectedError")
            return nil
        }
        let password = itemCopy as? Data
        return password
    }
    
    func checkPassword(password: String) -> Bool {
        if let data = read(service: "password-token", account: "MyNotes"), let passwordToken = String(data: data, encoding: .utf8) {
            return passwordToken == password
        }
        return false
    }
    
    func savePassword(password: String) {
        let data = Data(password.utf8)
        KeychainHelper.shared.save(data: data, service: "password-token", account: "MyNotes")
    }
    
    func checkKeyChain() -> Bool {
        return read(service: "password-token", account: "MyNotes") != nil
    }
}
