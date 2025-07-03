import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/app_providers.dart'; // Adjust path as needed
import 'package:url_launcher/url_launcher.dart'; // For launching external links

class HelpSupportScreen extends ConsumerWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customColors = ref.watch(customColorsProvider);
    final isEnglish = ref.watch(isEnglishProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEnglish ? 'Help & Support' : 'Thandizo',
          style: TextStyle(color: customColors['surface']),
        ),
        backgroundColor: customColors['primary'],
        iconTheme: IconThemeData(color: customColors['surface']),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSectionTitle(isEnglish ? 'Contact Us' : 'Lumikizanani Nane', customColors),
          _buildContactTile(
            icon: Icons.email,
            title: isEnglish ? 'Email Support' : 'Imelo Yothandizira',
            subtitle: 'support@agrifinance.com',
            onTap: () async {
              final Uri emailLaunchUri = Uri(
                scheme: 'mailto',
                path: 'support@agrifinance.com',
                queryParameters: {'subject': isEnglish ? 'App Support Request' : 'Pempho la Thandizo la App'},
              );
              if (await canLaunchUrl(emailLaunchUri)) {
                await launchUrl(emailLaunchUri);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(isEnglish ? 'Could not launch email app.' : 'Sitheka kutsegula pulogalamu ya imelo.')),
                );
              }
            },
            customColors: customColors,
          ),
          _buildContactTile(
            icon: Icons.phone,
            title: isEnglish ? 'Call Us' : 'Tiimbireni Foni',
            subtitle: '+260 971 123 456',
            onTap: () async {
              final Uri phoneLaunchUri = Uri(scheme: 'tel', path: '+260971123456');
              if (await canLaunchUrl(phoneLaunchUri)) {
                await launchUrl(phoneLaunchUri);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(isEnglish ? 'Could not make a call.' : 'Sitheka kuyimba foni.')),
                );
              }
            },
            customColors: customColors,
          ),
          const Divider(),
          _buildSectionTitle(isEnglish ? 'FAQs' : 'Mafunso Omwe Amafunsidwa Kawiri-Kawiri', customColors),
          _buildFaqExpansionTile(
            isEnglish ? 'How do I apply for a loan?' : 'Kodi ndingapemphe bwanji ngongole?',
            isEnglish ? 'Navigate to the "Loans" section, select a loan product, and fill out the application form.' : 'Pitani ku gawo la "Ngongole", sankhani ngongole, ndipo lembani fomu yofunsira.',
            customColors,
          ),
          _buildFaqExpansionTile(
            isEnglish ? 'How do I sell my produce?' : 'Kodi ndingagulitse bwanji zokolola zanga?',
            isEnglish ? 'Go to the "Marketplace", then "Sell Products" to create a new listing.' : 'Pitani ku "Msika", kenako "Gulitsani Zinthu" kuti muyike chogulitsa chatsopano.',
            customColors,
          ),
          _buildFaqExpansionTile(
            isEnglish ? 'How can I track my farm expenses?' : 'Kodi ndingatsatire bwanji ndalama zanga za famu?',
            isEnglish ? 'In "Farm Management", find the "Expense Tracker" to log your expenditures.' : 'Mu "Kasamalidwe ka Famu", pezani "Kafukufuku wa Zopereka" kuti mulembe zopereka zanu.',
            customColors,
          ),
          const Divider(),
          _buildSectionTitle(isEnglish ? 'Online Resources' : 'Zinthu Pa Intaneti', customColors),
          _buildContactTile(
            icon: Icons.web,
            title: isEnglish ? 'Visit Our Website' : 'Pitani Ku Webusaiti Yathu',
            subtitle: 'www.agrifinance.com',
            onTap: () async {
              final Uri url = Uri.parse('http://www.agrifinance.com');
              if (await canLaunchUrl(url)) {
                await launchUrl(url);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(isEnglish ? 'Could not launch website.' : 'Sitheka kutsegula webusaiti.')),
                );
              }
            },
            customColors: customColors,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, Map<String, Color> customColors) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 4.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: customColors['primary'],
        ),
      ),
    );
  }

  Widget _buildContactTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Map<String, Color> customColors,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(icon, color: customColors['primary'], size: 28),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.w500, color: customColors['text'])),
        subtitle: Text(subtitle, style: TextStyle(color: customColors['subText'])),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: customColors['subText']),
        onTap: onTap,
      ),
    );
  }

  Widget _buildFaqExpansionTile(String question, String answer, Map<String, Color> customColors) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ExpansionTile(
        title: Text(
          question,
          style: TextStyle(fontWeight: FontWeight.bold, color: customColors['text']),
        ),
        iconColor: customColors['primary'],
        collapsedIconColor: customColors['subText'],
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              answer,
              style: TextStyle(color: customColors['subText']),
            ),
          ),
        ],
      ),
    );
  }
}