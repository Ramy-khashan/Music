import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'widgets/music_type_shape.dart';

import '../controller/home_page_cubit.dart';

class HomePageScreen extends StatelessWidget {
  const HomePageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomePageCubit()..getPermission(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text(
            "Music",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: BlocBuilder<HomePageCubit, HomePageState>(
          builder: (context, state) {
            final controller = HomePageCubit.get(context);
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 300,
                  mainAxisExtent: 240,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10),
              itemCount: controller.musicPartition.length,
              itemBuilder: (context, index) => MusicShapeItem(
                  onTap: () {
                  index==3?Fluttertoast.showToast(msg: "Coming soon!"):  Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              controller.musicPartition[index].page,
                        ));
                  },
                  title: controller.musicPartition[index].title,
                  image:
                      "assets/images/${controller.musicPartition[index].image}"),
            );
          },
        ),
      ),
    );
  }
}
