//
//  ContentView.swift
//  Strobe
//

import SwiftUI

struct ContentView: View {

    @StateObject private var torch = TorchController()

    private var pulseDurationMilliseconds: Double {
        let period = 1.0 / torch.frequency
        let pulseDuration = period * torch.impulseWidth

        return pulseDuration * 1000.0
    }
    
    var body: some View {
        VStack(spacing: 28) {

            Spacer()

            Image(systemName: "bolt.fill")
                .font(.system(size: 72))
                .symbolRenderingMode(.hierarchical)

            Text("Strobe")
                .font(.largeTitle)
                .fontWeight(.bold)

            // MARK: - Frequency

            VStack(spacing: 12) {

                HStack {
                    Text("Frequency")

                    Spacer()

                    Text("\(torch.frequency, specifier: "%.2f") Hz")
                        .monospacedDigit()
                }

                Slider(
                    value: $torch.frequency,
                    in: 2...40,
                    step: 0.1
                )
                .onChange(of: torch.frequency) {
                    torch.timingChanged()
                }

                HStack(spacing: 16) {

                    Button {
                        adjustFrequency(by: -0.01)
                    } label: {
                        Label("0.01", systemImage: "minus")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)

                    Button {
                        adjustFrequency(by: 0.01)
                    } label: {
                        Label("0.01", systemImage: "plus")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                }
            }

            // MARK: - Impulse width

            VStack(spacing: 12) {

                HStack {
                    Text("Impulse Width")

                    Spacer()

                    Text("\(Int(torch.impulseWidth * 100))%")
                        .monospacedDigit()
                }

                Slider(
                    value: $torch.impulseWidth,
                    in: 0.05...0.95,
                    step: 0.05
                )
                .onChange(of: torch.impulseWidth) {
                    torch.timingChanged()
                }

                HStack {
                    Text("Pulse")

                    Spacer()

                    Text(
                        "\(pulseDurationMilliseconds, specifier: "%.2f") ms"
                    )
                    .monospacedDigit()
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)
            }

            // MARK: - Brightness

            VStack(spacing: 12) {

                HStack {
                    Text("Brightness")

                    Spacer()

                    Text("\(Int(torch.brightness * 100))%")
                        .monospacedDigit()
                }

                Slider(
                    value: $torch.brightness,
                    in: 0.05...1.0,
                    step: 0.05
                )
            }

            // MARK: - Start / Stop

            Button {
                torch.toggle()
            } label: {

                HStack {
                    Image(
                        systemName:
                            torch.isRunning
                            ? "stop.fill"
                            : "play.fill"
                    )

                    Text(
                        torch.isRunning
                        ? "STOP"
                        : "START"
                    )
                }
                .font(.title2)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity)
                .padding()
            }
            .buttonStyle(.borderedProminent)
            .tint(torch.isRunning ? .red : .blue)
            .disabled(!torch.torchAvailable)

            if !torch.torchAvailable {
                Text("Torch is not available on this device.")
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding(28)
        .onReceive(
            NotificationCenter.default.publisher(
                for: UIApplication.didEnterBackgroundNotification
            )
        ) { _ in
            torch.stop()
        }
    }

    private func adjustFrequency(by amount: Double) {

        let newFrequency = torch.frequency + amount

        torch.frequency = min(
            40.0,
            max(2.0, newFrequency)
        )

        torch.timingChanged()
    }
}

#Preview {
    ContentView()
}
