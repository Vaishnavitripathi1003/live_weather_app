// lib/presentation/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/routes/app_routes.dart';
import '../bloc/theme/theme_state.dart';
import '../bloc/weather/weather_bloc.dart';
import '../bloc/weather/weather_state.dart';
import '../bloc/weather/weather_event.dart';
import '../bloc/quote/quote_bloc.dart';
import '../bloc/quote/quote_state.dart';
import '../bloc/quote/quote_event.dart';
import '../bloc/theme/theme_bloc.dart';
import '../bloc/theme/theme_event.dart';
import '../widgets/custom_error_widget.dart';
import '../widgets/loading_widget.dart';
import '../widgets/weather_card.dart';
import '../widgets/forecast_card.dart';
import '../widgets/quote_card.dart';
import '../widgets/empty_state.dart';
import '../widgets/app_drawer.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/connectivity_helper.dart';
import '../../core/utils/responsive_helper.dart';
import '../../core/utils/location_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  String? _currentCity;
  bool _hasInternet = true;
  bool _isRefreshing = false;
  bool _isLoadingLocation = true;
  bool _locationPermissionDenied = false;
  bool _locationError = false;
  String? _locationErrorMessage;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeData();
    _setupConnectivityListener();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    _animationController.forward();
  }

  Future<void> _initializeData() async {
    await _checkConnectivity();
    await _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
      _locationError = false;
      _locationErrorMessage = null;
    });

    try {
      debugPrint('Getting current location...');

      bool isLocationEnabled = await LocationHelper.isLocationServiceEnabled();
      debugPrint('Location services enabled: $isLocationEnabled');

      if (!isLocationEnabled) {
        setState(() {
          _isLoadingLocation = false;
          _locationPermissionDenied = true;
          _locationError = true;
          _locationErrorMessage = 'Location services are disabled';
        });
        return;
      }

      LocationPermission permission = await LocationHelper.checkPermission();
      debugPrint('Current permission: $permission');

      if (permission == LocationPermission.denied) {
        debugPrint('Requesting permission...');
        permission = await LocationHelper.requestPermission();
        debugPrint('Permission after request: $permission');
      }

      if (permission == LocationPermission.deniedForever) {
        debugPrint('Permission denied forever');
        setState(() {
          _isLoadingLocation = false;
          _locationPermissionDenied = true;
          _locationError = true;
          _locationErrorMessage = 'Location permission denied permanently';
        });
        return;
      }

      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        debugPrint('Permission granted, getting position...');

        try {
          Position position = await LocationHelper.getCurrentPosition();
          debugPrint('Position: ${position.latitude}, ${position.longitude}');

          String cityName = await LocationHelper.getCityFromCoordinates(
              position.latitude,
              position.longitude
          );

          debugPrint('City from location: $cityName');

          if (cityName.isNotEmpty && cityName != 'Unknown Location') {
            setState(() {
              _currentCity = cityName;
              _locationPermissionDenied = false;
              _locationError = false;
              _isLoadingLocation = false;
            });
            _loadWeatherData();
          } else {
            setState(() {
              _isLoadingLocation = false;
              _locationError = true;
              _locationErrorMessage = 'Could not identify your city';
            });
          }
        } catch (e) {
          debugPrint('Error getting position: $e');
          setState(() {
            _isLoadingLocation = false;
            _locationError = true;
            _locationErrorMessage = 'Failed to get your location';
          });
        }
      }
    } catch (e) {
      debugPrint('Error in location process: $e');
      setState(() {
        _isLoadingLocation = false;
        _locationError = true;
        _locationErrorMessage = 'Something went wrong';
      });
    }
  }

  void _loadWeatherData() {
    if (_hasInternet && _currentCity != null) {
      debugPrint('Loading weather for city: $_currentCity');
      context.read<WeatherBloc>().add(FetchWeather(_currentCity!));
      context.read<QuoteBloc>().add(FetchQuote());
    }
  }

  void _setupConnectivityListener() {
    ConnectivityHelper.connectionStream.listen((isConnected) {
      if (mounted) {
        setState(() => _hasInternet = isConnected);
      }
    });
  }

  Future<void> _checkConnectivity() async {
    final hasInternet = await ConnectivityHelper.hasInternetConnection();
    if (mounted) setState(() => _hasInternet = hasInternet);
  }

  Future<void> _refreshData() async {
    setState(() => _isRefreshing = true);

    await _checkConnectivity();

    if (_hasInternet && mounted) {
      if (_currentCity != null) {
        context.read<WeatherBloc>().add(RefreshWeather(_currentCity!));
        context.read<QuoteBloc>().add(FetchQuote());
      } else {
        await _getCurrentLocation();
      }
    }

    if (mounted) setState(() => _isRefreshing = false);
  }

  IconData _getThemeIcon(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return Icons.light_mode;
      case ThemeMode.dark:
        return Icons.dark_mode;
      case ThemeMode.system:
        return Icons.brightness_auto;
    }
  }

  void _showErrorSnackbar(String message) {
    final responsive = ResponsiveHelper(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 20),
            SizedBox(width: responsive.wp(2)),
            Expanded(child: Text(message, style: TextStyle(fontSize: responsive.sp(14)))),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(responsive.r(12)),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _navigateToSearch() async {
    if (!_hasInternet) {
      _showErrorSnackbar('No internet connection');
      return;
    }

    final result = await Navigator.pushNamed(context, AppRoutes.search);

    if (result != null && result is String && mounted) {
      setState(() {
        _currentCity = result;
        _locationError = false;
      });
      context.read<WeatherBloc>().add(FetchWeather(result));
    }
  }

  void _retryLocation() {
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Live Weather App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: responsive.sp(18),
          ),
        ),
        actions: [
         if (!_locationPermissionDenied && _currentCity != null)
            IconButton(
              icon: Icon(
                Icons.my_location,
                size: responsive.sp(22),
                color: AppColors.primary,
              ),
              onPressed: _retryLocation,
              tooltip: 'Refresh location',
            ),

          IconButton(
            icon: Icon(
              Icons.search,
              size: responsive.sp(22),
            ),
            onPressed: _navigateToSearch,
          ),

          BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, themeState) {
              return IconButton(
                icon: Icon(_getThemeIcon(themeState.themeMode), size: responsive.sp(22)),
                onPressed: () => context.read<ThemeBloc>().add(ToggleTheme()),
              );
            },
          ),
        ],
      ),

      drawer: AppDrawer(
        currentCity: _currentCity ?? 'Location not set',
        onRefresh: _refreshData,
      ),

      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshData,
          color: AppColors.primary,
          backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          child: !_hasInternet
              ? SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: SizedBox(
              height: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  kToolbarHeight -
                  responsive.hp(2),
              child: NoInternetWidget(onRetry: _refreshData),
            ),
          )
              : FadeTransition(
            opacity: _fadeAnimation,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(responsive.sp(16)),
              child: Column(
                children: [
                  // Shimmer Loading for Location
                  if (_isLoadingLocation)
                    _buildShimmerLoading(responsive)
                  else if (_locationError)
                    _buildLocationError(responsive)
                  else if (_currentCity == null)
                      _buildWaitingForLocation(responsive)
                    else
                      _buildWeatherContent(responsive),

                  if (_isRefreshing)
                    Padding(
                      padding: EdgeInsets.all(responsive.sp(16)),
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerLoading(ResponsiveHelper responsive) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        children: [
          // Weather Card Shimmer
          Container(
            height: responsive.hp(35),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(responsive.r(40)),
            ),
          ),

          SizedBox(height: responsive.hp(2)),

          // Forecast Card Shimmer
          Container(
            height: responsive.hp(25),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(responsive.r(30)),
            ),
          ),

          SizedBox(height: responsive.hp(2)),

          // Quote Card Shimmer
          Container(
            height: responsive.hp(18),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(responsive.r(30)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationError(ResponsiveHelper responsive) {
    return Center(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(responsive.sp(20)),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.location_off_rounded,
              size: responsive.sp(40),
              color: Colors.red,
            ),
          ),
          SizedBox(height: responsive.hp(2)),
          Text(
            'Location Error',
            style: TextStyle(
              fontSize: responsive.sp(18),
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          SizedBox(height: responsive.hp(1)),
          Text(
            _locationErrorMessage ?? 'Could not get your location',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: responsive.sp(14),
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(height: responsive.hp(2)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: _retryLocation,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: responsive.wp(4),
                    vertical: responsive.hp(1.5),
                  ),
                ),
              ),
              SizedBox(width: responsive.wp(3)),
              OutlinedButton.icon(
                onPressed: _navigateToSearch,
                icon: const Icon(Icons.search),
                label: const Text('Search City'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  padding: EdgeInsets.symmetric(
                    horizontal: responsive.wp(4),
                    vertical: responsive.hp(1.5),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWaitingForLocation(ResponsiveHelper responsive) {
    return Center(
      child: Column(
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              padding: EdgeInsets.all(responsive.sp(20)),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.location_searching,
                size: responsive.sp(40),
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: responsive.hp(2)),
          Text(
            'Waiting for location...',
            style: TextStyle(
              fontSize: responsive.sp(16),
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherContent(ResponsiveHelper responsive) {
    return Column(
      children: [
        BlocBuilder<WeatherBloc, WeatherState>(
          builder: (context, state) {
            if (state is WeatherLoading) {
              return _buildWeatherLoadingShimmer(responsive);
            } else if (state is WeatherLoaded) {
              if (state.forecast.daily.isEmpty) {
                return EmptyState.noData(
                  onRefresh: () => context.read<WeatherBloc>().add(
                      FetchWeather(_currentCity!)
                  ),
                );
              }
              return Column(
                children: [
                  GestureDetector(
                   // onTap: () => _showWeatherDetails(state),
                    child: WeatherCard(
                      city: state.weather.cityName,
                      temperature: state.weather.temperature,
                      condition: state.weather.getWeatherCondition(),
                      icon: state.weather.getWeatherIcon(),
                      humidity: state.weather.humidity,
                      windSpeed: state.weather.windSpeed,
                      feelsLike: state.weather.feelsLike,
                    ),
                  ),

                  SizedBox(height: responsive.hp(1.5)),

                  GestureDetector(
                   // onTap: () => _showForecastDetails(state),
                    child: ForecastCard(forecasts: state.forecast.daily),
                  ),
                ],
              );
            } else if (state is WeatherError) {
              return _buildWeatherError(state);
            }
            return const SizedBox.shrink();
          },
        ),

        SizedBox(height: responsive.hp(1.5)),

        BlocBuilder<QuoteBloc, QuoteState>(
          builder: (context, state) {
            if (state is QuoteLoading) {
              return _buildQuoteLoadingShimmer(responsive);
            } else if (state is QuoteLoaded) {
              return QuoteCard(
                quote: state.quote.content,
                author: state.quote.author,
              );
            } else if (state is QuoteError) {
              return ErrorDisplayWidget(
                message: state.message,
                onRetry: () => context.read<QuoteBloc>().add(FetchQuote()),
              );
            }
            return const SizedBox.shrink();
          },
        ),

        BlocBuilder<WeatherBloc, WeatherState>(
          builder: (context, state) {
            if (state is WeatherLoaded) {
              return _buildWeatherTip(state);
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  Widget _buildWeatherLoadingShimmer(ResponsiveHelper responsive) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        children: [
          Container(
            height: responsive.hp(35),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(responsive.r(40)),
            ),
          ),
          SizedBox(height: responsive.hp(1.5)),
          Container(
            height: responsive.hp(25),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(responsive.r(30)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuoteLoadingShimmer(ResponsiveHelper responsive) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: responsive.hp(18),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(responsive.r(30)),
        ),
      ),
    );
  }

  Widget _buildWeatherTip(WeatherLoaded state) {
    final condition = state.weather.getWeatherCondition().toLowerCase();
    String tip = '';
    IconData tipIcon = Icons.lightbulb_outline;

    if (condition.contains('rain')) {
      tip = 'Don\'t forget your umbrella today!';
      tipIcon = Icons.umbrella;
    } else if (condition.contains('clear') || condition.contains('sun')) {
      tip = 'Perfect day for outdoor activities!';
      tipIcon = Icons.wb_sunny;
    } else if (condition.contains('cloud')) {
      tip = 'Great weather for a walk in the park.';
      tipIcon = Icons.cloud;
    } else if (condition.contains('snow')) {
      tip = 'Wrap up warm and enjoy the snow!';
      tipIcon = Icons.ac_unit;
    } else if (condition.contains('storm')) {
      tip = 'Better stay indoors today. Stay safe!';
      tipIcon = Icons.flash_on;
    }

    return Card(
      margin: EdgeInsets.only(top: 16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(tipIcon, color: AppColors.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                tip,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showWeatherDetails(WeatherLoaded state) {
    Navigator.pushNamed(
      context,
      AppRoutes.weatherDetail,
      arguments: {
        'city': state.weather.cityName,
        'weather': state.weather,
      },
    );
  }

  void _showForecastDetails(WeatherLoaded state) {
    Navigator.pushNamed(
      context,
      AppRoutes.forecastDetail,
      arguments: {
        'city': state.weather.cityName,
        'forecasts': state.forecast.daily,
      },
    );
  }

  Widget _buildWeatherError(WeatherError state) {
    final errorMessage = state.message.toLowerCase();

    if (errorMessage.contains('timeout') || errorMessage.contains('connection timeout')) {
      return TimeoutErrorWidget(
        onRetry: () => context.read<WeatherBloc>().add(FetchWeather(_currentCity!)),
      );
    } else if (errorMessage.contains('not found') || errorMessage.contains('city not found')) {
      return CityNotFoundWidget(
        city: _currentCity!,
        onRetry: () => context.read<WeatherBloc>().add(FetchWeather(_currentCity!)),
        onSearchAgain: () async {
          final result = await Navigator.pushNamed(context, AppRoutes.search);
          if (result != null && result is String && mounted) {
            setState(() => _currentCity = result);
            context.read<WeatherBloc>().add(FetchWeather(result));
          }
        },
      );
    } else if (errorMessage.contains('internet') || errorMessage.contains('connection')) {
      return NoInternetWidget(
        onRetry: () => context.read<WeatherBloc>().add(FetchWeather(_currentCity!)),
      );
    } else {
      return ApiErrorWidget(
        message: state.message,
        onRetry: () => context.read<WeatherBloc>().add(FetchWeather(_currentCity!)),
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}