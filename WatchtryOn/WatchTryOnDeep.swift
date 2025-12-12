import SwiftUI
import RealityKit
import ARKit

// MARK: - Public SwiftUI entry point
struct WatchTryOnDeep: View {
    @State private var selectedStyle: WatchStyle = .green
    @State private var coachingVisible: Bool = true
    @State private var smoothing: Float = 0.2

    var body: some View {
        ZStack(alignment: .bottom) {
//            ARWatchView(style: selectedStyle, placementMode: placementMode, wrist: selectedWrist, smoothing: smoothing, coachingVisible: $coachingVisible)
            WatchTryOnContainer(style: selectedStyle)
                .ignoresSafeArea()
            controls
        }
        .onAppear {
            // Ask for camera permission implicitly when AR session starts
        }
    }

    private var controls: some View {
        VStack(spacing: 10) {
            HStack(spacing: 12) {
                ForEach(WatchStyle.allCases, id: \.self) { style in
                    Button(action: { selectedStyle = style }) {
                        Circle()
                            .fill(style.color)
                            .frame(width: 28, height: 28)
                            .overlay(
                                Circle().stroke(.white, lineWidth: 0)
                            )
                            .shadow(radius: 2)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(12)
            .background(.ultraThinMaterial, in: Capsule())
        }
        .padding(.bottom, 24)
        .padding(.horizontal, 16)
    }
}

enum WatchStyle: CaseIterable, Hashable {
    case green, black, sand

    var modelName: String {
        // Replace these with real USDZ file names in your bundle / asset catalog.
        switch self {
        case .green: return "watch_ar"   // e.g., Watch_Green.usdz
        case .black: return "watch_ar"
        case .sand:  return "watch_ar"
        }
    }

    var color: Color {
        switch self {
        case .green: return Color(hue: 0.41, saturation: 0.55, brightness: 0.45)
        case .black: return .black
        case .sand:  return Color(red: 0.86, green: 0.79, blue: 0.67)
        }
    }
}
