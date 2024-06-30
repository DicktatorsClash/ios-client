//
//  Client.swift
//  Carnage
//
//  Created by Jonikorjk on 28.06.2024.
//

import Foundation
import OpenAPIClient

enum ClientErrors: Error {
    case badRequest
    case conflict
    case serverError
    case unathorized
    case notFound
    case largeData
    case notAllowed
    case unknowned

    init(statusCode: Int) {
        switch statusCode {
        case 413:
            self = .largeData
        case 400:
            self = .badRequest
        case 401:
            self = .unathorized
        case 404:
            self = .notFound
        case 405:
            self = .notAllowed
        case 409:
            self = .conflict
        case 500:
            self = .serverError
        default:
            self = .unknowned
        }
    }
}

protocol ClientProtocol {
    func createAccount(privateKey: String) async throws -> CreateUser200Response
    func sendToken(amount: String, sender: String, contract: String, destinationAddress: String) async throws -> SendToken200Response
    func sendText(text: String) async throws -> CallModel200Response
    func attackCountry(sender: String) async throws -> AttackCountry200Response
    func listenTx(txHash: String, txType: String) async throws -> TxResult200Response
    func approveAttack(sender: String) async throws -> ApproveSpending200Response
}

let address = "0xAE0D0F54863a6c35af2D2f9113282F5781F954A5"

class Client: ClientProtocol {
    
//    func swapTokens() {
//        TokensAPI.swapTokens { data, error in
//
//        }
//    }
    
    func approveAttack(sender: String) async throws -> ApproveSpending200Response {
        let data = AttackCountryRequestData(sender: sender)
        let request = AttackCountryRequest(data: data)
        return try await withUnsafeThrowingContinuation { continuation in
            TokensAPI.approveSpending(attackCountryRequest: request) { data, error in
                if let data = data {
                    continuation.resume(returning: data)
                }
                
                if let error = error {
                    self.handleClientError(error: error, continuation: continuation)
                }
            }
        }
    }
    
    func listenTx(txHash: String, txType: String) async throws -> TxResult200Response {
        let request = TxResultRequest(data: .init(txHash: txHash, txType: txType))
        
        return try await withUnsafeThrowingContinuation { continuation in
            TxAPI.txResult(txResultRequest: request) { data, error in
                if let data = data {
                    continuation.resume(returning: data)
                }
                
                if let error = error {
                    self.handleClientError(error: error, continuation: continuation)
                }
            }
        }
    }
    
    func createAccount(privateKey: String) async throws -> CreateUser200Response {
        let data = CreateUserRequestData(privateKey: privateKey)
        let createUserRequest = CreateUserRequest(data: data)
        
        return try await withUnsafeThrowingContinuation { continuation in
            UsersAPI.createUser(createUserRequest: createUserRequest) { data, error in
                if let data = data {
                    continuation.resume(returning: data)
                }
                
                if let error = error {
                    self.handleClientError(error: error, continuation: continuation)
                }
            }
        }
    }
    
    func sendText(text: String) async throws -> CallModel200Response {
        return try await withUnsafeThrowingContinuation { continuation in
            ModelAPI.callModel(callModelRequest: .init(data: .init(input: text))) { data, error in
                if let data = data {
                    continuation.resume(returning: data)
                }
                
                if let error = error {
                    self.handleClientError(error: error, continuation: continuation)
                }
            }
        }
    }
    
    func attackCountry(sender: String) async throws -> AttackCountry200Response {
        let data = AttackCountryRequestData(sender: sender)
        let request = AttackCountryRequest(data: data)
        return try await withUnsafeThrowingContinuation { continuation in
            CombatAPI.attackCountry(attackCountryRequest: request) { data, error in
                if let data = data {
                    continuation.resume(returning: data)
                }
                
                if let error = error {
                    self.handleClientError(error: error, continuation: continuation)
                }
            }
        }
    }
    
    func sendToken(amount: String, sender: String, contract: String, destinationAddress: String) async throws -> SendToken200Response {
        let data = SendTokenRequestData(amount: amount, sender: sender, contract: contract, destinationAddress: destinationAddress)
        let request = SendTokenRequest(data: data)
        
        return try await withUnsafeThrowingContinuation { continuation in
            TokensAPI.sendToken(sendTokenRequest: request) { data, error in
                if let data = data {
                    continuation.resume(returning: data)
                }
                
                if let error = error {
                    self.handleClientError(error: error, continuation: continuation)
                }
            }
        }
    }
    
    private func handleClientError<T>(
        error: Error,
        continuation: UnsafeContinuation<T, Error>
    ) {
        if let errorResponse = error as? ErrorResponse {
            if case let .error(statusCode, _, _, err) = errorResponse {
                debugPrint("status code: \(statusCode), error: ", err)
                continuation.resume(throwing: ClientErrors(statusCode: statusCode))
                return
            }
        }

        continuation.resume(throwing: ClientErrors.unknowned)
    }
}
