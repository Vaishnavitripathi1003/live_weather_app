class NetworkException implements Exception {
  final String message;
  final int? statusCode;

  NetworkException(this.message, [this.statusCode]);

  @override
  String toString() => 'NetworkException: $message';
}

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  ApiException(this.message, {this.statusCode, this.data});

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}

class TimeoutException implements Exception {
  final String message;
  TimeoutException([this.message = 'Request timeout']);

  @override
  String toString() => 'TimeoutException: $message';
}

class NoInternetException implements Exception {
  final String message;
  NoInternetException([this.message = 'No internet connection']);

  @override
  String toString() => 'NoInternetException: $message';
}

class CityNotFoundException implements Exception {
  final String city;
  CityNotFoundException(this.city);

  @override
  String toString() => 'CityNotFoundException: $city not found';
}