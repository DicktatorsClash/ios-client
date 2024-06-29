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
    func sendToken(amount: String, contract: String, destinationAddress: String) async throws -> SendToken200Response
}

class Client: ClientProtocol {
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
    
    func sendToken(amount: String, contract: String, destinationAddress: String) async throws -> SendToken200Response {
        let data = SendTokenRequestData(amount: amount, contract: contract, destinationAddress: destinationAddress)
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
