import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/size_config.dart';
import '../controller/albums_cubit.dart';

class AlbumsScreen extends StatelessWidget {
  const AlbumsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AlbumsCubit()..getAlbums(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          title: Text(
            "Albums",
            style:
                TextStyle(fontWeight: FontWeight.bold, fontSize: getFont(30)),
          ),
        ),
        body: BlocBuilder<AlbumsCubit, AlbumsState>(
          builder: (context, state) {
            final controller = AlbumsCubit.get(context);
            return controller.isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : controller.isFaild
                    ? const Center(
                        child: Text("Something went wrong, Try again later!"),
                      )
                    : controller.albums.isEmpty
                        ? const Center(
                            child: Text("No Albums Exisit!",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24,fontFamily: "title"),),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.only(top: 7),
                            itemCount: controller.albums.length,
                            itemBuilder: (context, index) => Card(
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              child: ListTile(
                                onTap: () {
                                  controller
                                      .getAlbumSongs(controller.albums[index],context);
                                },
                                title: Text(
                                  controller.albums[index].album,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                subtitle: Text(
                                    "Number of songs ${controller.albums[index].numOfSongs}"),
                                trailing:
                                    const Icon(Icons.arrow_forward_ios_rounded),
                              ),
                            ),
                          );
          },
        ),
      ),
    );
  }
}
