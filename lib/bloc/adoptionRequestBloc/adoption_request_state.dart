part of 'adoption_request_cubit.dart';

abstract class AdoptionRequestState {}

final class AdoptionRequestInitial extends AdoptionRequestState {}
final class AdoptionRequestLoadingState extends AdoptionRequestState {}
final class AdoptionRequestSuccessState extends AdoptionRequestState {}
final class AdoptionRequestErrorState extends AdoptionRequestState {
  String error;
  AdoptionRequestErrorState(this.error);
}
