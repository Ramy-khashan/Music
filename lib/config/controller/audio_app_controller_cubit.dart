import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../core/utils/shared_prefrance_utils.dart';
import '../../core/utils/size_config.dart';
import '../../modules/musicplay/model/page_manager.dart';

part 'audio_app_controller_state.dart';

class AudioAppControllerCubit extends Cubit<AudioAppControllerState> {
  AudioAppControllerCubit() : super(AudioAppControllerInitial());
  static AudioAppControllerCubit get(context) => BlocProvider.of(context);

  nextSong() async {
    emit(AudioAppControllerInitial());

    await audioPlayer.seekToNext();

    emit(NextMusicState());
  }

  previousSong() async {
    emit(AudioAppControllerInitial());
    await audioPlayer.seekToPrevious();
    // }
    emit(PreviousMusicState());
  }

  late int duration = 0;
  late int selectedSongIndex;
  int selectedImage = 1;

  late AudioPlayer audioPlayer;
  double volume = 100;
  String? audioUrl;
  List<AudioSource> allAudios = [];
  int? initialIndex;
  Future init({required List<AudioSource> audios, required int index}) async {
    try {
      audioPlayer = AudioPlayer();
      allAudios = audios;
      initialIndex = index;
      await audioPlayer.setAudioSource(
          ConcatenatingAudioSource(children: audios),
          initialIndex: index);
      audioPlayer.playerStateStream.listen((playerState) {
        final isPlaying = playerState.playing;
        final processingState = playerState.processingState;
        if (processingState == ProcessingState.loading ||
            processingState == ProcessingState.buffering) {
          buttonNotifier.value = ButtonState.loading;
          emit(LoadingAudioState());
        } else if (!isPlaying) {
          buttonNotifier.value = ButtonState.paused;

          emit(PausedAudioState());
        } else if (processingState != ProcessingState.completed) {
          buttonNotifier.value = ButtonState.playing;

          emit(PlayingAudioState());
        } else {
          nextSong();
          // completed
        }
      });
      audioPlayer.positionStream.listen((position) {
        final oldState = progressNotifier.value;
        progressNotifier.value = ProgressBarState(
          current: position,
          buffered: oldState.buffered,
          total: oldState.total,
        );
      });
      audioPlayer.bufferedPositionStream.listen((bufferedPosition) {
        final oldState = progressNotifier.value;
        progressNotifier.value = ProgressBarState(
          current: oldState.current,
          buffered: bufferedPosition,
          total: oldState.total,
        );
      });
      audioPlayer.durationStream.listen((totalDuration) {
        final oldState = progressNotifier.value;
        progressNotifier.value = ProgressBarState(
          current: oldState.current,
          buffered: oldState.buffered,
          total: totalDuration ?? Duration.zero,
        );
      });
      audioPlayer.play();
    } catch (e) {
      audioPlayer.dispose();
      await init(audios: audios, index: index);
    }
    // test();
  }

  void seek(Duration position) {
    audioPlayer.seek(position);
  }

  void play() async {
    await audioPlayer.play();
  }

  void pause() async {
    await audioPlayer.pause();
  }

  void stop() async {
    await audioPlayer.stop();
    init(index: audioPlayer.currentIndex!, audios: allAudios);
  }

  void speed() async {
    await audioPlayer.setSpeed(2.0);
  }

  void changeVolume() async {
    await audioPlayer.setVolume(volume / 100);
    emit(ChangeAudioVolumeState());
  }

  final progressNotifier = ValueNotifier<ProgressBarState>(
    ProgressBarState(
      current: Duration.zero,
      buffered: Duration.zero,
      total: Duration.zero,
    ),
  );
  final buttonNotifier = ValueNotifier<ButtonState>(ButtonState.paused);

  showSongs(context, {required List<SongModel> songs}) => showModalBottomSheet(
        context: context,
        builder: (context) {
          String songIndex = PreferenceUtils.getString("song_index");
          return StatefulBuilder(builder: (context, snapshot) {
            return ListView.separated(
                itemBuilder: (context, i) => ListTile(
                      onTap: () async {
                        audioPlayer.stop();
                        audioPlayer.dispose();
                        List<AudioSource> audios = [];
                        for (var element in songs) {
                          audios.add(AudioSource.uri(
                            Uri.parse(element.uri!),
                            tag: MediaItem(
                              id: element.id.toString(),
                              album: element.album,
                              title: element.title,
                              artUri: Uri.parse(
                                  // "https://firebasestorage.googleapis.com/v0/b/have-fun-a5c87.appspot.com/o/showImage%2Fic_launcher_background.png?alt=media&token=8bb5c4f2-0932-4aac-ad17-2c613b1af909"
                                  "https://firebasestorage.googleapis.com/v0/b/have-fun-a5c87.appspot.com/o/music_logo1.png?alt=media&token=513533de-9aef-4d41-8a35-15fd891eb2f6&_gl=1*1pbmzvy*_ga*NzkyOTM3MzM4LjE2NzgzMjI1MTc.*_ga_CW55HF8NVT*MTY5NjE0OTYyMi44MC4xLjE2OTYxNDk2NjIuMjAuMC4w"),
                            ),
                          ));
                        }
                        await init(audios: audios, index: i);
                        PreferenceUtils.setString("song_index", i.toString())
                            .then((value) {
                          Navigator.pop(context);
                        });
                        emit(SetSongState());
                      },
                      title: Text(
                        songs[i].displayName.toString(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: getFont(20),
                            color: Colors.tealAccent.shade400),
                      ),
                      subtitle: Text(
                        songs[i].artist.toString(),
                        style: TextStyle(
                            fontSize: getFont(18), color: Colors.grey.shade400),
                      ),
                      trailing: songIndex == i.toString()
                          ? const Icon(Icons.music_note)
                          : null,
                    ),
                separatorBuilder: (context, index) => const SizedBox(),
                itemCount: songs.length);
          });
        },
      );
}
