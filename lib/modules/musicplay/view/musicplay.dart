import 'dart:io';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import '../../../core/utils/size_config.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../../config/controller/audio_app_controller_cubit.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/widgets/iconbutton.dart';
import '../../music_list/controller/music_list_cubit.dart';
import '../controller/music_play_cubit.dart';
import '../model/page_manager.dart';

class MusicPlay extends StatelessWidget {
  const MusicPlay({super.key, required this.songs, required this.index});
  final List<SongModel> songs;
  final int index;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocBuilder<AudioAppControllerCubit, AudioAppControllerState>(
      builder: (context, state) {
        final controller = AudioAppControllerCubit.get(context);
        return BlocProvider(
            create: (context) => MusicPlayCubit(songs, index),
            child: BlocBuilder<MusicPlayCubit, MusicPlayState>(
              builder: (context, state) {
                return SizedBox(
                  child: Scaffold(
                    body: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: getWidth(10), vertical: getHeight(50)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: size.shortestSide * .03,
                                vertical: size.longestSide * .01),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconClickItem(
                                  icon: Icons.arrow_back,
                                  change: false,
                                  isCircle: false,
                                  onTap: () {
                                    Navigator.pop(context);
                                    // Navigator.pushAndRemoveUntil(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //     builder: (context) => MusicListScreen(),
                                    //   ),
                                    //   (route) => false,
                                    // );
                                  },
                                ),
                                Text(
                                  "Playing now".toUpperCase(),
                                  style: TextStyle(
                                    fontSize: size.shortestSide * .04,
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                                IconClickItem(
                                  icon: Icons.filter_list,
                                  change: false,
                                  isCircle: false,
                                  onTap: () {
                                    controller.showSongs(context, songs: songs);
                                  },
                                ),
                              ],
                            ),
                          ),
                          BlocProvider.value(
                            value: MusicListCubit(),
                            child: BlocBuilder<MusicListCubit, MusicListState>(
                              builder: (context, state) {
                                return Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15)),
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  width: getWidth(300),
                                  height: getHeight(250),
                                  child: FutureBuilder(
                                      future: MetadataRetriever.fromFile(File(
                                          songs[controller.audioPlayer
                                                      .currentIndex ??
                                                  index]
                                              .data)),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasError) {
                                          return Image.asset(
                                            "assets/images/not_exsist.gif",
                                            fit: BoxFit.fill,
                                          );
                                        } else if (snapshot.hasData) {
                                          return snapshot.data!.albumArt == null
                                              ? Image.asset(
                                                  "assets/images/not_exsist.gif",
                                                  fit: BoxFit.fill,
                                                )
                                              : Image.memory(
                                                  snapshot.data!.albumArt!,
                                                  fit: BoxFit.fill,
                                                  width: getWidth(300),
                                                  height: getHeight(250),
                                                );
                                        }
                                        return const Center(
                                            child: CircularProgressIndicator());
                                        //  QueryArtworkWidget(
                                        //   artworkQuality: FilterQuality.high,
                                        //   keepOldArtwork: true,
                                        //   artworkFit: BoxFit.fill,
                                        //   quality: 100,
                                        //   artworkWidth: 270,
                                        //   artworkHeight: 200,
                                        //   controller:
                                        //       BlocProvider.of<MusicListCubit>(context)
                                        //           .audioQuery,
                                        //   id: songs[
                                        //           controller.audioPlayer.currentIndex ??
                                        //               index]
                                        //       .id,
                                        //   type: ArtworkType.AUDIO,
                                        // );
                                      }),
                                );
                              },
                            ),
                          ),
                          Text(
                            songs[controller.audioPlayer.currentIndex ?? index]
                                    .displayNameWOExt
                                    .contains("MP3")
                                ? songs[controller.audioPlayer.currentIndex ??
                                        index]
                                    .displayNameWOExt
                                    .replaceAll("_", "\n")
                                    .split("(MP3")[0]
                                : songs[controller.audioPlayer.currentIndex ??
                                        index]
                                    .displayNameWOExt
                                    .replaceAll("_", "\n"),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: getFont(20),
                                fontWeight: FontWeight.bold),
                          ),
                          Column(
                            children: [
                              ValueListenableBuilder<ProgressBarState>(
                                valueListenable: controller.progressNotifier,
                                builder: (_, value, __) {
                                  return ProgressBar(
                                    progress: value.current,
                                    buffered: value.buffered,
                                    total: value.total,
                                    baseBarColor: AppColors.secondryColor,
                                    thumbColor: AppColors.primaryColor,
                                    progressBarColor: AppColors.primaryColor,
                                    onSeek: controller.seek,
                                  );
                                },
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  IconClickItem(
                                    change: false,
                                    icon: Icons.skip_previous,
                                    onTap: () {
                                      controller.previousSong();
                                    },
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor),
                                    child: ValueListenableBuilder<ButtonState>(
                                      valueListenable:
                                          controller.buttonNotifier,
                                      builder: (_, value, __) {
                                        switch (value) {
                                          case ButtonState.loading:
                                            return Container(
                                              margin: const EdgeInsets.all(8.0),
                                              width: 32.0,
                                              height: 32.0,
                                              child:
                                                  const CircularProgressIndicator(),
                                            );
                                          case ButtonState.paused:
                                            return IconClickItem(
                                              change: false,
                                              icon: Icons.play_arrow_sharp,
                                              onTap: controller.play,
                                            );
                                          case ButtonState.playing:
                                            return IconClickItem(
                                              change: false,
                                              icon: Icons.pause,
                                              onTap: controller.pause,
                                            );
                                        }
                                      },
                                    ),
                                  ),
                                  IconClickItem(
                                    change: false,
                                    icon: Icons.skip_next,
                                    onTap: () {
                                      controller.nextSong();
                                    },
                                  ),
                                  Container(
                                    margin:
                                        EdgeInsets.only(right: getWidth(10)),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor),
                                    child: controller.volume == 0
                                        ? IconClickItem(
                                            change: false,
                                            icon: Icons.volume_mute_rounded,
                                            onTap: () {
                                              controller.volume = 100;
                                              controller.changeVolume();
                                            },
                                          )
                                        : IconClickItem(
                                            onTap: () {
                                              controller.volume = 0;
                                              controller.changeVolume();
                                            },
                                            change: false,
                                            icon: Icons.volume_up_rounded,
                                          ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ));
      },
    );
  }
}
