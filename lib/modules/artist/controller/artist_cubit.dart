import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../list_music_specific/view/list_music_specific_screen.dart';

part 'artist_state.dart';

class ArtistsCubit extends Cubit<ArtistsState> {
  ArtistsCubit() : super(ArtistsInitial());
  static ArtistsCubit get(context) => BlocProvider.of(context);
  final OnAudioQuery audioQuery = OnAudioQuery();
  List<ArtistModel> artists = [];
  bool isLoading = false;
  bool isFaild = false;
  getArtists() async {
    isLoading = true;
    emit(LoadingGetArtistsState());
    try {
      artists = await audioQuery.queryArtists();
    } catch (e) {
      isFaild = true;
    }
    isLoading = false;
    emit(GetGetArtistsState());
  }

  getArtistSongs(ArtistModel artists, context) async {
    List<SongModel> audios = await audioQuery.queryAudiosFrom(
      AudiosFromType.ARTIST_ID,
      artists.id,
      orderType: OrderType.ASC_OR_SMALLER,
      ignoreCase: true,
    );
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ListMusicSpecificScreen(
            id: artists.id,
            albumName: artists.artist,
            songsList: audios,
          ),
        ));
  }
}
