//
//  FirstScreenViewModel.swift
//  Carnage
//
//  Created by Jonikorjk on 28.06.2024.
//

import Foundation
import Speech
import Web3
import UIKit

class FirstScreenViewModel: ObservableObject {
    @Published private(set) var recognizedText = ""
       
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ru-RU"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    private let client: ClientProtocol
    
    init(client: ClientProtocol) {
        self.client = client
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
        case "0":
            break
        case "1":
            print("create acc")
            let response = try await client.createAccount(privateKey: "")
            guard let address = response.data?.attributes.address, let txhashes = response.data?.attributes.txHashes else {
                print("failed to create acc")
                return
            }
            
            while(true) {
                let resp1 = try? await client.listenTx(txHash: txhashes[0], txType: "1")
                let resp2 = try? await client.listenTx(txHash: txhashes[1], txType: "1")
                
                guard let isSuccess1 = resp1?.data?.attributes.isSuccess, let isSuccess2 = resp2?.data?.attributes.isSuccess else {
                    print("create acc: not found tx, trying again...")
                    continue
                }
                
                if isSuccess1 && isSuccess2 {
                    AccountManager.shared.setAccount(address: address)
                    DispatchQueue.main.async { self.onGameScreen() }
                    print("success account created")
                    break
                }
                
                try await Task.sleep(nanoseconds: 3000000000)
            }
            
//        case "2":
//            print("send token")
//            _ = try await client.sendToken(amount: "0.0001", sender: AccountManager.shared.getAccount(), contract: "", destinationAddress: "")
//        case "3":
//            print("attack country")
//             = try await client.attackCountry(sender: AccountManager.shared.getAccount())
        default:
            print("not found")
            return
        }
        
    }
    
//    func createAccount() {
//        do {
//            let privateKey = try EthereumPrivateKey()
//            print(privateKey.hex())
//            Task {
//                let response = try await client.createAccount(privateKey: "")
//                
//            }
//        } catch {
//            print(error)
//        }
//    }
    
//    func sendToken(amount: String, sender: String, contract: String, destinationAddress: String) {
//        Task {
//            let response = try await client.sendToken(
//                amount: amount,
//                sender: sender,
//                contract: contract,
//                destinationAddress: destinationAddress
//            )
//            print(response)
//        }
//    }
//    
    func onGameScreen() {
        AppDelegate.orientationLock = UIInterfaceOrientationMask.landscapeLeft
        UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
        UINavigationController.attemptRotationToDeviceOrientation()
        NavigationManager.shared.pushView(SecondScreenConfigurator.configure())
    }
}
