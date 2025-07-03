import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/app_providers.dart'; // Adjust path based on nesting

class LivestockDashboardScreen extends ConsumerWidget {
  const LivestockDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customColors = ref.watch(customColorsProvider);
    final isEnglish = ref.watch(isEnglishProvider);

    String screenTitle = isEnglish ? 'Livestock Dashboard' : 'Mbiri ya Ziweto';
    String screenContent = isEnglish ? 'Get an overview of your livestock inventory, health records, breeding cycles, and feed management.' : 'Pezani chiwerengero cha ziweto zanu, mbiri ya thanzi, njira zoberekera, ndi kasamalidwe ka chakudya.';
    IconData screenIcon = Icons.pets;

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
                    SnackBar(content: Text(isEnglish ? 'Add New Animal tapped!' : 'Onjezani Chiweto Chatsopano kukanikizidwa!')),
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
                  isEnglish ? 'Add New Animal' : 'Onjezani Chiweto Chatsopano',
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