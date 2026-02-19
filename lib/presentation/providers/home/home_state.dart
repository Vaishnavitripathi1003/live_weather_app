// presentation/providers/home/home_state.dart
import 'package:flutter/foundation.dart';

import '../../../core/utils/connectivity_helper.dart';

class HomeState {
  final String currentCity;
  final bool hasInternet;
  final bool isLoading;
  final String? errorMessage;

  const HomeState({
    required this.currentCity,
    required this.hasInternet,
    required this.isLoading,
    this.errorMessage,
  });

  factory HomeState.initial() {
    return const HomeState(
      currentCity: 'New York',
      hasInternet: true,
      isLoading: false,
      errorMessage: null,
    );
  }

  HomeState copyWith({
    String? currentCity,
    bool? hasInternet,
    bool? isLoading,
    String? errorMessage,
  }) {
    return HomeState(
      currentCity: currentCity ?? this.currentCity,
      hasInternet: hasInternet ?? this.hasInternet,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}


class HomeProvider extends ChangeNotifier {
  HomeState _state = HomeState.initial();

  HomeState get state => _state;

  void updateCity(String city) {
    _state = _state.copyWith(currentCity: city);
    notifyListeners();
  }

  Future<void> checkConnectivity() async {
    _state = _state.copyWith(isLoading: true);
    notifyListeners();

    try {
      final hasInternet = await ConnectivityHelper.hasInternetConnection();
      _state = _state.copyWith(
        hasInternet: hasInternet,
        isLoading: false,
        errorMessage: null,
      );
    } catch (e) {
      _state = _state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
    notifyListeners();
  }

  void setHasInternet(bool value) {
    _state = _state.copyWith(hasInternet: value);
    notifyListeners();
  }

  void clearError() {
    _state = _state.copyWith(errorMessage: null);
    notifyListeners();
  }
}