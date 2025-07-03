import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/app_providers.dart'; // Adjust path as needed

class SavingsAccountScreen extends ConsumerWidget {
  const SavingsAccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customColors = ref.watch(customColorsProvider);
    final isEnglish = ref.watch(isEnglishProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEnglish ? 'Savings Account' : 'Akaunti Yosungira Ndalama',
          style: TextStyle(color: customColors['surface']),
        ),
        backgroundColor: customColors['primary'],
        iconTheme: IconThemeData(color: customColors['surface']),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.savings, size: 80, color: customColors['primary']),
            const SizedBox(height: 20),
            Text(
              isEnglish ? 'Your Savings Overview' : 'Chiwerengero Chanu Chosungira Ndalama',
              style: TextStyle(fontSize: 22, color: customColors['text']),
            ),
            const SizedBox(height: 10),
            Text(
              isEnglish ? 'Current Balance: K15,500.00' : 'Ndalama Zilipo: K15,500.00',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: customColors['primary'],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(isEnglish ? 'Deposit funds tapped!' : 'Kuyika ndalama kukanikizidwa!')),
                );
              },
              icon: Icon(Icons.add, color: customColors['surface']),
              label: Text(
                isEnglish ? 'Deposit Funds' : 'Ikani Ndalama',
                style: TextStyle(color: customColors['surface']),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: customColors['secondary'],
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(isEnglish ? 'Withdraw funds tapped!' : 'Kutulutsa ndalama kukanikizidwa!')),
                );
              },
              icon: Icon(Icons.remove, color: customColors['primary']),
              label: Text(
                isEnglish ? 'Withdraw Funds' : 'Tulutsani Ndalama',
                style: TextStyle(color: customColors['primary']),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: customColors['primary']!),
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}