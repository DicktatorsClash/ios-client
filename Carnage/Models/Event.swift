//
//  AttackEvent.swift
//  Carnage
//
//  Created by Jonikorjk on 30.06.2024.
//

import Foundation

struct AttackEvent {
    var txHash: String
    var result: String
    var tokensAmount: String
}

final class TransferEvent: Identifiable {
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
