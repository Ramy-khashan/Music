 
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
 import 'package:on_audio_query/on_audio_query.dart';

import '../../../config/controller/audio_app_controller_cubit.dart';
// import '../../../core/utils/app_colors.dart';
import '../../../core/utils/size_config.dart';
import '../../musicplay/view/musicplay.dart';
import '../controller/list_music_specific_cubit.dart';

class ListMusicSpecificScreen extends StatelessWidget {
  const ListMusicSpecificScreen(
      {super.key,
      required this.albumName,
      required this.songsList,
      this.type = "",
      required this.id});
  final String albumName;
  final int id;
  final List<SongModel> songsList;
  final String type;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return BlocProvider(
      create: (context) => ListMusicSpecificCubit(songsList),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          title: Text(
            albumName,
            style:
                TextStyle(fontWeight: FontWeight.bold, fontSize: getFont(30)),
          ),
        ),
        body: BlocBuilder<ListMusicSpecificCubit, ListMusicSpecificState>(
          builder: (context, state) {
            final controller = ListMusicSpecificCubit.get(context);
            return SafeArea(
                child: controller.songs.isEmpty
                    ? const Center(
                        child: Text(
                          "No audio exisit!",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemBuilder: (context, index) {
                         
                          return ListTile(
                              onTap: () async {
                                try {
                                  BlocProvider.of<AudioAppControllerCubit>(
                                          context)
                                      .audioPlayer
                                      .dispose();
                                } catch (e) {
                                  debugPrint(e.toString());
                                }

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MusicPlay(
                                            songs: controller.songs,
                                            index: index,
                                          )),
                                );
                              },
                              leading: Container(width:75,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
                                child: FutureBuilder(
                                    future: MetadataRetriever.fromFile(
                                      File( controller.songs[index].data)),
                                    builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                              return Image.asset("assets/images/not_exsist.gif",fit: BoxFit.fill,);
                                            } else if (snapshot.hasData) {
                                              return snapshot.data!.albumArt==null?Image.asset("assets/images/not_exsist.gif",fit: BoxFit.fill,):Image.memory(
                                                snapshot.data!.albumArt!,
                                                fit: BoxFit.fill,
                                              );
                                            }
                                      return const Center(child: CircularProgressIndicator());
                                                      }),
                              ),
                              // QueryArtworkWidget(
                              //   controller: OnAudioQuery(),
                              //   id: controller.songs[index].id,
                              //   type: ArtworkType.AUDIO,
                              // ),
                              title: Text(
                                controller.songs[index].displayName.toString(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: getFont(20),
                                    color: Colors.tealAccent.shade400),
                              ),
                              subtitle: Text(
                                controller.songs[index].artist.toString(),
                                style: TextStyle(
                                    fontSize: getFont(18),
                                    color: Colors.grey.shade400),
                              ),
                              // trailing: PopupMenuButton(
                              //   onSelected: (value) {
                              //     if (value == "/removePlaylist") {
                              //       controller.removeSongs(
                              //           index: index,
                              //           playlistId: id,
                              //           audioId: controller.songs[index].id);
                              //     } else {
                              //       showBottomSheet(
                              //         context: context,
                              //         builder: (context) => FutureBuilder(
                              //           future: controller.audioQuery
                              //               .queryPlaylists(),
                              //           builder: (context, playlistItem) {
                              //             if (playlistItem.hasError) {
                              //               return const Center(
                              //                 child: Text(
                              //                     "Something went wrong, Try again later!"),
                              //               );
                              //             } else if (playlistItem.hasData) {
                              //               return playlistItem.data!.isEmpty
                              //                   ? const Center(
                              //                       child: Text(
                              //                           "No playlist founded"),
                              //                     )
                              //                   : Padding(
                              //                       padding:
                              //                           const EdgeInsets.all(
                              //                               10),
                              //                       child: Column(
                              //                         mainAxisSize:
                              //                             MainAxisSize.min,
                              //                         children: [
                              //                           const Text(
                              //                             "Add To Playlist",
                              //                             style: TextStyle(
                              //                                 fontSize: 21,
                              //                                 fontWeight:
                              //                                     FontWeight
                              //                                         .w600),
                              //                           ),
                              //                           ListView.builder(
                              //                             shrinkWrap: true,
                              //                             padding:
                              //                                 const EdgeInsets
                              //                                     .all(10),
                              //                             itemCount:
                              //                                 playlistItem
                              //                                     .data!.length,
                              //                             itemBuilder: (context,
                              //                                     index) =>
                              //                                 Card(
                              //                               color: Colors
                              //                                   .grey.shade200,
                              //                               clipBehavior: Clip
                              //                                   .antiAliasWithSaveLayer,
                              //                               child: ListTile(
                              //                                 onTap: () {
                              //                                   controller.addToPlaylist(
                              //                                       playlistId:
                              //                                           playlistItem
                              //                                               .data![
                              //                                                   index]
                              //                                               .id,
                              //                                       songId: controller
                              //                                           .songs[
                              //                                               index]
                              //                                           .id);
                              //                                   Navigator.pop(
                              //                                       context);
                              //                                 },
                              //                                 title: Text(
                              //                                   "Add to ${playlistItem.data![index].playlist}",
                              //                                   style: const TextStyle(
                              //                                       fontSize:
                              //                                           20,
                              //                                       fontWeight:
                              //                                           FontWeight
                              //                                               .w600,
                              //                                       color: AppColors
                              //                                           .primaryColor),
                              //                                 ),
                              //                                 trailing:
                              //                                     const Icon(
                              //                                   Icons
                              //                                       .playlist_add,
                              //                                   color: AppColors
                              //                                       .primaryColor,
                              //                                 ),
                              //                               ),
                              //                             ),
                              //                           ),
                              //                         ],
                              //                       ),
                              //                     );
                              //             }
                              //             return const Center(
                              //               child: CircularProgressIndicator(),
                              //             );
                              //           },
                              //         ),
                              //       );
                              //     }
                              //   },
                              //   itemBuilder: (context) => [
                              //     if (type != "playlist")
                              //       const PopupMenuItem(
                              //         value: '/playlist',
                              //         child: Text("Add to playlist"),
                              //       ),
                              //     if (type == "playlist")
                              //       const PopupMenuItem(
                              //         value: '/removePlaylist',
                              //         child: Text("Remove from playlist"),
                              //       ),
                              //   ],
                              // )
                              );
                 
                        },
                        itemCount: controller.songs.length,
                      ));
          },
        ),
      ),
    );
  }
}
