//
//  PROduceitemView.swift
//  sample
//
//  Created by ephrim.daniel on 15/07/25.
//

import SwiftUI

struct PROduceitemView: View {
    var PROitem : PROduceModel
    
    var body: some View {
        VStack (){
            AsyncImage(url: URL(string: PROitem.image)) { image in
                image.resizable()
            } placeholder: {
                Color.gray
            }
            .frame(width: 128, height: 128)
            .clipShape(.rect(cornerRadius: 20))
            Text(PROitem.name)
                .fontWeight(.medium)
        }
    }
}

