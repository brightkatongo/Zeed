import 'dart:convert';
import 'home_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Login state provider
final loginStateProvider = StateProvider<LoginState>((ref) => LoginState.initial);

// Login error message provider
final loginErrorProvider = StateProvider<String?>((ref) => null);

// Authentication token provider
final authTokenProvider = StateProvider<String?>((ref) => null);

// Login state enum
enum LoginState { initial, loading, success, failure }

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Update login state to loading
    ref.read(loginStateProvider.notifier).state = LoginState.loading;
    ref.read(loginErrorProvider.notifier).state = null;

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/api/auth/login/'),  // For Android emulator
        // Use 'http://localhost:8000/api/auth/login/' for iOS simulator
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': _usernameController.text,
          'password': _passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final prefs = ref.read(sharedPreferencesProvider);
        if (prefs != null) {
          await prefs.setString('token', data['token']);
          // Update auth token provider
          ref.read(authTokenProvider.notifier).state = data['token'];
        }
        
        // Update login state to success
        ref.read(loginStateProvider.notifier).state = LoginState.success;
        
        // Navigate to home screen
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        }
      } else {
        final data = json.decode(response.body);
        // Update login state to failure and set error message
        ref.read(loginStateProvider.notifier).state = LoginState.failure;
        ref.read(loginErrorProvider.notifier).state = data['detail'] ?? 'Login failed. Please try again.';
      }
    } catch (e) {
      // Update login state to failure and set error message
      ref.read(loginStateProvider.notifier).state = LoginState.failure;
      ref.read(loginErrorProvider.notifier).state = 'Connection error. Please check your internet connection.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final customColors = ref.watch(customColorsProvider);
    final loginState = ref.watch(loginStateProvider);
    final errorMessage = ref.watch(loginErrorProvider);
    
    return Scaffold(
      body: Stack(
        children: [
          // Background image with farm theme
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/farm_background.jpg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black26,
                  BlendMode.darken,
                ),
              ),
            ),
          ),
          // Login form
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Logo and app name
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: customColors['surface'],
                            child: const Image(
                              image: AssetImage('assets/images/agrifinance_logo.png'),
                              width: 80,
                              height: 80,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Agrifinance',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: customColors['primary'],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Grow your financial future',
                            style: TextStyle(
                              fontSize: 16,
                              color: customColors['text'],
                            ),
                          ),
                          const SizedBox(height: 32),
                          
                          // Error message
                          if (errorMessage != null)
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.red.shade50,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.red.shade200),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.error_outline, color: Colors.red),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      errorMessage,
                                      style: const TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          if (errorMessage != null) const SizedBox(height: 24),
                          
                          // Username field
                          TextFormField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                              labelText: 'Username',
                              hintText: 'Enter your username',
                              prefixIcon: Icon(Icons.person, color: customColors['primary']),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(color: customColors['primary']!, width: 2.0),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your username';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          
                          // Password field
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              hintText: 'Enter your password',
                              prefixIcon: Icon(Icons.lock, color: customColors['primary']),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(color: customColors['primary']!, width: 2.0),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 8),
                          
                          // Forgot password
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                // Navigate to forgot password screen
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: customColors['primary'],
                              ),
                              child: const Text('Forgot Password?'),
                            ),
                          ),
                          const SizedBox(height: 24),
                          
                          // Login button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: loginState == LoginState.loading ? null : _login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: customColors['primary'],
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 15.0),
                              ),
                              child: loginState == LoginState.loading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 3,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text(
                                      'LOGIN',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          
                          // Sign up option
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account?",
                                style: TextStyle(color: customColors['text']),
                              ),
                              TextButton(
                                onPressed: () {
                                  // Navigate to sign up screen
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: customColors['primary'],
                                ),
                                child: const Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}