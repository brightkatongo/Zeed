import 'screens/loginScreen.dart';
import 'screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Color theme provider
final customColorsProvider = Provider<Map<String, Color>>((ref) => {
      'primary': Colors.green,
      'surface': Colors.grey[100]!,
      'text': Colors.black87,
    });

// SharedPreferences provider
final sharedPreferencesProvider = StateProvider<SharedPreferences?>((ref) => null);

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
    final prefs = ref.watch(sharedPreferencesProvider);
    final token = prefs?.getString('token');
    
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