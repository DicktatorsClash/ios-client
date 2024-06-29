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
                VStack {
                    Text("Hello, World!")
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
    SecondScreenView(viewModel: SecondScreenViewModel())
}
