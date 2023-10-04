import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import '../../../core/utils/shared_prefrance_utils.dart';
import '../../../core/utils/size_config.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../../config/controller/audio_app_controller_cubit.dart';
import '../../../core/widgets/no_access_item.dart';
import '../../musicplay/view/musicplay.dart';
import '../controller/music_list_cubit.dart';
// import 'widgets/pop_up_menu_item.dart';

class MusicListScreen extends StatelessWidget {
  MusicListScreen({super.key});
  final onAudioQuery = OnAudioQuery();
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return BlocProvider(
      create: (context) => MusicListCubit()
        ..checkAndRequestPermissions()
        ..getSongs(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          title: Text(
            "Music",
            style:
                TextStyle(fontWeight: FontWeight.bold, fontSize: getFont(30)),
          ),
        ),
        body: BlocBuilder<MusicListCubit, MusicListState>(
          builder: (context, state) {
            final controller = MusicListCubit.get(context);
            return SafeArea(
              child: !controller.hasPermission
                  ? Center(
                      child: NoAccessToStorageItem(
                        onPressed: () {
                          controller.checkAndRequestPermissions(retry: true);
                        },
                      ),
                    )
                  : FutureBuilder<List<SongModel>>(
                      future: controller.audioQuery.querySongs(
                        sortType: null,
                        orderType: OrderType.ASC_OR_SMALLER,
                        uriType: UriType.EXTERNAL,
                        ignoreCase: true,
                      ),
                      builder: (context, item) {
                        if (item.hasError) {
                          return Text(item.error.toString());
                        }
                        if (item.data == null) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        // 'Library' is empty.
                        if (item.data!.isEmpty) {
                          return const Text("Nothing found!",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24,fontFamily: "title"));
                        }
                        String songIndex =
                            PreferenceUtils.getString("song_index");

                        return Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    onTap: () async {
                                      await PreferenceUtils.setString(
                                              "song_index", index.toString())
                                          .then((value) {
                                        try {
                                          if (BlocProvider.of<
                                                      AudioAppControllerCubit>(
                                                  context)
                                              .audioPlayer
                                              .playing) {
                                            BlocProvider.of<
                                                        AudioAppControllerCubit>(
                                                    context)
                                                .audioPlayer
                                                .dispose();
                                          }
                                        } catch (e) {}

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => MusicPlay(
                                                    songs: item.data!,
                                                    index: index,
                                                  )),
                                        );
                                      });
                                    },
                                    // leading:
                                    //  QueryArtworkWidget(
                                    //   controller: controller.audioQuery,
                                    //   id: item.data![index].id,
                                    //   type: ArtworkType.AUDIO,
                                    // ),
                                    leading: Container(
                                      width: 75,
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: FutureBuilder(
                                          future: MetadataRetriever.fromFile(
                                              File(item.data![index].data)),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasError) {
                                              return Image.asset(
                                                "assets/images/not_exsist.gif",
                                                fit: BoxFit.fill,
                                              );
                                            } else if (snapshot.hasData) {
                                              return snapshot.data!.albumArt ==
                                                      null
                                                  ? Image.asset(
                                                      "assets/images/not_exsist.gif",
                                                      fit: BoxFit.fill,
                                                    )
                                                  : Image.memory(
                                                      snapshot.data!.albumArt!,
                                                      fit: BoxFit.fill,
                                                    );
                                            }
                                            return const Center(
                                                child:
                                                    CircularProgressIndicator());
                                          }),
                                    ),
                                    title: Text(
                                      item.data![index].displayName.toString(),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: getFont(20),
                                          color: Colors.tealAccent.shade400),
                                    ),
                                    subtitle: Text(
                                      item.data![index].artist.toString(),
                                      style: TextStyle(
                                          fontSize: getFont(18),
                                          color: Colors.grey.shade400),
                                    ),
                                    // ignore: prefer_const_constructors
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: const [
                                        // if (songIndex == index.toString())
                                        Icon(Icons.music_note),
                                        // PopupMenuItemShape(
                                        //     item: item.data![index])
                                      ],
                                    ),
                                  );
                                },
                                itemCount: item.data!.length,
                              ),
                            ),
                            songIndex.isEmpty
                                ? const SizedBox()
                                : Card(
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    child: ListTile(
                                      onTap: () {
                                        try {
                                          if (BlocProvider.of<
                                                      AudioAppControllerCubit>(
                                                  context)
                                              .audioPlayer
                                              .playing) {
                                            BlocProvider.of<
                                                        AudioAppControllerCubit>(
                                                    context)
                                                .audioPlayer
                                                .dispose();
                                          }
                                        } catch (e) {}

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => MusicPlay(
                                                    songs: item.data!,
                                                    index: int.parse(songIndex),
                                                  )),
                                        );
                                      },
                                      title: Text(
                                        item.data![int.parse(songIndex)].title,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      subtitle: const Text("Last Song"),
                                      trailing: const Icon(
                                          Icons.arrow_forward_ios_rounded),
                                    ),
                                  )
                          ],
                        );
                      }),
            );
          },
        ),
      ),
    );
  }
}
