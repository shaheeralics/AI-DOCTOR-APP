# Voice Message UI Component

A WhatsApp-like voice message recording interface with advanced gesture controls and animations.

## Features

### 🎤 **Recording Interface**
- **Red pulsing indicator** - Shows active recording state
- **Real-time timer** - Displays recording duration (MM:SS format)
- **Voice wave animation** - Visual feedback with animated sound waves
- **Gesture hints** - Instructions for slide actions

### 🔄 **Gesture Controls**
- **Swipe Up to Lock** - Drag upward to lock recording (hands-free mode)
- **Slide Left to Delete** - Drag left to cancel and delete recording
- **Visual feedback** - Icons appear and animate during gestures

### 🔒 **Locked Mode**
- **Persistent recording** - Continues recording without holding
- **Lock indicator** - Shows locked state with lock icon
- **Control buttons** - Delete and Send buttons for final actions
- **Enhanced layout** - Expanded UI with more controls

### ✨ **Animations**
- **Wave animation** - Recording indicator pulses smoothly
- **Voice waves** - 5 animated bars showing sound levels
- **Gesture feedback** - Lock and delete icons animate on drag
- **Smooth transitions** - Between normal and locked states

## Usage

```dart
VoiceMessageUI(
  onCancel: () {
    // Handle recording cancellation
  },
  onSend: () {
    // Handle sending voice message
  },
  onLock: () {
    // Handle recording lock
  },
)
```

## Integration

The component is integrated with `ChatInput` and appears when the microphone button is pressed. It replaces the regular chat input during recording mode.

## Customization

- Colors use the app's medical theme (`kMedicalBlue`, `kCardBackground`)
- Fonts use the consistent `Montserrat` family
- Animation timings can be adjusted in the controller setup
- Gesture thresholds can be modified in the pan handlers

## Note

This is a UI-only component. Actual voice recording functionality should be implemented separately using packages like `record` or `audio_session`.
