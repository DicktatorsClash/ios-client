//
//  SecondScreenView.swift
//  Carnage
//
//  Created by Jonikorjk on 29.06.2024.
//

import SwiftUI
import SpriteKit

struct SecondScreenView: View {
    @StateObject var viewModel: SecondScreenViewModel

    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(viewModel.recognizedText)
                        .lineLimit(1)
                    
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
                    
                    ScrollView {
                        VStack(alignment: .leading) {
                            ForEach(viewModel.gameEvents) { event in
                                GameEventCell(attackResult: event.attackResult, resultToken: event.resultToken)
                            }
                        }
                        .frame(width: 150)
                    }
                }
                SpriteView(scene: viewModel.scene)
                    .ignoresSafeArea()
                    .scaledToFill()
            }
        }
        .onDisappear {
            AppDelegate.orientationLock = UIInterfaceOrientationMask.portrait
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
            UINavigationController.attemptRotationToDeviceOrientation()
        }
    }
}

#Preview {
    SecondScreenView(viewModel: SecondScreenViewModel(client: Client()))
}
