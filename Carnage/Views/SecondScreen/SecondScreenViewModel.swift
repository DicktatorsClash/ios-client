//
//  SecondScreenViewModel.swift
//  Carnage
//
//  Created by Jonikorjk on 29.06.2024.
//

import Foundation
import SpriteKit

class SecondScreenViewModel: ObservableObject {
    let scene: GameScene = {
        let scene = GameScene(fileNamed: "GameScene")!
        scene.scaleMode = .aspectFill
        return scene
    }()
    
    init() {
        bombEventListener()
    }
    
    func bombEventListener() {
        Task {
            while(true) {
                await scene.attack(.china)
//                await scene.attack(.ukraine)
                
                try await Task.sleep(nanoseconds: 3000000000)
            }
        }
    }
}
