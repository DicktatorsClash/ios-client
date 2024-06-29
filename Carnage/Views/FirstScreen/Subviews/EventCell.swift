//
//  EventCell.swift
//  Carnage
//
//  Created by Jonikorjk on 28.06.2024.
//

import SwiftUI

struct EventCell: View {
    let amount: String
    let address: String
    
    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle().cornerRadius(8.0)
            VStack(alignment: .leading) {
                Text("Address: \(address)")
                    .foregroundStyle(.white)
                    .font(.footnote)
                
                Text("Amount: \(amount)")
                    .foregroundStyle(.white)
                    .font(.footnote)
            }
            .padding(.all, 8)
        }
        .padding(.horizontal, 16)
        .frame(height: 100)
    }
}

#Preview {
    EventCell(amount: "10000", address: "0xfffffffffffffff")
}
