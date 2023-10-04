import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/app_colors.dart';

import '../../../core/utils/size_config.dart';
import '../controller/playlist_cubit.dart';

class PlaylistScreen extends StatelessWidget {
  const PlaylistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PlaylistCubit()..getPlaylist(),
      child: BlocBuilder<PlaylistCubit, PlaylistState>(
        builder: (context, state) {
          final controller = PlaylistCubit.get(context);
          return Scaffold(
              appBar: AppBar(
                elevation: 0,
                scrolledUnderElevation: 0,
                centerTitle: true,
                title: Text(
                  "Playlist",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: getFont(30)),
                ),
                actions: [
                  CircleAvatar(
                      backgroundColor: Colors.black.withOpacity(.3),
                      child: IconButton(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              backgroundColor:
                                  const Color.fromARGB(255, 18, 30, 40),
                              builder: (context) => Form(
                                key: controller.formKey,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 8),
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      TextFormField(
                                        controller:
                                            controller.playlistController,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "Fill out this field";
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          labelText: "Playlist name",
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            borderSide: const BorderSide(
                                                color: Colors.white),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            borderSide: const BorderSide(
                                                color: Colors.white),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            borderSide: const BorderSide(
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 35),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            if (controller.formKey.currentState!
                                                .validate()) {
                                              controller.createPlayList();
                                              Navigator.pop(context);
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 15,
                                                      horizontal: 10),
                                              backgroundColor:
                                                  AppColors.secondryColor),
                                          child: const Text(
                                            "Add Playlist",
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.playlist_add,
                            size: 28,
                          )))
                ],
              ),
              body: controller.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : controller.isFaild
                      ? const Center(
                          child: Text("Something went wrong, Try again later!"),
                        )
                      : controller.playlist.isEmpty
                          ? const Center(
                              child: Text("No Playlist Exisit!",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24,fontFamily: "title")),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.only(top: 7),
                              itemCount: controller.playlist.length,
                              itemBuilder: (context, index) => Card(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                child: ListTile(
                                  onTap: () {
                                    controller.getPlaylistSongs(
                                      controller.playlist[index],
                                      context,
                                    );
                                  },
                                  title: Text(
                                    controller.playlist[index].playlist,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          "Number of Songs ${controller.playlist[index].numOfSongs}"),
                                    ],
                                  ),
                                  trailing: IconButton(
                                    onPressed: () {
                                      controller.removePlayList(
                                          id: controller.playlist[index].id,
                                          name: controller
                                              .playlist[index].playlist);
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Color.fromARGB(255, 229, 57, 53),
                                    ),
                                  ),
                                ),
                              ),
                            ));
        },
      ),
    );
  }
}
