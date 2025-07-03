import 'package:flutter/material.dart';
import '../../../providers/app_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CropPlanningScreen extends ConsumerWidget {
  const CropPlanningScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customColors = ref.watch(customColorsProvider);
    final isEnglish = ref.watch(isEnglishProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEnglish ? 'Crop Planning' : 'Kukonzekera Kulima',
          style: TextStyle(color: customColors['surface']),
        ),
        backgroundColor: customColors['primary'],
        iconTheme: IconThemeData(color: customColors['surface']),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_month, size: 80, color: customColors['accent']),
            const SizedBox(height: 20),
            Text(
              isEnglish ? 'Plan Your Farming Seasons' : 'Konzani Nyengo Zanu Zomlimira',
              style: TextStyle(fontSize: 22, color: customColors['text']),
            ),
            const SizedBox(height: 10),
            Text(
              isEnglish ? 'Create planting schedules, select crops, and manage rotations.' : 'Pangani ndandanda yolima, sankhani mbewu, ndipo sinthani kasinthasintha.',
              style: TextStyle(fontSize: 16, color: customColors['subText']),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(isEnglish ? 'Start New Plan tapped!' : 'Yambani Dongosolo Latsopano kukanikizidwa!')),
                );
              },
              icon: Icon(Icons.add, color: customColors['surface']),
              label: Text(
                isEnglish ? 'Start New Plan' : 'Yambani Dongosolo Latsopano',
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