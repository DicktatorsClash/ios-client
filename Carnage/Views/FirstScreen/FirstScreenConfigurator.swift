//
//  Configurator.swift
//  Carnage
//
//  Created by Jonikorjk on 28.06.2024.
//

import Foundation
import SwiftUI

class FirstScreenConfigurator {
    static func configure() -> some View {
        let viewModel = FirstScreenViewModel(client: Client())
        return FirstScreen(viewModel: viewModel)
    }
}
