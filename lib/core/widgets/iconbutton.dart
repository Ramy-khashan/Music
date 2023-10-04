import 'package:flutter/material.dart';
import '../utils/size_config.dart';

class IconClickItem extends StatelessWidget {
  final bool isCircle;
  final bool change;
  final VoidCallback onTap;
  final IconData icon;
  const IconClickItem(
      {super.key,
      required this.icon,
      required this.change,
      this.isCircle = true,
      required this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(isCircle ? 35 : 13),
      child: Container(
        padding: EdgeInsets.all(getWidth(12)),
        decoration: BoxDecoration(
          borderRadius: isCircle ? null : BorderRadius.circular(10),
          gradient: change
              ? null
              : RadialGradient(
                  radius: 1.6,
                  colors: [Color(0xff303030), Colors.grey.shade500],
                ),
          //color: Colors.tealAccent.shade700,
          color: change ? Colors.tealAccent.shade400 : Color(0xff303030),
          shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
          boxShadow: [
            BoxShadow(
              blurRadius:5,
              color: Colors.grey.shade700.withOpacity(.15),
              offset: Offset(0, 0),
              spreadRadius:5,

            ),
          ],
        ),
        child: Center(
            child: Icon(
          change ? Icons.pause : icon,
          color: change ? Colors.white : Colors.grey.shade400,
        )),
      ),
    );
  }
}
