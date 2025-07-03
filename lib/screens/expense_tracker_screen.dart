import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/app_providers.dart'; // Adjust path as needed

class ExpenseTrackerScreen extends ConsumerWidget {
  const ExpenseTrackerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customColors = ref.watch(customColorsProvider);
    final isEnglish = ref.watch(isEnglishProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEnglish ? 'Expense Tracker' : 'Kafukufuku wa Zopereka',
          style: TextStyle(color: customColors['surface']),
        ),
        backgroundColor: customColors['primary'],
        iconTheme: IconThemeData(color: customColors['surface']),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.money_off, size: 80, color: customColors['secondary']),
            const SizedBox(height: 20),
            Text(
              isEnglish ? 'Manage Your Farm Expenses' : 'Sinthani Zopereka za Famu Yanu',
              style: TextStyle(fontSize: 22, color: customColors['text']),
            ),
            const SizedBox(height: 10),
            Text(
              isEnglish ? 'Track all costs related to your farm operations.' : 'Tsatirani ndalama zonse zogwirizana ndi ntchito za famu yanu.',
              style: TextStyle(fontSize: 16, color: customColors['text']!.withOpacity(0.7)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(isEnglish ? 'Add New Expense tapped!' : 'Kuonjezera Zopereka Zatsopano kukanikizidwa!')),
                );
              },
              icon: Icon(Icons.add_circle_outline, color: customColors['surface']),
              label: Text(
                isEnglish ? 'Add New Expense' : 'Onjezani Zopereka Zatsopano',
                style: TextStyle(color: customColors['surface']),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: customColors['primary'],
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