import 'dart:async';

import 'package:flutter/material.dart';
import '../../../core/utils/size_config.dart';
import '../../home_screen/view/home_page_screen.dart';
 
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? timer;
  @override
  void initState() {
    Timer(const Duration(milliseconds: 1800), () {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePageScreen(),
          ),
          (route) => false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.black,
        body: SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
child: Image.asset("assets/images/music_logo1.png"),      
      // child: Icon(
      //   Icons.music_note,
      //   color: Colors.white,
      //   size: 160,
      //   shadows: [
      //     Shadow(
      //         color: Colors.black.withOpacity(.5),
      //         blurRadius: 15,
      //         offset: const Offset(14, -6))
      //   ],
      // ),
    ));
  }
}
