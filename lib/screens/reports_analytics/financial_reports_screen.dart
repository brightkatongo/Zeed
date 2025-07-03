import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/app_providers.dart'; // Adjust path based on nesting

class FinancialReportsScreen extends ConsumerWidget {
  const FinancialReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customColors = ref.watch(customColorsProvider);
    final isEnglish = ref.watch(isEnglishProvider);

    String screenTitle = isEnglish ? 'Financial Reports' : 'Malipoti a Ndalama';
    String screenContent = isEnglish ? 'Generate and view comprehensive financial reports including profit & loss statements, balance sheets, and cash flow analysis.' : 'Pangani ndikuwona malipoti athunthu a ndalama kuphatikizapo malipoti a phindu ndi kutayika, ma balance sheet, ndi kusanthula kwa ndalama zoyenda.';
    IconData screenIcon = Icons.bar_chart_outlined;

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
                    SnackBar(content: Text(isEnglish ? 'Generate Report tapped!' : 'Pangani Lipoti kukanikizidwa!')),
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
                  isEnglish ? 'Generate Report' : 'Pangani Lipoti',
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