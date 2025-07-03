import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/app_providers.dart'; // Adjust path based on nesting

class YieldTrackingScreen extends ConsumerWidget {
  const YieldTrackingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customColors = ref.watch(customColorsProvider);
    final isEnglish = ref.watch(isEnglishProvider);

    String screenTitle = isEnglish ? 'Yield Tracking' : 'Kutsatira Zokolola';
    String screenContent = isEnglish ? 'Record and analyze your crop and livestock yields over time to understand performance and make informed decisions.' : 'Lembani ndi kusanthula zokolola zanu za mbewu ndi ziweto nthawi zonse kuti mumvetsetse ntchito ndikupanga zisankho zabwino.';
    IconData screenIcon = Icons.bar_chart;

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
                    SnackBar(content: Text(isEnglish ? 'Add New Yield Record tapped!' : 'Onjezani Mbiri Yatsopano ya Zokolola kukanikizidwa!')),
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
                  isEnglish ? 'Add New Yield Record' : 'Onjezani Mbiri Yatsopano ya Zokolola',
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