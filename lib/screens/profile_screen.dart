import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/app_providers.dart'; // Adjust path as needed

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customColors = ref.watch(customColorsProvider);
    final isEnglish = ref.watch(isEnglishProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEnglish ? 'Profile' : 'Mbiri Yanu',
          style: TextStyle(color: customColors['surface']),
        ),
        backgroundColor: customColors['primary'],
        iconTheme: IconThemeData(color: customColors['surface']),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person, size: 80, color: customColors['primary']),
            const SizedBox(height: 20),
            Text(
              isEnglish ? 'This is the Profile Screen' : 'Ayi ndi Mbiri Yanu',
              style: TextStyle(fontSize: 22, color: customColors['text']),
            ),
            const SizedBox(height: 10),
            Text(
              isEnglish ? 'Manage your account settings here.' : 'Konzekerani zoikamo zanu apa.',
              style: TextStyle(fontSize: 16, color: customColors['text']!.withOpacity(0.7)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () {
                // TODO: Navigate to settings or edit profile
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(isEnglish ? 'Edit Profile tapped!' : 'Kusintha Mbiri Yanu kukanikizidwa!')),
                );
              },
              icon: Icon(Icons.edit, color: customColors['surface']),
              label: Text(
                isEnglish ? 'Edit Profile' : 'Sinthani Mbiri',
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
},