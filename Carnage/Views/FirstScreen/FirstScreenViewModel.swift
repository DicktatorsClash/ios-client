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
        recognizedText = "Stopped"

        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        
        recognitionRequest?.endAudio()
        recognitionRequest = nil
        
        recognitionTask?.cancel()
        recognitionTask = nil
    }
    
    func createAccount() {
        do {
            let privateKey = try EthereumPrivateKey()
            print(privateKey.hex())
            Task {
                let response = try await client.createAccount(privateKey: privateKey.hex())
                print(response)
            }
        } catch {
            print(error)
        }
    }
    
    func sendToken(amount: String, contract: String, destinationAddress: String) {
        Task {
            let response = try await client.sendToken(
                amount: amount,
                contract: contract,
                destinationAddress: destinationAddress
            )
            print(response)
        }
    }
    
    func onGameScreen() {
        AppDelegate.orientationLock = UIInterfaceOrientationMask.landscapeRight
        UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
        UINavigationController.attemptRotationToDeviceOrientation()
        NavigationManager.shared.pushView(SecondScreenConfigurator.configure())
    }
}
