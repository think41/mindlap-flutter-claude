# MindLap Flutter App

A Flutter web application with a Notion-like interface for project requirement capture, featuring voice recording, image uploads, and dynamic content blocks.

## 🚀 Features

- **📱 Mobile-First Design** - Optimized for phone form factor (400px max width)
- **🏗️ Archetype Selection** - Choose from Voice Agent, Content Creation App, or Landing Page projects
- **📝 Notion-Like Interface** - Dynamic content blocks with inline editing
- **🎤 Voice Recording** - Record and playback audio notes directly in the browser
- **📸 Image Upload** - Upload images with captions and preview
- **💬 Text Blocks** - Rich text input with real-time editing
- **✅ Complete Flow** - From project selection to requirements capture to confirmation

## 🛠️ Tech Stack

- **Framework:** Flutter 3.8.1+
- **State Management:** Provider
- **Navigation:** Go Router
- **Audio:** Record + Just Audio
- **File Handling:** File Picker
- **Storage:** Shared Preferences
- **UI:** Material 3 with responsive design

## 📋 Prerequisites

Before running this app, you need to install Flutter on your system.

### 🐧 Linux Setup

1. **Download Flutter:**
   ```bash
   cd ~/development
   wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.8.1-stable.tar.xz
   tar xf flutter_linux_3.8.1-stable.tar.xz
   ```

2. **Add Flutter to PATH:**
   ```bash
   echo 'export PATH="$PATH:$HOME/development/flutter/bin"' >> ~/.bashrc
   source ~/.bashrc
   ```

3. **Install Dependencies:**
   ```bash
   sudo apt update
   sudo apt install curl git unzip xz-utils zip libglu1-mesa
   ```

4. **Install Chrome (for web development):**
   ```bash
   wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
   echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list
   sudo apt update
   sudo apt install google-chrome-stable
   ```

5. **Verify Installation:**
   ```bash
   flutter doctor
   ```

### 🍎 macOS Setup

1. **Download Flutter:**
   ```bash
   cd ~/development
   curl -O https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_3.8.1-stable.zip
   unzip flutter_macos_3.8.1-stable.zip
   ```

2. **Add Flutter to PATH:**
   ```bash
   echo 'export PATH="$PATH:$HOME/development/flutter/bin"' >> ~/.zshrc
   source ~/.zshrc
   ```

3. **Install Xcode (optional, for iOS development):**
   - Download from Mac App Store
   - Run: `sudo xcode-select --install`

4. **Install Chrome:**
   - Download from https://www.google.com/chrome/

5. **Verify Installation:**
   ```bash
   flutter doctor
   ```

### 🪟 Windows Setup

1. **Download Flutter:**
   - Go to https://docs.flutter.dev/get-started/install/windows
   - Download the Flutter SDK zip file
   - Extract to `C:\development\flutter`

2. **Add Flutter to PATH:**
   - Open "Environment Variables" in System Properties
   - Add `C:\development\flutter\bin` to your PATH
   - Restart command prompt

3. **Install Git:**
   - Download from https://git-scm.com/download/win

4. **Install Chrome:**
   - Download from https://www.google.com/chrome/

5. **Install Visual Studio (optional, for Windows development):**
   - Download Visual Studio Community with C++ tools

6. **Verify Installation:**
   ```cmd
   flutter doctor
   ```

## 🏃‍♂️ Running the App

