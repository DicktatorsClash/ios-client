//
//  AccountManager.swift
//  Carnage
//
//  Created by Jonikorjk on 30.06.2024.
//

import Foundation

class AccountManager {
    private let defaults = UserDefaults()
    
    static let shared = AccountManager()
    
    func setAccount(address: String) {
        defaults.setValue(address, forKey: "address")
    }
    
    func getAccount() -> String {
        defaults.string(forKey: "address") ?? ""
    }
}
