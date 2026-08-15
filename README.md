# Strobe

An iPhone strobe app for viewing zoetrope animations on vinyl records.

Strobe uses the iPhone's built-in torch to produce adjustable light pulses. It was created primarily for viewing animated artwork printed on vinyl records while they are spinning.

## Features

- Adjustable strobe frequency from **2 to 40 Hz**
- Fine frequency adjustment in **0.01 Hz** steps
- Adjustable **impulse width / duty cycle**
- Pulse duration display in milliseconds
- Adjustable torch brightness
- Uses the maximum available iPhone torch level at 100% brightness
- Simple Start / Stop control
- Automatically switches the torch off when the app goes into the background

Narrow impulse widths are particularly useful for zoetrope records because short flashes reduce motion blur and make individual animation frames appear sharper.

## Usage

1. Place the iPhone so that its torch illuminates the spinning record.
2. Start the turntable.
3. Tap **Start** in Strobe.
4. Adjust the frequency until the animation appears stationary or moves at the desired speed.
5. Use the **±0.01 Hz** controls for precise synchronization.
6. Adjust the impulse width to control motion sharpness. A short pulse such as **5%** works particularly well for many zoetrope records.
7. Adjust brightness as required.

## Requirements

- iPhone with a built-in LED torch
- iOS
- Xcode for building and installing the app

The app is written in **Swift** using **SwiftUI** and **AVFoundation**.

## Installation

Clone the repository and open the project in Xcode.

Select your iPhone as the target device, choose your development team under **Signing & Capabilities**, and run the project.

A free Apple developer account can be used for personal installation, although apps installed using a free Personal Team need to be periodically re-signed.

## Safety

This app produces rapidly flashing light.

Flashing lights can trigger seizures or other adverse reactions in people with photosensitive epilepsy. Use the app responsibly and avoid directing the flashing light at other people.

## Purpose

Strobe was created as a small personal utility for enjoying zoetrope artwork on vinyl records. It may also be useful for other applications where an adjustable portable stroboscopic light source is needed.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
