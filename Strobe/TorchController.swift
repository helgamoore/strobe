import Foundation
import AVFoundation
import Combine

final class TorchController: ObservableObject {

    @Published var frequency: Double = 10.0
    @Published var brightness: Double = 1.0
    @Published var impulseWidth: Double = 0.5

    @Published private(set) var isRunning = false
    @Published private(set) var torchAvailable = false

    private let queue = DispatchQueue(
        label: "StrobeTorchQueue",
        qos: .userInteractive
    )

    private var timer: DispatchSourceTimer?
    private var torchIsOn = false

    private let device: AVCaptureDevice?

    init() {
        device = AVCaptureDevice.default(for: .video)

        torchAvailable =
            device?.hasTorch == true &&
            device?.isTorchAvailable == true
    }

    func toggle() {
        if isRunning {
            stop()
        } else {
            start()
        }
    }

    func start() {
        guard !isRunning else { return }
        guard torchAvailable else { return }

        isRunning = true

        queue.async { [weak self] in
            self?.scheduleOn()
        }
    }

    func stop() {
        isRunning = false

        timer?.cancel()
        timer = nil

        queue.async { [weak self] in
            guard let self else { return }

            self.torchIsOn = false
            self.setTorch(on: false)
        }
    }

    func timingChanged() {
        guard isRunning else { return }

        timer?.cancel()
        timer = nil

        queue.async { [weak self] in
            guard let self else { return }

            self.torchIsOn = false
            self.setTorch(on: false)
            self.scheduleOn()
        }
    }

    private func scheduleOn() {
        guard isRunning else { return }

        torchIsOn = true
        setTorch(on: true)

        let safeFrequency = max(2.0, min(frequency, 40.0))
        let safeImpulseWidth = max(0.05, min(impulseWidth, 0.95))

        let period = 1.0 / safeFrequency
        let onDuration = period * safeImpulseWidth

        let newTimer = DispatchSource.makeTimerSource(queue: queue)

        newTimer.schedule(
            deadline: .now() + onDuration,
            leeway: .microseconds(100)
        )

        newTimer.setEventHandler { [weak self] in
            self?.scheduleOff()
        }

        timer = newTimer
        newTimer.resume()
    }

    private func scheduleOff() {
        guard isRunning else { return }

        torchIsOn = false
        setTorch(on: false)

        let safeFrequency = max(2.0, min(frequency, 40.0))
        let safeImpulseWidth = max(0.05, min(impulseWidth, 0.95))

        let period = 1.0 / safeFrequency
        let offDuration = period * (1.0 - safeImpulseWidth)

        let newTimer = DispatchSource.makeTimerSource(queue: queue)

        newTimer.schedule(
            deadline: .now() + offDuration,
            leeway: .microseconds(100)
        )

        newTimer.setEventHandler { [weak self] in
            self?.scheduleOn()
        }

        timer = newTimer
        newTimer.resume()
    }

    private func setTorch(on: Bool) {
        guard let device else { return }
        guard device.hasTorch else { return }

        do {
            try device.lockForConfiguration()

            defer {
                device.unlockForConfiguration()
            }

            if on {
                if brightness >= 0.999 {
                    try device.setTorchModeOn(
                        level: AVCaptureDevice.maxAvailableTorchLevel
                    )
                } else {
                    let level = Float(
                        max(0.01, min(brightness, 1.0))
                    )

                    try device.setTorchModeOn(level: level)
                }
            } else {
                device.torchMode = .off
            }
        } catch {
            print("Torch error: \(error)")
        }
    }

    deinit {
        timer?.cancel()

        if let device {
            do {
                try device.lockForConfiguration()
                device.torchMode = .off
                device.unlockForConfiguration()
            } catch {
                // Ignore cleanup errors.
            }
        }
    }
}
