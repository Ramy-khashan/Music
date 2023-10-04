import 'package:flutter/material.dart';

import 'iconbutton.dart';
import 'imageshow.dart';

class HeadItem extends StatelessWidget {
  const HeadItem({super.key});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconClickItem(
          change: false,
          icon: Icons.favorite,
          onTap: () {},
        ),
        const ImageShow(radius: 80),
        IconClickItem(
          change: false,
          icon: Icons.list,
          onTap: () {},
        ),
      ],
    );
  }
}
