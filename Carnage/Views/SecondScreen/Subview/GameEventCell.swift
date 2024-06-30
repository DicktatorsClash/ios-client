//
//  EventCell.swift
//  Carnage
//
//  Created by Jonikorjk on 30.06.2024.
//

import SwiftUI

struct GameEventCell: View {
    let attackResult: String
    let resultToken: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Rectangle().frame(height: 1)
            Text("Attack")
            Text("Attack result:")
                .lineLimit(1)
            
            Text(attackResult)
                .lineLimit(1)
            
            Text("Result token:")
                .lineLimit(1)
            Text(resultToken)
                .lineLimit(1)
        }
    }
}

#Preview {
    GameEventCell(attackResult: "12", resultToken: "12")
}
