//
//  FirstScreenModel.swift
//  Carnage
//
//  Created by Jonikorjk on 28.06.2024.
//

import Foundation

final class Transfer: Identifiable {
    let txHash: String
    let amount: String
    let tokenAddress: String
    let addressTo: String
    let addressFrom: String
    
    init(
        txHash: String,
        amount: String,
        tokenAddress: String,
        addressTo: String,
        addressFrom: String
    ) {
        self.txHash = txHash
        self.amount = amount
        self.tokenAddress = tokenAddress
        self.addressTo = addressTo
        self.addressFrom = addressFrom
    }
}

final class User: Identifiable {
    let address: String
    
    init(address: String) {
        self.address = address
    }
}
