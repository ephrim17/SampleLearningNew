//
//  ViewBuilders.swift
//  sample
//
//  Created by ephrim.daniel on 22/11/25.
//

import SwiftUI

@ViewBuilder
func makePopoverView(_ selectedCell: TableCell) -> some View {
    switch selectedCell.content {
    case .email(let string):
        Link(destination: URL(string: "mailto:\(string)")!) {
            HStack {
                Image(systemName: "square.and.pencil")
                Text(string)
            }
        }
    case .phone(let string):
        Link(destination: URL(string: "imessage:\(string)")!) {
            HStack {
                Image(systemName: "phone.fill")
                Text(string)
            }
        }
    case .text(let string):
        Text(string)
    }
}

@ViewBuilder
func makeAlert(_ text: String) -> some View {
    Text(text)
        .font(.callout)
        .padding(20)
        .background(Color.green.clipShape(.buttonBorder))
        .transition(.move(edge: .top))
        .frame(maxHeight: .infinity, alignment: .top)
}
