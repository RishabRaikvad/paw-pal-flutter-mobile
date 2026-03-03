part of 'faq_cubit.dart';

abstract class FaqState {}

final class FaqInitial extends FaqState {}

final class FaqLoadState extends FaqState {}

final class FaqRefreshState extends FaqState {}

final class FaqSuccessState extends FaqState {}
final class FaqUpdateState extends FaqState {}

final class FaqErrorState extends FaqState {
  final String error;

  FaqErrorState(this.error);
}
