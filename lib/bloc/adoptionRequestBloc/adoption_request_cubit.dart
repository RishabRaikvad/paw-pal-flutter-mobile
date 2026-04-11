import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:paw_pal_mobile/core/CommonMethods.dart';
import 'package:paw_pal_mobile/model/adoption_request_model.dart';
import 'package:paw_pal_mobile/progress_loader_screen.dart';
import 'package:paw_pal_mobile/services/firebase_auth_service.dart';

part 'adoption_request_state.dart';

class AdoptionRequestCubit extends Cubit<AdoptionRequestState> {
  FirebaseService service;

  AdoptionRequestCubit(this.service) : super(AdoptionRequestInitial());
  List<AdoptionRequestModel> lstAdoption = [];
  List<AdoptionRequestModel> filterAdoptionList = [];

  Future<void> getAdoptionRequest() async {
    emit(AdoptionRequestLoadingState());
    try {
      lstAdoption = await service.myAdoptionRequests();
      _applyFilter();
      emit(AdoptionRequestSuccessState());
    } catch (e) {
      debugPrint("Error in request :- ${e.toString()}");
      emit(AdoptionRequestErrorState(e.toString()));
    }
  }

  String timeAgo(DateTime dateTime) {
    final now = DateTime.now().toLocal();
    final localDate = dateTime.toLocal(); // 🔥 FIX

    final difference = now.difference(localDate);

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
      return "${difference.inDays} days ago";
    } else if (difference.inDays < 30) {
      return "${(difference.inDays / 7).floor()} weeks ago";
    } else if (difference.inDays < 365) {
      return "${(difference.inDays / 30).floor()} months ago";
    } else {
      return "${(difference.inDays / 365).floor()} years ago";
    }
  }

  AdoptionStatus? selectedFilter;

  void _applyFilter() {
    if (selectedFilter == null) {
      filterAdoptionList = lstAdoption;
    } else {
      filterAdoptionList = lstAdoption
          .where((adoption) => adoption.status == selectedFilter)
          .toList();
    }
  }

  void onFilterChange(AdoptionStatus? status) {
    selectedFilter = status;
    _applyFilter();
    emit(AdoptionRequestSuccessState());
  }

  Future<void> acceptOrRejectRequest({
    required BuildContext context,
    required String requestId,
    required AdoptionStatus status,
  }) async {
    LoadingDialog.show(context);
    try {
      await service.updateRequestStatus(requestId, status);
      await getAdoptionRequest();
      if (status == AdoptionStatus.approved) {
        CommonMethods().showSuccessToast("Request Approved Successfully");
      } else if (status == AdoptionStatus.rejected) {
        CommonMethods().showSuccessToast("Request Rejected Successfully");
      }
    } catch (e) {
      CommonMethods().showErrorToast("Failed $e");
    } finally {
      if (context.mounted) {
        LoadingDialog.hide(context);
      }
    }
  }
}
