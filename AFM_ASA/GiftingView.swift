//
//  GiftingView.swift
//  sample
//
//  Created by ephrim.daniel on 01/12/25.
//

import SwiftUI
import FoundationModels

struct GiftingView: View {
    var onSave: (String) -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var personalMessage: String = ""
    @State private var senderName: String = ""
    @State private var selectedDate = Date()
    @State private var showMessageKeyboard = false
    @State private var tempMessage: String = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGray6)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 0) {
                        // Animated emojis background with title
                        VStack(spacing: 20) {
                            HStack(spacing: 40) {
                                VStack(spacing: 40) {
                                    Text("🎉")
                                        .font(.system(size: 32))
                                    Text("❤️")
                                        .font(.system(size: 32))
                                }
                                
                                VStack(spacing: 20) {
                                    Text("🍎")
                                        .font(.system(size: 32))
                                    Text("🎊")
                                        .font(.system(size: 32))
                                }
                                
                                VStack(spacing: 40) {
                                    Text("⭐")
                                        .font(.system(size: 32))
                                    Text("🌿")
                                        .font(.system(size: 32))
                                }
                            }
                            .opacity(0.3)
                            .frame(height: 150)
                            
                            VStack(spacing: 12) {
                                Text("Create a")
                                    .font(.system(size: 48, weight: .bold))
                                    .foregroundColor(.black)
                                
                                Text("memorable")
                                    .font(.system(size: 48, weight: .bold))
                                    .foregroundColor(.black)
                                
                                Text("moment.")
                                    .font(.system(size: 48, weight: .bold))
                                    .foregroundColor(.black)
                            }
                            .frame(maxWidth: .infinity, alignment: .center)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 24)
                        
                        // Description
                        VStack(spacing: 12) {
                            Text("Add a personal touch to their gift with a fun animated message that could only come from you. You'll schedule its arrival at Checkout. We'll send the link right to their inbox.")
                                .font(.system(size: 15))
                                .foregroundColor(.black.opacity(0.7))
                                .lineSpacing(2)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 32)
                        
                        // Personal Message Input
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Include a personalised gift message")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.black)
                                Spacer()
                                Image(systemName: "apple.image.playground.fill")
                                    .font(.system(size: 32))
                                    .foregroundColor(.black)
                            }.onTapGesture {
                                tempMessage = personalMessage
                                showMessageKeyboard = true
                            }
                            
                            
                            ZStack(alignment: .topLeading) {
                                AutoSizingTextEditor(text: $personalMessage, font: .system(size: 16), padding: 12, minHeight: 120)
                                
                                if personalMessage.isEmpty {
                                    Text("Optional")
                                        .font(.system(size: 16))
                                        .foregroundColor(.gray)
                                        .padding(16)
                                }
                            }
                            
                            HStack {
                                Spacer()
                                Text("\(personalMessage.count)/90")
                                    .font(.system(size: 13))
                                    .foregroundColor(.gray)
                            }
                            .padding(.horizontal, 4)
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 24)
                        
                        // Sender Name Input
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Let them know who it's from")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.black)
                            
                            TextField("Enter your name", text: $senderName)
                                .font(.system(size: 16))
                                .padding(12)
                                .background(Color.white)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                )
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 32)
                    }
                }
            }
            .preferredColorScheme(.light)
            .interactiveDismissDisabled(true)
            
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Text("Save")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                        .padding(8)
                        .background(Color.blue)
                        .clipShape(Capsule())
                        .onTapGesture {
                            onSave(personalMessage)
                            dismiss()
                        }
                    .accessibilityLabel("Check Out")
                }
            }
        }
        .sheet(isPresented: $showMessageKeyboard) {
            //AppleIntelligenceAnimatorView {
                MessageKeyboardOverlay(
                    isPresented: $showMessageKeyboard,
                    message: $tempMessage,
                    onSave: { savedMessage in
                    personalMessage = savedMessage
                    showMessageKeyboard = false
                })
           // }
        }
    }
}

