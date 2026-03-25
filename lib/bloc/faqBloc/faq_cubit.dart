import 'package:bloc/bloc.dart';
import 'package:paw_pal_mobile/services/firebase_auth_service.dart';

import '../../model/faq_model.dart';

part 'faq_state.dart';

class FaqCubit extends Cubit<FaqState> {
  final FirebaseService services;

  FaqCubit(this.services) : super(FaqInitial());
  List<FaqModel> lstFaq = [];
  Set<int> expandedIndexes = {};

  Future<void> getFaqs() async {
    emit(lstFaq.isEmpty ? FaqLoadState() : FaqRefreshState());

    try {
      lstFaq = await services.getFaq();
      emit(FaqSuccessState());
    } catch (e) {
      emit(FaqErrorState(e.toString()));
    }
  }

  void toggleFaq(int index) {
    expandedIndexes.contains(index)
        ? expandedIndexes.remove(index)
        : expandedIndexes.add(index);

    emit(FaqUpdateState());
  }
}
