# Sound Assets

This directory is reserved for sound effects used in the quiz feature.

## Recommended sounds:
- `success.mp3` - Play when user answers correctly
- `error.mp3` - Play when user answers incorrectly
- `complete.mp3` - Play when quiz is completed

## Sound Requirements:
- Format: MP3 or WAV
- Duration: 0.5-2 seconds recommended
- Size: Keep under 100KB for performance

## Usage:
Once you add sound files, uncomment the audio player code in:
`lib/features/profile/controller/interactive_quiz_controller.dart`

Example:
```dart
import 'package:just_audio/just_audio.dart';

final player = AudioPlayer();
await player.setAsset('assets/sounds/success.mp3');
await player.play();
```
