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
        let viewModel = SecondScreenViewModel()
        return SecondScreenView(viewModel: viewModel)
    }
}
