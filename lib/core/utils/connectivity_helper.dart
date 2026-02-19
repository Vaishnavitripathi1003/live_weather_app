import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectivityHelper {
  static final Connectivity _connectivity = Connectivity();

  /// Check if device has internet connection
  static Future<bool> hasInternetConnection() async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      return connectivityResult != ConnectivityResult.none;
    } catch (e) {
      print('Connectivity check error: $e');
      return false;
    }
  }

  /// Get current connectivity status
  static Future<ConnectivityResult> getConnectivityStatus() async {
    try {
      return await _connectivity.checkConnectivity();
    } catch (e) {
      print('Connectivity status error: $e');
      return ConnectivityResult.none;
    }
  }

  /// Stream of connectivity changes
  static Stream<ConnectivityResult> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged;
  }

  /// Stream of boolean connectivity status (true if connected)
  static Stream<bool> get connectionStream {
    return _connectivity.onConnectivityChanged.map(
          (result) => result != ConnectivityResult.none,
    );
  }

  /// Check if current connection is WiFi
  static Future<bool> isWifiConnected() async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      return connectivityResult == ConnectivityResult.wifi;
    } catch (e) {
      print('WiFi check error: $e');
      return false;
    }
  }

  /// Check if current connection is Mobile Data
  static Future<bool> isMobileDataConnected() async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      return connectivityResult == ConnectivityResult.mobile;
    } catch (e) {
      print('Mobile data check error: $e');
      return false;
    }
  }

  /// Check if current connection is Ethernet
  static Future<bool> isEthernetConnected() async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      return connectivityResult == ConnectivityResult.ethernet;
    } catch (e) {
      print('Ethernet check error: $e');
      return false;
    }
  }

  /// Check if current connection is Bluetooth
  static Future<bool> isBluetoothConnected() async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      return connectivityResult == ConnectivityResult.bluetooth;
    } catch (e) {
      print('Bluetooth check error: $e');
      return false;
    }
  }

  /// Get connection type as string
  static Future<String> getConnectionType() async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      switch (connectivityResult) {
        case ConnectivityResult.wifi:
          return 'WiFi';
        case ConnectivityResult.mobile:
          return 'Mobile Data';
        case ConnectivityResult.ethernet:
          return 'Ethernet';
        case ConnectivityResult.bluetooth:
          return 'Bluetooth';
        case ConnectivityResult.none:
          return 'No Connection';
        default:
          return 'Unknown';
      }
    } catch (e) {
      print('Connection type error: $e');
      return 'Unknown';
    }
  }
}

/// Extension for ConnectivityResult to get friendly name
extension ConnectivityResultExtension on ConnectivityResult {
  String get name {
    switch (this) {
      case ConnectivityResult.wifi:
        return 'WiFi';
      case ConnectivityResult.mobile:
        return 'Mobile Data';
      case ConnectivityResult.ethernet:
        return 'Ethernet';
      case ConnectivityResult.bluetooth:
        return 'Bluetooth';
      case ConnectivityResult.none:
        return 'No Connection';
      default:
        return 'Unknown';
    }
  }

  bool get isConnected => this != ConnectivityResult.none;

  IconData get icon {
    switch (this) {
      case ConnectivityResult.wifi:
        return Icons.wifi;
      case ConnectivityResult.mobile:
        return Icons.network_cell;
      case ConnectivityResult.ethernet:
        return Icons.settings_ethernet;
      case ConnectivityResult.bluetooth:
        return Icons.bluetooth;
      case ConnectivityResult.none:
        return Icons.signal_wifi_off;
      default:
        return Icons.help_outline;
    }
  }
}

/// A widget that listens to connectivity changes
class ConnectivityListener extends StatefulWidget {
  final Widget child;
  final Function(bool isConnected)? onConnectionChanged;
  final Widget? noInternetWidget;

  const ConnectivityListener({
    Key? key,
    required this.child,
    this.onConnectionChanged,
    this.noInternetWidget,
  }) : super(key: key);

  @override
  State<ConnectivityListener> createState() => _ConnectivityListenerState();
}

class _ConnectivityListenerState extends State<ConnectivityListener> {
  bool _hasInternet = true;

  @override
  void initState() {
    super.initState();
    _checkInitialConnection();
    _listenToConnectivityChanges();
  }

  Future<void> _checkInitialConnection() async {
    final hasInternet = await ConnectivityHelper.hasInternetConnection();
    if (mounted) {
      setState(() {
        _hasInternet = hasInternet;
      });
      widget.onConnectionChanged?.call(hasInternet);
    }
  }

  void _listenToConnectivityChanges() {
    ConnectivityHelper.connectionStream.listen((isConnected) {
      if (mounted) {
        setState(() {
          _hasInternet = isConnected;
        });
        widget.onConnectionChanged?.call(isConnected);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasInternet && widget.noInternetWidget != null) {
      return widget.noInternetWidget!;
    }
    return widget.child;
  }
}