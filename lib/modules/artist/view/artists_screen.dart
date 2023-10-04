import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/size_config.dart';
import '../controller/artist_cubit.dart';

class ArtistsScreen extends StatelessWidget {
  const ArtistsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ArtistsCubit()..getArtists(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          title: Text(
            "Artists",
            style:
                TextStyle(fontWeight: FontWeight.bold, fontSize: getFont(30)),
          ),
        ),
        body: BlocBuilder<ArtistsCubit, ArtistsState>(
          builder: (context, state) {
            final controller = ArtistsCubit.get(context);
            return controller.isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : controller.isFaild
                    ? const Center(
                        child: Text("Something went wrong, Try again later!"),
                      )
                    : controller.artists.isEmpty
                        ? const Center(
                            child: Text("No Artists Exisit!",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24,fontFamily: "title")),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.only(top: 7),
                            itemCount: controller.artists.length,
                            itemBuilder: (context, index) => Card(
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              child: ListTile(
                                onTap: (){
                                  controller.getArtistSongs(controller.artists[index],context);
                                },
                                title: Text(
                                  controller.artists[index].artist,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        "Number of Albums ${controller.artists[index].numberOfAlbums}"),  Text(
                                        "Number of Tracks ${controller.artists[index].numberOfTracks}"),
                                  ],
                                ),
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
