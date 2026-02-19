// presentation/providers/home/home_provider.dart
import 'package:flutter/material.dart';
import '../../../core/utils/connectivity_helper.dart';

class HomeProvider extends ChangeNotifier {
  String _currentCity = 'New York';
  bool _hasInternet = true;
  bool _isLoading = false;

  // Getters
  String get currentCity => _currentCity;
  bool get hasInternet => _hasInternet;
  bool get isLoading => _isLoading;

  // Setters with notification
  set currentCity(String city) {
    if (_currentCity != city) {
      _currentCity = city;
      notifyListeners();
    }
  }

  set hasInternet(bool value) {
    if (_hasInternet != value) {
      _hasInternet = value;
      notifyListeners();
    }
  }

  set isLoading(bool value) {
    if (_isLoading != value) {
      _isLoading = value;
      notifyListeners();
    }
  }

  // Methods
  Future<void> checkConnectivity() async {
    isLoading = true;
    hasInternet = await ConnectivityHelper.hasInternetConnection();
    isLoading = false;
  }

  void updateCity(String city) {
    currentCity = city;
  }

  // Clean up
  @override
  void dispose() {
    super.dispose();
  }
}