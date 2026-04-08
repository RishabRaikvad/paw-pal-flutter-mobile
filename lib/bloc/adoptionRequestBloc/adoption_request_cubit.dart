import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:paw_pal_mobile/model/adoption_request_model.dart';
import 'package:paw_pal_mobile/services/firebase_auth_service.dart';


part 'adoption_request_state.dart';

class AdoptionRequestCubit extends Cubit<AdoptionRequestState> {
  FirebaseService service;
  AdoptionRequestCubit(this.service) : super(AdoptionRequestInitial());
  List<AdoptionRequestModel> lstAdoption = [];
  List<AdoptionRequestModel> filterAdoptionList = [];
  Future<void> getAdoptionRequest()async{
    emit(AdoptionRequestLoadingState());
    try{
      lstAdoption = await service.myAdoptionRequests();
      filterAdoptionList = lstAdoption;
     emit(AdoptionRequestSuccessState());
    }catch(e){
      debugPrint("Error in request :- ${e.toString()}");
      emit(AdoptionRequestErrorState(e.toString()));
    }
  }

  String timeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 10) {
      return "Just now";
    } else if (difference.inSeconds < 60) {
      return "${difference.inSeconds} sec ago";
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes} min ago";
    } else if (difference.inHours < 24) {
      return "${difference.inHours} hr ago";
    } else if (difference.inDays == 1) {
      return "Yesterday";
    } else if (difference.inDays < 7) {
      return "${difference.inDays} day ago";
    } else if (difference.inDays < 30) {
      return "${(difference.inDays / 7).floor()} week ago";
    } else if (difference.inDays < 365) {
      return "${(difference.inDays / 30).floor()} month ago";
    } else {
      return "${(difference.inDays / 365).floor()} year ago";
    }
  }
}
