//
//  ImagePlayGround.swift
//  sample
//
//  Created by ephrim.daniel on 01/12/25.
//

import SwiftUI
import PhotosUI
import ImagePlayground

#Preview {
    ImagePlayground()
}

struct ImagePlayground: View {
    
    @State private var avatarImage: Image?
    @State private var photosPickerItem: PhotosPickerItem?
    @Environment(\.supportsImagePlayground) var supportsImagePlayground
    @State private var isShowingImagePlayground : Bool = false
    
    @State private var conceptString : String = ""
    
    var body: some View {
        VStack(spacing: 32) {
            HStack(spacing: 20) {
                PhotosPicker(selection: $photosPickerItem, matching: .not(.screenshots)) {
                    (avatarImage ?? Image(systemName: "person.circle.fill"))
                        .resizable()
                        .foregroundStyle(.mint)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .clipShape(.circle)
                }
                
                VStack(alignment: .leading) {
                    Text("Ephrim")
                        .font(.title.bold())
                    
                    Text("iOS Developer").bold()
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
            }
            
            if supportsImagePlayground {
                TextField("Enter Avatar Description", text: $conceptString)
                    .font(.title3)
                    .padding()
                    .background(.quaternary, in: .rect(cornerRadius: 16, style: .circular))
                
                Button("generate image", systemImage: "Sparkles"){
                    isShowingImagePlayground = true
                }
                .padding()
                .foregroundStyle(.mint)
                .fontWeight(.bold)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(.mint, lineWidth: 3)
                )
            }
            
            Spacer()
        }
        .padding(30)
        .onChange(of: photosPickerItem) { _, _ in
            Task {
                if let photosPickerItem, let data = try? await photosPickerItem.loadTransferable(type: Data.self) {
                    if let image = UIImage(data: data) { avatarImage = Image(uiImage: image) }
                }
            }
        }
        .imagePlaygroundSheet(
            isPresented: $isShowingImagePlayground,
            concept: "Sun Glasses in the beach") { url in
                if let data = try? Data(contentsOf: url) {
                    if let image = UIImage(data: data) {
                        avatarImage = Image(uiImage: image)
                    }
                }
            }
    }
}


