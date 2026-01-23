import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit() : super(DashboardInitial());

  final ValueNotifier<int> selectedTab = ValueNotifier(0);

  void onTabChange(int index){
    selectedTab.value = index;
  }
}
