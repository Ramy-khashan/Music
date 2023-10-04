part of 'audio_app_controller_cubit.dart';

 abstract class AudioAppControllerState {}

  class AudioAppControllerInitial extends AudioAppControllerState {}
class LoadingAudioState extends AudioAppControllerState {}
class PlayingAudioState extends AudioAppControllerState {}
class PausedAudioState extends AudioAppControllerState {}
class GetDurationState extends AudioAppControllerState {}
class GetRandomImageState extends AudioAppControllerState {}
class ChangeAudioVolumeState extends AudioAppControllerState {}
class PreviousMusicState extends AudioAppControllerState {}
class NextMusicState extends AudioAppControllerState {}
class ChangeAudioState extends AudioAppControllerState {}
class SetSongState extends AudioAppControllerState {}