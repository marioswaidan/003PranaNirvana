import SwiftUI
import AVFoundation
import AudioToolbox

struct Chakra {
    let imageName: String
    let color: Color
    let size: CGFloat
    let vibrationIntensity: Double
    let vibrationSharpness: Double
}

struct ContentView: View {
    @State private var selectedColor: Color = .black
    @State private var backgroundColor: Color = .black
    @State private var isPressed: Bool = false
    @State private var vibrationTimer: Timer?
    @ObservedObject var mediaManager: MediaManager

    let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
    let impactFeedback2 = UIImpactFeedbackGenerator(style: .light)
    let hapticFeedback = UISelectionFeedbackGenerator()

    let buttons: [Chakra] = [
        Chakra(imageName: "7.Crown", color: .purple, size: 80, vibrationIntensity: 0.7, vibrationSharpness: 0.5),
        Chakra(imageName: "6.Throat", color: .teal, size: 90, vibrationIntensity: 0.7, vibrationSharpness: 0.5),
        Chakra(imageName: "5.Third", color: .blue, size: 95, vibrationIntensity: 0.7, vibrationSharpness: 0.5),
        Chakra(imageName: "4.Heart", color: .green, size: 105, vibrationIntensity: 0.7, vibrationSharpness: 0.5),
        Chakra(imageName: "3.Solar", color: .yellow, size: 110, vibrationIntensity: 0.7, vibrationSharpness: 0.5),
        Chakra(imageName: "2.Sacral", color: .orange, size: 115, vibrationIntensity: 0.7, vibrationSharpness: 0.5),
        Chakra(imageName: "1.Root", color: .red, size: 120, vibrationIntensity: 0.7, vibrationSharpness: 0.5)
    ]

    var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea()

            VStack {
                ForEach(buttons, id: \.imageName) { button in
                    createButton(imageName: button.imageName, color: button.color, size: button.size)
                        .simultaneousGesture(
                            DragGesture(minimumDistance: 0.01)
                                .onChanged { _ in
                                    withAnimation {
                                        backgroundColor = button.color
                                        selectedColor = button.color
                                        impactFeedback.prepare()
                                        impactFeedback.impactOccurred()
                                        // Adjust vibration based on button properties
                                        let intensity = button.vibrationIntensity
                                        let sharpness = button.vibrationSharpness
                                        mediaManager.playSound(for: .Root)
                                        // Start continuous vibration while the button is pressed
                                        startContinuousVibration(intensity: intensity, sharpness: sharpness)
                                    }
                                }
                                .onEnded { _ in
                                    withAnimation {
                                        backgroundColor = .black
                                        selectedColor = .black
                                        // Stop continuous vibration when the button is released
                                        stopContinuousVibration()
                                        mediaManager.pauseSound()
                                    }
                                }
                        )
                }
            }
        }
    }

    private func createButton(imageName: String, color: Color, size: CGFloat) -> some View {
        ZStack {
            Circle()
                .frame(width: size, height: size)
                .foregroundColor(color)
            Circle()
                .frame(width: size - 5, height: size - 5)
                .foregroundColor(selectedColor)
            Image(imageName)
                .resizable()
                .frame(width: size - 10, height: size - 10)
        }
        .buttonStyle(CustomButtonStyle(onChanged: { _ in }))
    }

    private func startContinuousVibration(intensity: Double, sharpness: Double) {
        // Start continuous vibration using a Timer
        vibrationTimer?.invalidate()
        vibrationTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            HapticFeedback.generateContinuousHaptic(intensity: intensity)
        }
    }

    private func stopContinuousVibration() {
        // Stop continuous vibration
        vibrationTimer?.invalidate()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(mediaManager: MediaManager())
    }
}

struct CustomButtonStyle: ButtonStyle {
    var onChanged: (Bool) -> Void

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .onChange(of: configuration.isPressed){ _, newValue in
                onChanged(newValue)
            }
    }
}

struct HapticFeedback {
    static func generateContinuousHaptic(intensity: Double) {
        let generator = UIImpactFeedbackGenerator(style: .rigid)
        generator.impactOccurred(intensity: CGFloat(intensity))
    }
}
