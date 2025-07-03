import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/app_providers.dart'; // Adjust path based on nesting

class CreditScoreScreen extends ConsumerWidget {
  const CreditScoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customColors = ref.watch(customColorsProvider);
    final isEnglish = ref.watch(isEnglishProvider);

    String screenTitle = isEnglish ? 'Credit Score' : 'Chiwerengero cha Ngongole';
    String screenContent = isEnglish ? 'Check your credit score, understand the factors affecting it, and get tips to improve your financial standing for future loans.' : 'Yang’anani chiwerengero chanu cha ngongole, kumvetsetsa zinthu zomwe zimakhudza izo, ndi kupeza malangizo oti muwonjezere ndalama zanu kuti mupeze ngongole zamtsogolo.';
    IconData screenIcon = Icons.score;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          screenTitle,
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
              Icon(screenIcon, size: 80, color: customColors['accent']),
              const SizedBox(height: 20),
              Text(
                screenTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: customColors['text'],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                screenContent,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: customColors['subText'],
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(isEnglish ? 'View My Credit Score tapped!' : 'Onani Chiwerengero Changa cha Ngongole kukanikizidwa!')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: customColors['secondary'],
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  isEnglish ? 'View My Credit Score' : 'Onani Chiwerengero Changa cha Ngongole',
                  style: TextStyle(fontSize: 16, color: customColors['surface']),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}