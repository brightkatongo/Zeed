import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/app_providers.dart'; // Adjust path as needed

class TransactionHistoryScreen extends ConsumerWidget {
  const TransactionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customColors = ref.watch(customColorsProvider);
    final isEnglish = ref.watch(isEnglishProvider);

    final List<Map<String, String>> transactions = [
      {'type': 'Deposit', 'amount': '+K5,000.00', 'date': '2025-06-28', 'status': 'Completed'},
      {'type': 'Loan Repayment', 'amount': '-K1,200.00', 'date': '2025-06-25', 'status': 'Completed'},
      {'type': 'Sale of Maize', 'amount': '+K3,500.00', 'date': '2025-06-20', 'status': 'Completed'},
      {'type': 'Fertilizer Purchase', 'amount': '-K800.00', 'date': '2025-06-15', 'status': 'Completed'},
      {'type': 'Withdrawal', 'amount': '-K1,000.00', 'date': '2025-06-10', 'status': 'Completed'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEnglish ? 'Transaction History' : 'Mbiri ya Malonda',
          style: TextStyle(color: customColors['surface']),
        ),
        backgroundColor: customColors['primary'],
        iconTheme: IconThemeData(color: customColors['surface']),
      ),
      body: transactions.isEmpty
          ? Center(
              child: Text(
                isEnglish ? 'No transactions yet.' : 'Palibe malonda pakali pano.',
                style: TextStyle(fontSize: 18, color: customColors['text']!.withOpacity(0.6)),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final transaction = transactions[index];
                final bool isCredit = transaction['amount']!.startsWith('+');
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 1,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isCredit ? Colors.green[100] : Colors.red[100],
                      child: Icon(
                        isCredit ? Icons.arrow_downward : Icons.arrow_upward,
                        color: isCredit ? Colors.green : Colors.red,
                      ),
                    ),
                    title: Text(
                      transaction['type']!,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: customColors['text'],
                      ),
                    ),
                    subtitle: Text(
                      '${transaction['date']} • ${transaction['status']}',
                      style: TextStyle(fontSize: 13, color: customColors['text']!.withOpacity(0.7)),
                    ),
                    trailing: Text(
                      transaction['amount']!,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: isCredit ? Colors.green : Colors.red,
                      ),
                    ),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(isEnglish ? 'Tapped on transaction!' : 'Malonda adakanikizidwa!')),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}