import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'config/controller/audio_app_controller_cubit.dart';
import 'modules/splah_screen/view/splash_screen.dart';

class MusicApp extends StatelessWidget {
  const MusicApp({super.key});

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AudioAppControllerCubit(),
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: 'Music',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.black,
          brightness: Brightness.dark,
          useMaterial3: true,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
