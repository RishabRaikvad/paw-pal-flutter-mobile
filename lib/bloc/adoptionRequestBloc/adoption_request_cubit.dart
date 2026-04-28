import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:paw_pal_mobile/core/AppColors.dart';
import 'package:paw_pal_mobile/core/CommonMethods.dart';
import 'package:paw_pal_mobile/model/adoption_request_model.dart';
import 'package:paw_pal_mobile/progress_loader_screen.dart';
import 'package:paw_pal_mobile/services/firebase_auth_service.dart';

part 'adoption_request_state.dart';

enum RequestType { all, sent, received }

class AdoptionRequestCubit extends Cubit<AdoptionRequestState> {
  FirebaseService service;
  RequestType selectedRequestType = RequestType.all;

  AdoptionRequestCubit(this.service) : super(AdoptionRequestInitial());
  List<AdoptionRequestModel> lstAdoption = [];
  List<AdoptionRequestModel> filterAdoptionList = [];
  String searchQuery = "";

  Future<void> getAdoptionRequest() async {
    emit(
      lstAdoption.isNotEmpty
          ? AdoptionRequestRefreshState()
          : AdoptionRequestLoadingState(),
    );
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
    List<AdoptionRequestModel> tempList;
    if (selectedFilter == null) {
      tempList = lstAdoption;
    } else {
      tempList = lstAdoption
          .where((adoption) => adoption.status == selectedFilter)
          .toList();
    }

    final user = CommonMethods.getCurrentUser();

    if (user != null) {
      if (selectedRequestType == RequestType.sent) {
        tempList = tempList.where((e) => e.petOwnerId != user.uid).toList();
      } else if (selectedRequestType == RequestType.received) {
        tempList = tempList.where((e) => e.petOwnerId == user.uid).toList();
      }
    }

    if (searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase().trim();

      tempList = tempList.where((adoption) {
        return adoption.petName.toLowerCase().contains(query) ||
            adoption.fullName.toLowerCase().contains(query) ||
            adoption.ownerName.toLowerCase().contains(query);
      }).toList();
    }
    filterAdoptionList = tempList;
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
      if (context.mounted) {
        context.pop();
      }
    } catch (e) {
      CommonMethods().showErrorToast("Failed $e");
    } finally {
      if (context.mounted) {
        LoadingDialog.hide(context);
      }
    }
  }

  String getRequestStatusTitle(AdoptionStatus status) {
    if (status == AdoptionStatus.approved) {
      return "Approved";
    } else if (status == AdoptionStatus.rejected) {
      return "Rejected";
    }else if(status == AdoptionStatus.completed){
      return "Completed";
    }
    return "Pending";
  }

  Color getRequestStatusColor(AdoptionStatus status) {
    if (status == AdoptionStatus.approved) {
      return AppColors.approvedColor;
    } else if (status == AdoptionStatus.rejected) {
      return AppColors.rejectedColor;
    }else if(status == AdoptionStatus.completed){
       return AppColors.completeColor;
    }
    return AppColors.pendingColor;
  }

  String getRequestTitle(AdoptionStatus status, bool isSentByMe) {
    if (status == AdoptionStatus.pending) {
      if (!isSentByMe) {
        return "Your request has been sent. Waiting for the owner to review it.";
      } else {
        return "Check adopter details before accepting or rejecting the request.";
      }
    } else if (status == AdoptionStatus.rejected) {
      if (!isSentByMe) {
        return "Your adoption request was declined. You can explore other pets to adopt.";
      } else {
        return "You declined this adoption request. The requester has been notified.";
      }
    } else if (status == AdoptionStatus.approved) {
      if (!isSentByMe) {
        return "Good news! Your adoption request is approved. Complete payment to welcome your pet home.";
      } else {
        return "Adoption request approved. Waiting for payment to complete the process.";
      }
    }
    else if(status == AdoptionStatus.completed){
      if(isSentByMe){
        return "Adoption completed successfully. Your pet has found a loving and caring forever home today.";
      }else{
         return "Adoption completed successfully. You can now welcome your pet home and start your journey together.";
      }
    }
    return "";
  }

  Future<void> completeAdoption(BuildContext context,AdoptionRequestModel model) async {
    LoadingDialog.show(context);
    try{
      await service.completeAdoptionProcess(model);
      await getAdoptionRequest();
      CommonMethods().showSuccessToast("🎉 Adoption completed! The pet now has a new home.");
    }catch(e){
      debugPrint("Error while complete adoption process : $e");
    }finally{
      if(context.mounted){
        LoadingDialog.hide(context);
      }
    }
  }

  void onSearchChange(String value) {
    searchQuery = value;
    _applyFilter();
    emit(AdoptionRequestSuccessState());
  }

  void changeRequestType(RequestType type) {
    selectedRequestType = type;
    _applyFilter();
    emit(AdoptionRequestSuccessState());
  }

  void resetData() {
    lstAdoption = [];
    filterAdoptionList = [];
    emit(AdoptionRequestInitial());
  }
}
