import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../../../core/utils/app_colors.dart';
import '../../controller/music_list_cubit.dart';

class PopupMenuItemShape extends StatelessWidget {
  const PopupMenuItemShape({super.key, required this.item});
final  SongModel  item;


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MusicListCubit, MusicListState>(
      builder: (context, state) {
        final controller=MusicListCubit.get(context);
        return PopupMenuButton(
          onSelected: (value) {
            showBottomSheet(
              context: context,
              builder: (context) => FutureBuilder(
                future: controller.audioQuery.queryPlaylists(),
                builder: (context, playlistItem) {
                  if (playlistItem.hasError) {
                    return const Center(
                      child: Text("Something went wrong, Try again later!"),
                    );
                  } else if (playlistItem.hasData) {
                    return playlistItem.data!.isEmpty
                        ? const Center(
                            child: Text("No playlist founded"),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  "Add To Playlist",
                                  style: TextStyle(
                                      fontSize: 21,
                                      fontWeight: FontWeight.w600),
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.all(10),
                                  itemCount: playlistItem.data!.length,
                                  itemBuilder: (context, index) => Card(
                                    color: Colors.grey.shade200,
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    child: ListTile(
                                      onTap: () {
                                        controller.addToPlaylist(
                                            playlistId:
                                                playlistItem.data![index].id,
                                            songId: item  .id);
                                        Navigator.pop(context);
                                      },
                                      title: Text(
                                        "Add to ${playlistItem.data![index].playlist}",
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.primaryColor),
                                      ),
                                      trailing: const Icon(
                                        Icons.playlist_add,
                                        color: AppColors.primaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            );
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: '/playlist',
              child: Text("Add to playlist"),
            ),
          ],
        );
      },
    );
  }
}
