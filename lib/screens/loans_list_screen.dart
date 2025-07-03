import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'loan_application_screen.dart'; // Import for navigation
import '../../providers/app_providers.dart'; // Adjust path as needed

class LoansListScreen extends ConsumerWidget {
  const LoansListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customColors = ref.watch(customColorsProvider);
    final isEnglish = ref.watch(isEnglishProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEnglish ? 'Available Loans' : 'Ngongole Zilipo',
          style: TextStyle(color: customColors['surface']),
        ),
        backgroundColor: customColors['primary'],
        iconTheme: IconThemeData(color: customColors['surface']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isEnglish ? 'Explore our loan products tailored for farmers.' : 'Fufuzani ngongole zathu zopangira alimi.',
              style: TextStyle(fontSize: 16, color: customColors['text']!.withOpacity(0.8)),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildLoanProductCard(
                    context,
                    ref,
                    title: isEnglish ? 'Crop Production Loan' : 'Ngongole Yolima',
                    description: isEnglish ? 'Short-term financing for seeds, fertilizers, and labor.' : 'Ndalama zazifupi za mbewu, feteleza, ndi ntchito.',
                    amountRange: 'K5,000 - K50,000',
                    interestRate: '12% p.a.',
                    customColors: customColors,
                    isEnglish: isEnglish,
                  ),
                  const SizedBox(height: 15),
                  _buildLoanProductCard(
                    context,
                    ref,
                    title: isEnglish ? 'Farm Equipment Loan' : 'Ngongole Yogula Zida Za Famu',
                    description: isEnglish ? 'Long-term financing for tractors, irrigation systems.' : 'Ndalama zazitali za matelakitala, machitidwe othirira.',
                    amountRange: 'K20,000 - K200,000',
                    interestRate: '10% p.a.',
                    customColors: customColors,
                    isEnglish: isEnglish,
                  ),
                  const SizedBox(height: 15),
                  _buildLoanProductCard(
                    context,
                    ref,
                    title: isEnglish ? 'Livestock Development Loan' : 'Ngongole Yowonjezera Ziweto',
                    description: isEnglish ? 'For purchasing livestock, feed, and veterinary care.' : 'Pogula ziweto, chakudya, ndi chithandizo cha zinyama.',
                    amountRange: 'K10,000 - K100,000',
                    interestRate: '11% p.a.',
                    customColors: customColors,
                    isEnglish: isEnglish,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoanProductCard(
    BuildContext context,
    WidgetRef ref, {
    required String title,
    required String description,
    required String amountRange,
    required String interestRate,
    required Map<String, Color> customColors,
    required bool isEnglish,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: customColors['primary'],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(fontSize: 14, color: customColors['text']!.withOpacity(0.8)),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isEnglish ? 'Amount:' : 'Ndalama:',
                      style: TextStyle(fontSize: 13, color: customColors['text']!.withOpacity(0.6)),
                    ),
                    Text(
                      amountRange,
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: customColors['text']),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isEnglish ? 'Interest Rate:' : 'Chiwerengero cha Ndalama:',
                      style: TextStyle(fontSize: 13, color: customColors['text']!.withOpacity(0.6)),
                    ),
                    Text(
                      interestRate,
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: customColors['text']),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoanApplicationScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: customColors['secondary'],
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  isEnglish ? 'Apply Now' : 'Pemphani Tsopano',
                  style: TextStyle(color: customColors['surface']),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}