import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/app_providers.dart'; // Adjust path based on nesting

class LoanDetailsScreen extends ConsumerWidget {
  const LoanDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customColors = ref.watch(customColorsProvider);
    final isEnglish = ref.watch(isEnglishProvider);

    String screenTitle = isEnglish ? 'Loan Details' : 'Zambiri za Ngongole';
    String screenContent = isEnglish ? 'View detailed information about your active and past loans, including repayment schedules, outstanding balances, and terms.' : 'Onani zambiri za ngongole zanu zomwe zikugwira ntchito komanso zakale, kuphatikizapo ndandanda zobweza, ndalama zotsalira, ndi mikhalidwe.';
    IconData screenIcon = Icons.info_outline;

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
                    SnackBar(content: Text(isEnglish ? 'View Repayment Schedule tapped!' : 'Onani Ndandanda Yobweza kukanikizidwa!')),
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
                  isEnglish ? 'View Repayment Schedule' : 'Onani Ndandanda Yobweza',
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