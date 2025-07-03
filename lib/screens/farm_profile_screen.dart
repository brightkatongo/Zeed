import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/app_providers.dart'; // Adjust path as needed

class FarmProfileScreen extends ConsumerWidget {
  const FarmProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customColors = ref.watch(customColorsProvider);
    final isEnglish = ref.watch(isEnglishProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEnglish ? 'Farm Profile' : 'Mbiri ya Famuyo',
          style: TextStyle(color: customColors['surface']),
        ),
        backgroundColor: customColors['primary'],
        iconTheme: IconThemeData(color: customColors['surface']),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.agriculture_outlined, size: 80, color: customColors['primary']),
            const SizedBox(height: 20),
            Text(
              isEnglish ? 'This is the Farm Profile Screen' : 'Ayi ndi Mbiri ya Famuyo',
              style: TextStyle(fontSize: 22, color: customColors['text']),
            ),
            const SizedBox(height: 10),
            Text(
              isEnglish ? 'Details about your farm and operations.' : 'Zambiri za famu yanu ndi ntchito.',
              style: TextStyle(fontSize: 16, color: customColors['text']!.withOpacity(0.7)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () {
                // TODO: Navigate to farm details editing
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(isEnglish ? 'Edit Farm Details tapped!' : 'Kusintha Zambiri za Famu kukanikizidwa!')),
                );
              },
              icon: Icon(Icons.description, color: customColors['surface']),
              label: Text(
                isEnglish ? 'View/Edit Farm Details' : 'Onani/Sinthani Zambiri za Famu',
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
          ],
        ),
      ),
    );
  }
}