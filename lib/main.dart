import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';

import 'core/utils/shared_prefrance_utils.dart';
import 'music_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
    await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
    androidShowNotificationBadge: true,preloadArtwork: true
  );
  
  MusicApp.navigatorKey = GlobalKey<NavigatorState>();

  await PreferenceUtils.init();
  runApp(const MusicApp());
}
