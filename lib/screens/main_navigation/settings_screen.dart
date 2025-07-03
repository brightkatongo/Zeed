import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/app_providers.dart'; // Adjust path as needed

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customColors = ref.watch(customColorsProvider);
    final isEnglish = ref.watch(isEnglishProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEnglish ? 'Settings' : 'Zokonda',
          style: TextStyle(color: customColors['surface']),
        ),
        backgroundColor: customColors['primary'],
        iconTheme: IconThemeData(color: customColors['surface']),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSettingsCategoryTitle(
            isEnglish ? 'General' : 'Zoyambira',
            customColors,
          ),
          SwitchListTile(
            title: Text(
              isEnglish ? 'Enable Notifications' : 'Yambitsani Zidziwitso',
              style: TextStyle(color: customColors['text']),
            ),
            value: true, // TODO: Replace with actual notification setting state
            onChanged: (bool value) {
              // TODO: Implement toggle notification logic
            },
            activeColor: customColors['primary'],
          ),
          ListTile(
            title: Text(
              isEnglish ? 'Language' : 'Chilankhulo',
              style: TextStyle(color: customColors['text']),
            ),
            trailing: DropdownButton<bool>(
              value: isEnglish,
              onChanged: (bool? newValue) {
                if (newValue != null) {
                  ref.read(isEnglishProvider.notifier).state = newValue;
                }
              },
              items: <DropdownMenuItem<bool>>[
                DropdownMenuItem<bool>(
                  value: true,
                  child: Text('English', style: TextStyle(color: customColors['text'])),
                ),
                DropdownMenuItem<bool>(
                  value: false,
                  child: Text('Chichewa', style: TextStyle(color: customColors['text'])),
                ),
              ],
            ),
          ),
          const Divider(),
          _buildSettingsCategoryTitle(
            isEnglish ? 'Account' : 'Akaunti',
            customColors,
          ),
          ListTile(
            leading: Icon(Icons.lock, color: customColors['primary']),
            title: Text(
              isEnglish ? 'Change Password' : 'Sinthani Achinsinsi',
              style: TextStyle(color: customColors['text']),
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const PasswordResetScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.delete_forever, color: Colors.red),
            title: Text(
              isEnglish ? 'Delete Account' : 'Chotsani Akaunti',
              style: const TextStyle(color: Colors.red),
            ),
            onTap: () {
              _showDeleteAccountDialog(context, customColors, isEnglish);
            },
          ),
          const Divider(),
          _buildSettingsCategoryTitle(
            isEnglish ? 'About' : 'Zambiri',
            customColors,
          ),
          ListTile(
            leading: Icon(Icons.info, color: customColors['subText']),
            title: Text(
              isEnglish ? 'App Version' : 'Mtundu wa App',
              style: TextStyle(color: customColors['text']),
            ),
            trailing: Text('1.0.0', style: TextStyle(color: customColors['subText'])),
          ),
          ListTile(
            leading: Icon(Icons.policy, color: customColors['subText']),
            title: Text(
              isEnglish ? 'Privacy Policy' : 'Ndondomeko ya Zinsinsi',
              style: TextStyle(color: customColors['text']),
            ),
            onTap: () {
              // TODO: Navigate to Privacy Policy screen/web view
            },
          ),
          ListTile(
            leading: Icon(Icons.description, color: customColors['subText']),
            title: Text(
              isEnglish ? 'Terms of Service' : 'Malamulo Ogwiritsira Ntchito',
              style: TextStyle(color: customColors['text']),
            ),
            onTap: () {
              // TODO: Navigate to Terms of Service screen/web view
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCategoryTitle(String title, Map<String, Color> customColors) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: customColors['primary'],
        ),
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context, Map<String, Color> customColors, bool isEnglish) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            isEnglish ? 'Delete Account?' : 'Chotsani Akaunti?',
            style: TextStyle(color: customColors['text']),
          ),
          content: Text(
            isEnglish ? 'Are you sure you want to delete your account? This action cannot be undone.' : 'Muli otsimikiza kuti mukufuna kuchotsa akaunti yanu? Izi sizingatheke kusinthidwa.',
            style: TextStyle(color: customColors['subText']),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss dialog
              },
              child: Text(
                isEnglish ? 'Cancel' : 'Letsani',
                style: TextStyle(color: customColors['secondary']),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement actual account deletion logic
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(isEnglish ? 'Account deletion initiated!' : 'Kukonza akaunti kwayambika!')),
                );
                Navigator.of(context).pop(); // Dismiss dialog
                // Potentially navigate back to login screen
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: Text(
                isEnglish ? 'Delete' : 'Chotsani',
                style: TextStyle(color: customColors['surface']),
              ),
            ),
          ],
        );
      },
    );
  }
}