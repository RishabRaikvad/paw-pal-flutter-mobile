import 'package:bloc/bloc.dart';
import 'package:paw_pal_mobile/model/video_model.dart';

import '../../services/firestore_service.dart';

part 'video_state.dart';

class VideoCubit extends Cubit<VideoState> {
  VideoCubit() : super(VideoInitial());
  final fireStore = FireStoreService().fireStore;
  List<VideoModel> lstPetCareVideo = [];

  Future<void> getPetCareVideos() async {
    emit(lstPetCareVideo.isEmpty ? VideoLoadingState() : VideoRefreshState());
    try {
      final snapshot = await fireStore
          .collection("pet_care_videos")
          .where("isVisible", isEqualTo: true)
          .get();
      lstPetCareVideo = snapshot.docs
          .map((doc) => VideoModel.fromJson(doc.data()))
          .toList();

      emit(VideoSuccessState());
    } catch (e) {
      emit(VideoErrorState(e.toString()));
    }
  }

  String searchQuery = "";

  void searchVideos(String query) {
    searchQuery = query.toLowerCase();
    emit(VideoSuccessState());
  }

  List<VideoModel> get filteredVideos {
    if (searchQuery.isEmpty) return lstPetCareVideo;

    return lstPetCareVideo.where((video) {
      return video.videoTitle.toLowerCase().contains(searchQuery);
    }).toList();
  }
}
