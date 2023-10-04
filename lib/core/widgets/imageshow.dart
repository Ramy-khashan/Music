import 'package:flutter/material.dart';
import '../utils/size_config.dart';

class ImageShow extends StatelessWidget {
  final double radius;
  const   ImageShow({super.key, required this.radius});
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      child: CircleAvatar(
        radius: getWidth(radius),
        backgroundImage: const AssetImage("assets/images/someone.webp"),
      ),
    );
  }
}
