import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../list_music_specific/view/list_music_specific_screen.dart';

part 'playlist_state.dart';

class PlaylistCubit extends Cubit<PlaylistState> {
  PlaylistCubit() : super(PlaylistInitial());
  static PlaylistCubit get(context) => BlocProvider.of(context);
  final OnAudioQuery audioQuery = OnAudioQuery();
  List<PlaylistModel> playlist = [];
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isFaild = false;
  final playlistController = TextEditingController();
  getPlaylist() async {
    isLoading = true;
    emit(LoadingGetPlaylistState());
    try {
      playlist = await audioQuery.queryPlaylists();
    } catch (e) {
      isFaild = true;
    }
    isLoading = false;
    emit(GetGetPlaylistState());
  }

  createPlayList() async {
    audioQuery.createPlaylist(playlistController.text.trim()).then((value) {
      if (value) {
        Fluttertoast.showToast(msg: "Playlist created successfully");
        getPlaylist();
      } else {
        Fluttertoast.showToast(
            msg: "Faild to create ${playlistController.text.trim()} Playlist");
      }
    });
  }

  removePlayList({required int id, required String name}) async {
    audioQuery.removePlaylist(id).then((value) {
      if (value) {
        Fluttertoast.showToast(msg: "Playlist removed successfully");
        getPlaylist();
      } else {
        Fluttertoast.showToast(msg: "Faild to remove $name Playlist");
      }
    });
  }

  renamePlayList({required int id, required String newName}) async {
    audioQuery.renamePlaylist(id, newName).then((value) {
      if (value) {
        Fluttertoast.showToast(msg: "Playlist renamed successfully");
        getPlaylist();
      } else {
        Fluttertoast.showToast(msg: "Faild to rename this playlist");
      }
    });
  }

  getPlaylistSongs(PlaylistModel playlist, context) async {
     List<SongModel> audios = await audioQuery.queryAudiosFrom(
      AudiosFromType.PLAYLIST,
      playlist.id,
    );
    print("audios ${audios.length}");
    audios.forEach((element) {
      print(playlist.data!+"/0");
      print(playlist.getMap);
      print(element.uri);
      print(element.data);
      print(element.dateAdded.toString());
      print(element.getMap);
      print(element.id);
      print(element.title);
      print(element.track);
    });
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ListMusicSpecificScreen(
            id: playlist.id,
            albumName: playlist.playlist,
            songsList: audios,
            type: "playlist",
          ),
        ));
  }
}
