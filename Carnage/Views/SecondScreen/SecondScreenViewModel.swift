//
//  SecondScreenViewModel.swift
//  Carnage
//
//  Created by Jonikorjk on 29.06.2024.
//

import Foundation
import SpriteKit
import Speech

class AttackGameEvent: Identifiable {
    let attackResult: String
    let resultToken: String
    
    init(attackResult: String, resultToken: String) {
        self.attackResult = attackResult
        self.resultToken = resultToken
    }
}

class SecondScreenViewModel: ObservableObject {
    @Published private(set) var recognizedText = ""
    @Published var gameEvents: [AttackGameEvent] = []
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ru-RU"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()

    let scene: GameScene = {
        let scene = GameScene(fileNamed: "GameScene")!
        scene.scaleMode = .aspectFill
        return scene
    }()
    
    private let client: Client
    
    init(client: Client) {
        self.client = client
//        bombEventListener()
    }
    
    func bombEventListener() {
        Task {
            while(true) {
                await scene.attack(.china)
                
                try await Task.sleep(nanoseconds: 3000000000)
            }
        }
    }
    
    func startVoiceRecognize() {
        self.recognizedText = "Say something..."
        SFSpeechRecognizer.requestAuthorization { status in
            self.startRecognition()
        }
    }
    
    func startRecognition() {
        do {
            recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
            guard let recognitionRequest = recognitionRequest else { return }
            
            recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { result, error in
                if let result = result {
                    self.recognizedText = result.bestTranscription.formattedString
                }
            }
            
            let recordingFormat = audioEngine.inputNode.outputFormat(forBus: 0)
            audioEngine.inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
                recognitionRequest.append(buffer)
            }
            
            audioEngine.prepare()
            try audioEngine.start()
        }
        catch {
            print(error)
        }
    }
    
    func stopRecognition() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        
        recognitionRequest?.endAudio()
        recognitionRequest = nil
        
        recognitionTask?.cancel()
        recognitionTask = nil
        
        Task {
            try await sendTextToAi(text: recognizedText)
        }
        
        recognizedText = "Stopped"
    }

    func sendTextToAi(text: String) async throws {
        let response = try await client.sendText(text: text)
        guard let result = response.data?.attributes.result else {
            print("not found data")
            return
        }
        
        switch result {
//        case "0":
//            print("not found 1")
//            break
//        case "1":
//            _ = try await client.createAccount(privateKey: "")
//        case "2":
//            _ = try await client.sendToken(amount: "0.0001", sender: AccountManager.shared.getAccount(), contract: "", destinationAddress: "")
        case "3":
            print("bomb event second screen")
            let approveResponse = try await client.approveAttack(sender: AccountManager.shared.getAccount())
            guard let txHash = approveResponse.data?.attributes.txHash else {
                print("failed to approve attack")
                return
            }
            
            while(true) {
                let response = try? await client.listenTx(txHash: txHash, txType: "1")
                guard let isSuccess = response?.data?.attributes.isSuccess else {
                    print("failed to listen approve")
                    continue
                }
                
                if isSuccess {
                    break
                }
                
                try await Task.sleep(nanoseconds: 5000000000)
            }
            
            let response = try await client.attackCountry(sender: AccountManager.shared.getAccount())
            guard let txhash = response.data?.attributes.txHash else {
                print("not found tx hash")
                return
            }
            
            while(true) {
                let response = try await client.listenTx(txHash: txhash, txType: "3")
                guard let isSuccess = response.data?.attributes.isSuccess else {
                    print("not found success")
                    continue
                }
                
                if isSuccess {
                    if let attackResult = response.data?.attributes.attackResult, let resultToken = response.data?.attributes.attackTokens {
                        DispatchQueue.main.async {
                            self.gameEvents.append(AttackGameEvent(attackResult: attackResult, resultToken: resultToken))
                        }
                    }

                    let result = response.data?.attributes.attackResult ?? "0"
                    if result == "1" {
                        await scene.attack(.ukraine)
                    } else {
                        await scene.attack(.china)
                    }
                    break
                }
                
                try await Task.sleep(nanoseconds: 5000000000)
            }
        default:
            print("not found")
            return
        }
        
        
        
    }
}
