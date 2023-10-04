import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../list_music_specific/view/list_music_specific_screen.dart';

part 'albums_state.dart';

class AlbumsCubit extends Cubit<AlbumsState> {
  AlbumsCubit() : super(AlbumsInitial());
  static AlbumsCubit get(context) => BlocProvider.of(context);
  final OnAudioQuery audioQuery = OnAudioQuery();
  List<AlbumModel> albums = [];
  bool isLoading = false;
  bool isFaild = false;
  getAlbums() async {
    isLoading = true;
    emit(LoadingGetAlbumsState());
    try {
      albums = await audioQuery.queryAlbums();
    } catch (e) {
      isFaild = true;
    }
    isLoading = false;
    emit(GetGetAlbumsState());
  }

  getAlbumSongs(AlbumModel album,context) async {
    List<SongModel> audios = await audioQuery.queryAudiosFrom(
      AudiosFromType.ALBUM_ID,
      album.id,
      orderType: OrderType.ASC_OR_SMALLER,
    
      ignoreCase: true,
    );
    Navigator.push(context, MaterialPageRoute(builder: (context) => ListMusicSpecificScreen(id:  album.id,albumName: album.album,songsList: audios,),));
  }
}
