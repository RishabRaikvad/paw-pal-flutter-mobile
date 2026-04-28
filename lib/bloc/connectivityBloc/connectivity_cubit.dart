import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConnectivityCubit extends Cubit<bool> {
  final Connectivity _connectivity = Connectivity();

  ConnectivityCubit() : super(true) {
    _connectivity.onConnectivityChanged.listen((results) {
      final hasConnection = results.isNotEmpty &&
          !results.contains(ConnectivityResult.none);

      emit(hasConnection);
    });
  }

  Future<void> checkConnection() async {
    final results = await _connectivity.checkConnectivity();
    final hasConnection = results.isNotEmpty &&
        !results.contains(ConnectivityResult.none);

    emit(hasConnection);
  }
}