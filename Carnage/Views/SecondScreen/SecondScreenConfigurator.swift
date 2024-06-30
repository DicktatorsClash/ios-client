//
//  FirstScreenConfigurator.swift
//  Carnage
//
//  Created by Jonikorjk on 29.06.2024.
//

import Foundation
import SwiftUI

class SecondScreenConfigurator {
    static func configure() -> some View {
        let viewModel = SecondScreenViewModel(client: Client())
        return SecondScreenView(viewModel: viewModel)
    }
}
