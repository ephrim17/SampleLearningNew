import SwiftUI
import PhotosUI
import ImagePlayground

struct AirTagEngravingView: View {
    @Binding var isPresented: Bool
    @Binding var engraving: String

    @Environment(\.dismiss) private var dismiss
    
    @State private var avatarImage: Image?
    @State private var photosPickerItem: PhotosPickerItem?
    @Environment(\.supportsImagePlayground) var supportsImagePlayground
    @State private var isShowingImagePlayground : Bool = false
    
    @State private var conceptString : String = ""

    var body: some View {
        ZStack {
            Color.black.opacity(0.95)
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    HStack {
                        Button(action: {
                            isPresented = false
                        }) {
                            ZStack {
                                Circle()
                                    .fill(Color(.systemGray6).opacity(0.15))
                                    .frame(width: 56, height: 56)
                                Image(systemName: "xmark")
                                    .foregroundColor(.white)
                                    .font(.system(size: 20, weight: .semibold))
                            }
                        }
                        Spacer()
                        Button(action: {
                            // Save engraving and dismiss
                            isPresented = false
                        }) {
                            Text("Save")
                                .font(.system(size: 16, weight: .semibold))
                                .padding(.horizontal, 18)
                                .padding(.vertical, 8)
                                .background(Color(.systemGray6).opacity(0.12))
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
                    
                    Spacer().frame(height: 12)
                    
                    // Large representation of AirTag
                    Image("airtag")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 420, height: 420)
                        .padding(.top, 8)
                    
                    Spacer()
                    
                    Text("Add emoji with a tap. Type in initials or numbers. You can even combine them.")
                        .font(.system(size: 14))
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(.systemGray3))
                        .padding(.horizontal, 36)
                    
                    // Engraving input
                    VStack(spacing: 8) {
                        TextField("YOUR ENGRAVING", text: $engraving)
                            .padding(14)
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(Color(.systemGray3).opacity(0.6), lineWidth: 1)
                                    .background(Color.clear)
                            )
                            .foregroundColor(.white)
                            .disableAutocorrection(true)
                    }
                    .padding(.horizontal, 20)
                    
                    if supportsImagePlayground {
                        HStack(spacing: 2) {
                            Text("Add Image from Image Playgorund.")
                                .font(.system(size: 16))
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color(.systemGray))
                            
                            Image(systemName: "apple.image.playground.fill")
                                .font(.system(size: 32))
                                .foregroundColor(.gray)
                        }
                        .onTapGesture {
                            isShowingImagePlayground = true
                        }
                    }
                    Spacer()
                }
            }
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
}