### 1. Clone the Repository
```bash
git clone https://github.com/palash-devworks/mindlap-flutter-claude.git
cd mindlap-flutter-claude
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Enable Web Support (if not already enabled)
```bash
flutter config --enable-web
```

### 4. Run the Web App

#### Option A: Run in Chrome (Recommended)
```bash
flutter run -d chrome
```

#### Option B: Run on Web Server
```bash
flutter run -d web-server --web-port 3000
```
Then open http://localhost:3000 in your browser

#### Option C: Build for Production
```bash
flutter build web
```
The built files will be in `build/web/` directory.

## 🎯 How to Use

1. **Choose Project Type:**
   - Select from Voice Agent, Content Creation App, or Landing Page

2. **Build Your Requirements:**
   - Click the **+** button to add content blocks
   - Choose from Text, Image, or Voice Note blocks

3. **Add Content:**
   - **Text Blocks:** Type directly in the block
   - **Image Blocks:** Click to upload images and add captions
   - **Voice Blocks:** Click the microphone to record audio

4. **Voice Recording Features:**
   - 🔴 **Record:** Click mic icon to start recording
   - ⏹️ **Stop:** Click stop icon to finish recording
   - ▶️ **Play:** Click play icon to hear your recording
   - 🗑️ **Delete:** Click delete icon to remove recording

5. **Submit Requirements:**
   - Click **"Build"** button when ready
   - Review your requirements summary
   - Get confirmation message

## 🏗️ Project Structure

```
lib/
├── main.dart                 # App entry point with routing
├── models/
│   ├── archetype.dart       # Project type definitions
│   ├── content_block.dart   # Content block models
│   └── requirements.dart    # Requirements data model
├── providers/
│   └── app_provider.dart    # State management
├── screens/
│   ├── home_screen.dart     # Archetype selection
│   ├── capture_screen.dart  # Notion-like page builder
│   └── thank_you_screen.dart # Confirmation page
└── widgets/
    ├── text_block_widget.dart  # Text content blocks
    ├── image_block_widget.dart # Image upload blocks
    └── voice_block_widget.dart # Voice recording blocks
```

## 🔧 Development

### Hot Reload
During development, use hot reload for fast iteration:
- Press `r` in terminal to hot reload
- Press `R` for hot restart
- Press `q` to quit

### Debugging
- **Web DevTools:** Available in browser developer tools
- **Flutter Inspector:** Use `flutter inspector` command
- **Logs:** Check browser console for web-specific logs

### Building for Different Platforms

#### Web (Production)
```bash
flutter build web --release
```

#### Android APK
```bash
flutter build apk --release
```

#### iOS (macOS only)
```bash
flutter build ios --release
```

## 🌐 Browser Compatibility

- **Chrome:** ✅ Full support (recommended)
- **Firefox:** ✅ Full support  
- **Safari:** ✅ Full support
- **Edge:** ✅ Full support

**Note:** Voice recording requires HTTPS in production or localhost for development.

## 📱 Responsive Design

The app is optimized for:
- **Mobile devices** (primary target)
- **Tablets** (responsive scaling)
- **Desktop browsers** (mobile-first layout)

## 🎨 Customization

### Themes
The app uses Material 3 design. To customize:
- Edit `ThemeData` in `lib/main.dart`
- Modify color schemes and typography

### Adding New Block Types
1. Create new block model in `lib/models/content_block.dart`
2. Add widget in `lib/widgets/`
3. Update `BlockType` enum and provider methods

## 🐛 Troubleshooting

### Common Issues

1. **Flutter not found:**
   - Ensure Flutter is in your PATH
   - Run `flutter doctor` to diagnose issues

2. **Web not enabled:**
   ```bash
   flutter config --enable-web
   flutter create . --platforms web
   ```

3. **Dependencies issues:**
   ```bash
   flutter clean
   flutter pub get
   ```

4. **Voice recording not working:**
   - Ensure microphone permissions are granted
   - Use HTTPS or localhost
   - Check browser compatibility

5. **Hot reload not working:**
   - Use `flutter run -d chrome --hot`
   - Check for compilation errors

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📞 Support

- **Issues:** [GitHub Issues](https://github.com/palash-devworks/mindlap-flutter-claude/issues)
- **Discussions:** [GitHub Discussions](https://github.com/palash-devworks/mindlap-flutter-claude/discussions)
- **Flutter Docs:** [docs.flutter.dev](https://docs.flutter.dev)

---

**Built with ❤️ using Flutter**