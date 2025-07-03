import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Auth token provider
final authTokenProvider = StateProvider<String?>((ref) => null);

// Custom colors provider
final customColorsProvider = Provider<Map<String, Color>>((ref) => {
      'primary': const Color(0xFF2E7D32), // Dark Green
      'secondary': const Color(0xFF1565C0), // Dark Blue
      'accent': const Color(0xFFFFB74D), // Amber
      'background': const Color(0xFFF5F5F5), // Light Grey
      'surface': Colors.white,
      'text': const Color(0xFF212121), // Dark Grey
      'subText': const Color(0xFF757575), // Medium Grey
    });

// Language provider
final isEnglishProvider = StateProvider<bool>((ref) => true);

// Selected index provider for bottom navigation (moved here for global access)
final selectedIndexProvider = StateProvider<int>((ref) => 0);

// Shared preferences provider
final sharedPreferencesProvider = StateProvider<SharedPreferences?>((ref) => null);

// Shared preferences initialization provider
final sharedPreferencesInitProvider = FutureProvider<SharedPreferences>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  ref.read(sharedPreferencesProvider.notifier).state = prefs;
  return prefs;
});