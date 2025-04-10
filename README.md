# 📹 Live Player - RTSP Streaming App

[![Flutter](https://img.shields.io/badge/Flutter-3.22-blue?logo=flutter)](https://flutter.dev)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-lightgrey)](https://flutter.dev)
[![License](https://img.shields.io/badge/License-MIT-green)](https://opensource.org/licenses/MIT)

A professional-grade mobile application for streaming RTSP video feeds with real-time controls and recording capabilities. Perfect for IP camera monitoring, live broadcasting, and video surveillance.

![App Preview]()

## 🚀 Features

- **📡 RTSP/Live Stream Playback**
- **🔴 Recording with Visual Indicator**
- **🔄 Auto-Reconnect (5 attempts)**
- **📶 Connection Status Monitoring**
- **🎮 Gesture Controls (Tap/Double Tap)**
- **🌗 Adaptive UI for Low-Light Conditions**
- **⏳ Buffering Optimization**
- **📲 Full Screen Landscape Mode**

## 🛠 Tech Stack

**Core Components**  
| Technology | Purpose | Version |
|------------|---------|---------|
| Flutter | Cross-platform UI Framework | 3.22+ |
| flutter_vlc_player | RTSP Video Playback | ^8.1.0 |
| Riverpod | State Management | ^2.4.8 |
| Dart | Programming Language | 3.4+ |

**Key Packages**
- `flutter_riverpod`: Reactive state management
- `flutter_vlc_player`: VLC-powered video playback
- `intl`: Internationalization support
- `path_provider`: Local storage access

## 📦 Installation

### Prerequisites
- Flutter SDK 3.22+
- Android Studio/Xcode
- RTSP Camera/Stream URL

### Steps
1. **Clone Repository**
   ```bash
   git clone https://github.com/yourusername/live-player.git
   cd live-player
   ```

2. **Install Dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure RTSP URL**
   ```dart
   // lib/screens/video_player.dart
   const String rtspUrl = 'rtsp://your-stream-url';
   ```

4. **Run Application**
   ```bash
   flutter run
   ```

## ⚙ Configuration

### VLC Player Options
Customize in `lib/screens/video_player.dart`:
```dart
VlcPlayerOptions(
  advanced: VlcAdvancedOptions([
    VlcAdvancedOptions.networkCaching(1500),
    '--rtsp-tcp',
    '--network-caching=300',
  ]),
  video: VlcVideoOptions([
    VlcVideoOptions.dropLateFrames(true),
    VlcVideoOptions.skipFrames(true),
  ])
)
```

## 🎮 Usage

### Basic Controls
| Action | Gesture |
|--------|---------|
| Play/Pause | Tap screen → Play button |
| Record | Tap screen → Red Record button |
| Full Screen | Double tap screen |
| Show/Hide Controls | Single tap |

### Connection States
| Indicator | Meaning |
|-----------|---------|
| 🟢 Green Snackbar | Stream connected |
| 🟠 Orange Snackbar | Buffering/reconnecting |
| 🔴 Red Snackbar | Connection lost |

## 🤝 Contributing

We welcome contributions! Please follow these steps:
1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📜 License

Distributed under the MIT License. See `LICENSE` for more information.

## 🙏 Acknowledgments

- [flutter_vlc_player](https://pub.dev/packages/flutter_vlc_player) maintainers
- Flutter community for awesome packages
- VLC Media Player team