// MARK: - AutoSizingTextEditor
struct AutoSizingTextEditor: View {
    @Binding var text: String
    var font: Font = .body
    var padding: CGFloat = 8
    var minHeight: CGFloat = 44
    @State private var dynamicHeight: CGFloat = 0

    var body: some View {
        ZStack(alignment: .topLeading) {
            // Hidden mirror to measure content height
            Text(text.isEmpty ? " " : text + "\n")
                .font(font)
                .foregroundColor(.clear)
                .padding(padding)
                .background(
                    GeometryReader { proxy in
                        Color.clear
                            .onAppear { dynamicHeight = proxy.size.height }
                            .onChange(of: text) { oldValue, newValue in
                                dynamicHeight = proxy.size.height
                            }
                    }
                )

            TextEditor(text: $text)
                .font(font)
                .frame(height: max(minHeight, dynamicHeight))
                .background(Color.white)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
                .padding(.horizontal, 0)
                .padding(.vertical, 0)
                .padding(padding)
        }
    }
}

struct MessageKeyboardOverlay: View {
    @Binding var isPresented: Bool
    @Binding var message: String
    var onSave: (String) -> Void
    @State private var isLoading: Bool = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // Header with Done button
                HStack {
                    Spacer()
                    Text("Done")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.gray)
                        .padding(.horizontal, 10)
                        .padding(8)
                        //.background(Color.blue)
                        .clipShape(Capsule())
                        .onTapGesture {
                            Task {
                                isLoading = true
                                do {
                                    let result = try await generatePersonalisedMessage(inputText: message)
                                    message = result
                                    onSave(message)
                                } catch {
                                    print("Failed to generate personalised message:", error)
                                }
                                isLoading = false
                            }
                        }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                
                // Search-style text field
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white)
                    
                    VStack {
                        
                            //.frame(height: 400)
                        HStack(spacing: -2) {
                            AppleIntelligenceAnimatorView {
                                Image(systemName: "apple.intelligence")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 33, height: 33)
                                    .foregroundColor(.gray)
                            }
                            
                            AutoSizingTextEditor(text: $message, font: .system(size: 16), padding: 12, minHeight: 20)
                        }
                        // Character count
                        HStack {
                            if message.count != 0 {
                                Spacer()
                                Button(action: {
                                    message = ""
                                }) {
                                    HStack(spacing: 6) {
                                        Image(systemName: "xmark.circle.fill")
                                            .font(.system(size: 16))
                                        Text("Clear")
                                            .font(.system(size: 14, weight: .semibold))
                                    }
                                    .foregroundColor(.gray)
                                }
                            }
                            
                        }
                        
                        GiftingMessageSuggestor(suggestedString: $message)
                       Spacer()
                    }
                    
                    .padding(.horizontal, 12)
                }
                //.frame(height: 44)
                .padding(16)
                
                Spacer()
            }
            .allowsHitTesting(!isLoading)
            
            if isLoading {
                Color.black.opacity(0.2)
                    .ignoresSafeArea()
                ProgressView("Generating…")
                    .progressViewStyle(.circular)
                    .tint(.gray)
                    .padding(24)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color(.systemBackground))
                            .shadow(radius: 10)
                    )
            }
        }
        .preferredColorScheme(.light)
        //.background(Color(.systemGray6))
    }
    
    func generatePersonalisedMessage(inputText: String) async throws -> String {
        
        var session = LanguageModelSession()
        let instructions = """
       You are a Greeting message specialist, your job is to give happy greeting messages.
       """
        session = LanguageModelSession(
            instructions: instructions
        )
        
        let prompt = inputText
        
        do {
            let response =  try await session.respond(to: prompt)
            return response.content
        } catch {
            print("LanguageModelSession respond failed:", error)
            throw error
        }
    }
}

// MARK: - Preview
#Preview("MessageKeyboardOverlay") {
    @Previewable
    @State var message = "Hello!HelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHellooHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHel"
    @Previewable
    @State var isPresented = true
    
    return MessageKeyboardOverlay(
        isPresented: $isPresented,
        message: $message,
        onSave: { _ in }
    )
}

