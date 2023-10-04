 
import 'package:flutter_bloc/flutter_bloc.dart';
 import 'package:fluttertoast/fluttertoast.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

part 'list_music_specific_state.dart';

class ListMusicSpecificCubit extends Cubit<ListMusicSpecificState> {
  ListMusicSpecificCubit(this.songs) : super(ListMusicSpecificInitial());
  static ListMusicSpecificCubit get(context) => BlocProvider.of(context);
  final OnAudioQuery audioQuery = OnAudioQuery();

  List<SongModel> songs = [];
  removeSongs(
      {required int playlistId,
      required int audioId,
      required int index}) async {
    emit(ListMusicSpecificInitial());

    await audioQuery.removeFromPlaylist(playlistId, audioId).then((value) {
      if (value) {
        Fluttertoast.showToast(msg: "Removed succssfully");
        songs.removeAt(index);
      } else {
        Fluttertoast.showToast(msg: "Failed to remove");
      }
      emit(RemoveSongState());
    });
  }

  addToPlaylist({required int playlistId, required int songId}) async {
    await [
      Permission.manageExternalStorage,
    ].request().then((value) {
      audioQuery.addToPlaylist(playlistId, songId).then((value) {
        if (value) {
          Fluttertoast.showToast(msg: "Add audio to playlist successfully");
        } else {
          Fluttertoast.showToast(msg: "Failed to add audio");
        }
      });
    });
  }
  
}
