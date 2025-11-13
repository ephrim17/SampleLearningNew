//
//  ScannerAppHome.swift
//  sample
//
//  Created by ephrim.daniel on 13/11/25.
//

import SwiftUI

enum Route: Hashable {
    case scan
}


struct ScannerAppHome: View {
    
    @State private var path: [Route] = []
    
    
    var body: some View {
        NavigationView {
            ZStack {
                // Main card
                VStack(spacing: 0) {
                    // Top bar
                    HStack {
                        Spacer()
                        HStack(spacing: 12) {
                            Button(action: {}) {
                                Image(systemName: "person.circle")
                                    .font(.system(size: 24))
                                    .foregroundColor(.black)
                                
                                
                            }.clipShape(Capsule())
                            
                            ZStack(alignment: .topTrailing) {
                                Button(action: {}) {
                                    Image(systemName: "bell")
                                        .font(.system(size: 24))
                                        .foregroundColor(.black)
                                        .padding(12)
                                        .background(Color.white)
                                        .clipShape(Circle())
                                }
                                
                                Circle()
                                    .fill(Color.red)
                                    .frame(width: 20, height: 20)
                                    .overlay(
                                        Text("5")
                                            .font(.system(size: 11, weight: .bold))
                                            .foregroundColor(.white)
                                    )
                                    .offset(x: 4, y: -4)
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 24)
                    
                    // Greeting text
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Hi Peter,")
                            .font(.system(size: 42, weight: .bold))
                        Text("How can I help")
                            .font(.system(size: 42, weight: .bold))
                        Text("you today?")
                            .font(.system(size: 42, weight: .bold))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 24)
                    
                    // Action buttons grid
                    VStack(spacing: 16) {
                        HStack(spacing: 16) {
                            NavigationLink(destination: DocumentContentView()) {
                                ActionButtonView(
                                    icon: "scanner",
                                    title: "Scan",
                                    backgroundColor: Color(red: 0.85, green: 0.95, blue: 1.0),
                                )
                            }
                            
                            
                            
                            .buttonStyle(.plain)
                            
                            ActionButtonView(
                                icon: "arrow.up.right.square",
                                title: "Results",
                                backgroundColor: Color(red: 0.85, green: 0.98, blue: 0.85),
                                
                            )
                        }
                        
                        HStack(spacing: 16) {
                            ActionButtonView(
                                icon: "sparkles",
                                title: "Ask AI",
                                backgroundColor: Color(red: 1.0, green: 0.98, blue: 0.8),
                                
                            )
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 32)
                    
                    
                    
                    Spacer()
                    HStack {
                        HStack(spacing: 0) {
                            Button(action: {}) {
                                Image(systemName: "questionmark.circle")
                                    .font(.system(size: 24))
                                    .foregroundColor(.black)
                                    .padding(12)
                                    .background(Color.white)
                                    .clipShape(Circle())
                            }
                        }
                        Spacer()
                        Button(action: {}) {
                            Image(systemName: "waveform")
                                .font(.system(size: 28, weight: .medium))
                                .foregroundColor(.white)
                                .frame(width: 70, height: 70)
                                .background(Color.black)
                                .clipShape(Circle())
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 32)
                }
                .background(Color.white)
                .cornerRadius(40)
//                .navigationDestination(for: Route.self) { route in
//                    switch route {
//                    case .scan:
//                        DocumentContentView()
//                    }
//                }
                
            }
        }
    }
}

struct ActionButtonView: View {
    let icon: String?
    let title: String?
    let backgroundColor: Color?
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: icon ?? "")
                .font(.system(size: 32))
                .foregroundColor(.black)
            
            Text(title ?? "")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.black)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 140)
        .background(backgroundColor)
        .cornerRadius(24)
    }
}

#Preview {
    ScannerAppHome()
}
