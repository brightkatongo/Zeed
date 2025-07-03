import 'api_service.dart';
import 'providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'providers/products_provider.dart';
import 'providers/dashboard_provider.dart';
import 'package:zeed/screens/loginScreen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/home_screen.dart'; // Renamed from dashboard_screen for consistency


// Color theme provider
final customColorsProvider = Provider<Map<String, Color>>((ref) => {
      'primary': Colors.green,
      'surface': Colors.grey[100]!,
      'text': Colors.black87,
    });

// SharedPreferences provider
final sharedPreferencesProvider = StateProvider<SharedPreferences?>((ref) => null);

// Auth token provider (moved from login_screen.dart)
final authTokenProvider = StateProvider<String?>((ref) => null);

// API Service provider
final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService(baseUrl: 'https://your-api-domain.com'); // Replace with your actual API URL
});

class InitApp extends ConsumerWidget {
  const InitApp({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          
          if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Text('Error: ${snapshot.error}'),
              ),
            );
          }
          
          if (snapshot.hasData) {
            // Update the SharedPreferences provider with the instance
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ref.read(sharedPreferencesProvider.notifier).state = snapshot.data as SharedPreferences;
              
              // Check if token exists and update the authTokenProvider
              final prefs = snapshot.data as SharedPreferences;
              final token = prefs.getString('token');
              if (token != null) {
                ref.read(authTokenProvider.notifier).state = token;
              }
            });
            
            return const MyApp();
          }
          
          return const Scaffold(
            body: Center(
              child: Text('Something went wrong'),
            ),
          );
        },
      ),
    );
  }
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customColors = ref.watch(customColorsProvider);
    final token = ref.watch(authTokenProvider);
    
    // Determine initial screen based on auth token
    final initialScreen = token != null ? const HomePage() : const LoginScreen();
    return MaterialApp(
      title: 'Agrifinance',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: customColors['primary']!,
          brightness: Brightness.light,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
      ),
      home: initialScreen,
      debugShowCheckedModeBanner: false,
    );
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(
    const ProviderScope(
      child: InitApp(),
    ),
  );
}