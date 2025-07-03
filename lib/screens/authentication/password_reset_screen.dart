import 'package:flutter/material.dart';
import '../../providers/app_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PasswordResetScreen extends ConsumerWidget {
  const PasswordResetScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customColors = ref.watch(customColorsProvider);
    final isEnglish = ref.watch(isEnglishProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEnglish ? 'Password Reset' : 'Kukhazikitsanso Achinsinsi',
          style: TextStyle(color: customColors['surface']),
        ),
        backgroundColor: customColors['primary'],
        iconTheme: IconThemeData(color: customColors['surface']),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                isEnglish ? 'Forgot Your Password?' : 'Mwayiwala Achinsinsi Anu?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: customColors['text'],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                isEnglish ? 'Enter your email to receive a password reset link.' : 'Lowetsani imelo yanu kuti mulandire ulalo wokhazikitsanso achinsinsi.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: customColors['subText'],
                ),
              ),
              const SizedBox(height: 32),
              TextField(
                decoration: InputDecoration(
                  labelText: isEnglish ? 'Email Address' : 'Adilesi ya Imelo',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: const Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  // TODO: Implement password reset logic
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(isEnglish ? 'Password reset link sent (simulated)!' : 'Ulalo wokhazikitsanso achinsinsi watumizidwa (zoyerekezera)!')),
                  );
                  Navigator.pop(context); // Go back to login
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: customColors['primary'],
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  isEnglish ? 'Reset Password' : 'Khazikitsanso Achinsinsi',
                  style: TextStyle(fontSize: 18, color: customColors['surface']),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}