//
//  FirstScreen.swift
//  Carnage
//
//  Created by Jonikorjk on 28.06.2024.
//

import SwiftUI
import SpriteKit

struct FirstScreen: View {
    @StateObject var viewModel: FirstScreenViewModel
        
    var body: some View {
        
        VStack(alignment: .leading, spacing: 12) {
            Text(viewModel.recognizedText)
            
            Button {
                viewModel.startVoiceRecognize()
            } label: {
                Image(systemName: "mic.fill")
                Text("Start voice recording")
            }
            
            Button {
                viewModel.stopRecognition()
            } label: {
                Text("Finish voice recording")
            }
            
//            Button {
//                viewModel.createAccount()
//            } label: {
//                Text("Create accounnt request")
//            }
//
//            Button {
//                viewModel.sendToken(amount: "1", sender: "1", contract: "1", destinationAddress: "1")
//            } label: {
//                Text("Send token")
//            }
//            
//            Button {
//                viewModel.onGameScreen()
//            } label: {
//                Text("Start game")
//            }            
        }
    }
}

#Preview {
    FirstScreen(viewModel: FirstScreenViewModel(client: Client()))
}
