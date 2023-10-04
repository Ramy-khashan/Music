 import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_audio_query/on_audio_query.dart';
 
import '../../albums/view/albums_screen.dart';
import '../../artist/view/artists_screen.dart';
import '../../music_list/view/musiclist.dart';
import '../../playlists/view/playlist_screen.dart';
import '../model/partition_model.dart';

part 'home_page_state.dart';

class HomePageCubit extends Cubit<HomePageState> {
  HomePageCubit() : super(HomePageInitial());
  static HomePageCubit get(context)=>BlocProvider.of(context);
    final OnAudioQuery audioQuery = OnAudioQuery();

  getPermission()async{

    await audioQuery.checkAndRequest(
      retryRequest: true,
    );
  }
  List<PartitionModel> musicPartition = [
    PartitionModel(title: 'My Music', image: "songs.png", page: MusicListScreen()),
    PartitionModel(title: 'Albums', image: "album_song.png", page: const AlbumsScreen()),
    PartitionModel(title: 'Artist', image: "artist_song.png", page: const ArtistsScreen()),
    PartitionModel(title: 'Playlist', image: "playlist.png", page: const PlaylistScreen()),
    // PartitionModel(title: 'Favorite', image: "favorite_song.png", page: const Scaffold()),
  ];
}
