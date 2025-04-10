# 📹 Live Player - RTSP Streaming App

[![Flutter](https://img.shields.io/badge/Flutter-3.22-blue?logo=flutter)](https://flutter.dev)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-lightgrey)](https://flutter.dev)
[![License](https://img.shields.io/badge/License-MIT-green)](https://opensource.org/licenses/MIT)

A professional mobile application for streaming RTSP video feeds with advanced recording management and connection history tracking. Ideal for IP camera monitoring, live broadcasting, and video surveillance.

![App Screenshot]()

## 🚀 Features

### Core Functionality
- **📡 RTSP/Live Stream Playback** with hardware acceleration
- **🔴 In-app Recording** with file size and duration tracking
- **🔄 Auto-Reconnect** (5 attempts with smart backoff)
- **📶 Real-time Connection Status Monitoring**

### History Management
- **⏳ Connection History Tracking** with timestamps
- **✏️ Editable Connection Entries** (Name/URL)
- **🗑️ Bulk Clear History** with confirmation
- **🔄 Swipe-to-Refresh** history list

### Recording Management
- **📼 Local Recording Storage** with metadata
- **▶️ Direct Playback** from app interface
- **📁 File Size & Duration Display** (MB/KB, MM:SS)
- **🗑️ Recording Deletion** with confirmation

### UI/UX
- **🎮 Context Menu Actions** (Edit/Delete/Play)
- **📱 Adaptive Lists** with card-based layout
- **🌀 Loading States & Error Handling**
- **🌓 Dark/Light Theme Support**

## 🛠 Tech Stack

### Core Components
| Technology | Purpose | Version |
|------------|---------|---------|
| Flutter | Cross-platform UI Framework | 3.22+ |
| flutter_vlc_player | RTSP Video Playback | ^8.1.0 |
| Riverpod | State Management | ^2.4.8 |
| Hive | Local Database | ^2.2.3 |

### Key Packages
- `flutter_riverpod`: Reactive state management
- `open_filex`: File handling operations
- `path_provider`: Local storage access
- `intl`: Internationalization support

### State Management
- `videoPlayerProvider`: Manages playback state
- `connectionHistoryProvider`: Handles connection history
- `videoRecordingProvider`: Manages recordings

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
