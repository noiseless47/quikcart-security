# QuikCart Security App

A Flutter-based mobile application designed to enhance retail security by verifying purchased items against their RFID tags. This app helps prevent theft and ensures inventory accuracy by matching items in a customer's bill with their physical RFID tags.

## Features

- **QR Code Scanning**: Scan purchase receipts via QR codes
- **RFID Verification**: Read RFID tags from purchased items
- **Real-time Validation**: Instantly verify if scanned items match the bill
- **Audio Feedback**: Distinct sounds for successful and failed scans
- **Visual Status Updates**: Clear visual indicators for verified items

## Technical Requirements

### Prerequisites
- Flutter SDK (Latest stable version)
- Dart SDK (Latest stable version)
- Android Studio / VS Code
- Physical Android device with NFC capability
- iOS device with NFC capability (iPhone 7 or newer)

### Dependencies
```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.0.0
  mobile_scanner: ^3.0.0
  flutter_nfc_kit: ^3.3.1
  audioplayers: ^5.0.0
```

## Setup Instructions

1. **Clone the Repository**
   ```bash
   git clone [repository-url]
   cd shopping-security
   ```

2. **Install Dependencies**
   ```bash
   flutter pub get
   ```

3. **Android Setup**
   - Ensure the following permissions in `android/app/src/main/AndroidManifest.xml`:
     ```xml
     <uses-permission android:name="android.permission.NFC" />
     <uses-feature android:name="android.hardware.nfc" android:required="true" />
     ```
   - Minimum SDK version should be set to 26 in `android/app/build.gradle`

4. **iOS Setup**
   - Add NFC capability in Xcode project settings
   - Add NFC usage description in Info.plist

## Architecture

The app follows a Provider-based state management architecture with the following components:

- **Models**: `Bill`, `BillItem` - Data structures for purchases
- **Providers**: `SecurityProvider` - Manages app state and business logic
- **Services**: 
  - `ApiService` - Handles API communication
  - `AudioService` - Manages sound feedback
- **Widgets**:
  - `QRScannerWidget` - Handles QR code scanning
  - `RFIDScannerWidget` - Manages RFID tag reading
  - `ItemListWidget` - Displays items and their verification status

## Usage Flow

1. **Start Screen**: User is presented with QR scanner option
2. **Scan Receipt**: User scans the QR code on their receipt
3. **Verify Items**: 
   - Start RFID scanning
   - Pass each purchased item near the device's NFC reader
   - System verifies each item against the bill
4. **Completion**: All items are marked as verified when successfully scanned

## Testing

Run tests using:
```bash
flutter test
```

## Build and Deploy

### Debug Build
```bash
flutter run
```

### Release Build
```bash
flutter build apk --release  # For Android
flutter build ios            # For iOS
```

## Troubleshooting

Common issues and solutions:

1. **NFC Not Detected**
   - Ensure NFC is enabled in device settings
   - Verify device has NFC capability
   - Check app permissions

2. **QR Scanner Issues**
   - Ensure adequate lighting
   - Keep device steady
   - Verify camera permissions

3. **Build Errors**
   - Run `flutter clean`
   - Delete build folder
   - Run `flutter pub get`
   - Rebuild project

## Security Considerations

- App does not store sensitive bill data locally
- RFID tag data is only used for verification
- Session data is cleared on app closure
- No personal customer information is processed

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit changes
4. Push to branch
5. Create Pull Request

## License

MIT License

Copyright (c) 2024 Asish Kumar Yeleti

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

## Contact

[Your contact information]
