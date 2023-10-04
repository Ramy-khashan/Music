import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';

class MusicShapeItem extends StatelessWidget {
  const MusicShapeItem({super.key, required this.title, required this.image, required this.onTap});
  final String title;
  final Function() onTap;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Card(
     elevation: 0,
      color:Colors.grey .withOpacity(.23),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: InkWell(
        onTap: onTap  ,
        child: GridTile(
          footer: GridTileBar(
            title: Center(child: Text(title,style: const TextStyle(fontSize: 25,fontFamily: "title",fontWeight: FontWeight.w600),)),
            backgroundColor: AppColors.primaryColor.withOpacity(.5),
          ),
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Image.asset(
              image,
              
            ),
          ),
        ),
      ),
    );
  }
}
