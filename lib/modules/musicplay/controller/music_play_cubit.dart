 
import 'package:flutter_bloc/flutter_bloc.dart';
 import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../../config/controller/audio_app_controller_cubit.dart';
import '../../../music_app.dart';
part 'music_play_state.dart';

class MusicPlayCubit extends Cubit<MusicPlayState> {
  MusicPlayCubit(this.songs, this.index) : super(MusicPlayInitial()) {
    audiouConvert();
  }
  static MusicPlayCubit get(context) => BlocProvider.of(context);

  List<SongModel> songs = [];
  int index = -1;
  List<AudioSource> audios = [];
  audiouConvert() {
    for (var element in songs) {
      audios.add(AudioSource.uri(
        Uri.parse(element.data ),
        tag: MediaItem(
          id: element.id.toString(),
          album: element.album,
          title: element.title,
          artUri: Uri.parse(
              //  "https://firebasestorage.googleapis.com/v0/b/have-fun-a5c87.appspot.com/o/showImage%2Fic_launcher_background.png?alt=media&token=8bb5c4f2-0932-4aac-ad17-2c613b1af909"
              "https://firebasestorage.googleapis.com/v0/b/have-fun-a5c87.appspot.com/o/music_logo1.png?alt=media&token=513533de-9aef-4d41-8a35-15fd891eb2f6&_gl=1*1pbmzvy*_ga*NzkyOTM3MzM4LjE2NzgzMjI1MTc.*_ga_CW55HF8NVT*MTY5NjE0OTYyMi44MC4xLjE2OTYxNDk2NjIuMjAuMC4w"),
        ),
      ));
    }
    BlocProvider.of<AudioAppControllerCubit>(
            MusicApp.navigatorKey.currentContext!)
        .init(audios: audios, index: index);
  }
   
}
