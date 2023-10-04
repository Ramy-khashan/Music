import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

part 'music_list_state.dart';

class MusicListCubit extends Cubit<MusicListState> {
  MusicListCubit() : super(MusicListInitial());
  static MusicListCubit get(context) => BlocProvider.of(context);
  final OnAudioQuery audioQuery = OnAudioQuery();

  bool hasPermission = false;
  checkAndRequestPermissions({bool retry = false}) async {
    hasPermission = await audioQuery.checkAndRequest(
      retryRequest: retry,
    );
    hasPermission ? emit(state) : null;
  }

  getSongs() async {
    audioQuery.queryPlaylists().then((List<PlaylistModel> value) {
      audioQuery.queryAllPath().then((List<String> value) {});
    });
  }

  addToPlaylist({required int playlistId, required int songId}) async {
    await [
      Permission.manageExternalStorage,
    ].request().then((value) {
      print(playlistId);
      print(songId);
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
