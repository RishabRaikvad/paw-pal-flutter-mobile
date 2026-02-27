part of 'video_cubit.dart';

abstract class VideoState {}

final class VideoInitial extends VideoState {}

final class VideoLoadingState extends VideoState {}

final class VideoRefreshState extends VideoState {}

final class VideoSuccessState extends VideoState {}

final class VideoErrorState extends VideoState {
  final String error;

  VideoErrorState(this.error);
}
