// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_weather_app/presentation/screens/splash_screen.dart';
import 'package:provider/provider.dart';  // Add this import

import 'core/routes/app_routes.dart';
import 'core/routes/route_generator.dart';
import 'presentation/providers/home/home_provider.dart';  // Import your provider
import 'presentation/bloc/theme/theme_bloc.dart';
import 'presentation/bloc/theme/theme_event.dart';
import 'presentation/bloc/theme/theme_state.dart';
import 'presentation/bloc/weather/weather_bloc.dart';
import 'presentation/bloc/quote/quote_bloc.dart';
import 'data/repositories/weather_repository.dart';
import 'data/datasources/weather_remote_datasource.dart';
import 'data/repositories/quote_repository.dart';
import 'data/datasources/quote_remote_datasource.dart';
import 'presentation/screens/home_screen.dart';
import 'core/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Provider for local UI state
        ChangeNotifierProvider(create: (_) => HomeProvider()),

        // You can add more providers here
        // Provider(create: (_) => SomeService()),
        // FutureProvider, StreamProvider etc.
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<ThemeBloc>(
            create: (context) => ThemeBloc()..add(LoadTheme()),
          ),
          BlocProvider<WeatherBloc>(
            create: (context) => WeatherBloc(
              WeatherRepository(WeatherRemoteDataSource()),
            ),
          ),
          BlocProvider<QuoteBloc>(
            create: (context) => QuoteBloc(
              QuoteRepository(QuoteRemoteDataSource()),
            ),
          ),
        ],
        child: BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, themeState) {
            return MaterialApp(
              title: 'Weather App',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: themeState.themeMode,
              onGenerateRoute: RouteGenerator.generateRoute,
              initialRoute: AppRoutes.splash,
            );
          },
        ),
      ),
    );
  }
}