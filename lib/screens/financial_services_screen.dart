import 'package:flutter/material.dart';

// Define colors as constants outside the class for better memory efficiency
const Map<String, Color> kCustomColors = {
  'primary': Color(0xFF2E7D32),
  'secondary': Color(0xFF1565C0),
  'accent': Color(0xFFFFB74D),
  'background': Color(0xFFF5F5F5),
  'surface': Colors.white,
  'text': Color(0xFF212121),
};

class FinancialServicesScreen extends StatefulWidget {
  const FinancialServicesScreen({super.key});

  @override
  State<FinancialServicesScreen> createState() => _FinancialServicesScreenState();
}

class _FinancialServicesScreenState extends State<FinancialServicesScreen> {
  // Sample transaction data
  final List<Map<String, dynamic>> _transactions = [
    {
      'title': 'Loan Payment',
      'amount': '-K 5,000',
      'date': '2025-01-01',
      'type': 'debit'
    },
    {
      'title': 'Insurance Premium',
      'amount': '-K 2,500',
      'date': '2024-12-30',
      'type': 'debit'
    },
    {
      'title': 'Savings Deposit',
      'amount': '+K 10,000',
      'date': '2024-12-28',
      'type': 'credit'
    },
    {
      'title': 'Interest Earned',
      'amount': '+K 500',
      'date': '2024-12-25',
      'type': 'credit'
    },
  ];

  // Sample service data
  final List<Map<String, dynamic>> _services = [
    {
      'title': 'Farm Equipment Loan',
      'subtitle': 'Up to K100,000',
      'icon': Icons.agriculture
    },
    {
      'title': 'Crop Insurance',
      'subtitle': 'Protect your harvest',
      'icon': Icons.security
    },
    {
      'title': 'Savings Account',
      'subtitle': '5% interest rate',
      'icon': Icons.savings
    },
    {
      'title': 'Financial Advisory',
      'subtitle': 'Expert guidance',
      'icon': Icons.support_agent
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Financial Services'),
        backgroundColor: kCustomColors['primary'],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildBalanceCard(),
          const SizedBox(height: 16),
          _buildQuickActions(),
          const SizedBox(height: 16),
          _buildServices(),
          const SizedBox(height: 16),
          _buildTransactionHistory(),
        ],
      ),
    );
  }

  Widget _buildBalanceCard() {
    return Card(
      color: kCustomColors['primary'],
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Available Balance',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'K 25,000',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildBalanceInfo('Credit Limit', 'K 50,000'),
                _buildBalanceInfo('Due Date', '15 Jan 2025'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildActionButton('Apply Loan', Icons.monetization_on),
            _buildActionButton('Insurance', Icons.security),
            _buildActionButton('Savings', Icons.savings),
            _buildActionButton('Transfer', Icons.send),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(String label, IconData icon) {
    return Semantics(
      button: true,
      label: 'Quick action for $label',
      child: InkWell(
        onTap: () => _showServiceDetails(label),
        borderRadius: BorderRadius.circular(30),
        child: Column(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: kCustomColors['primary']!.withOpacity(0.1),
              child: Icon(
                icon,
                color: kCustomColors['primary'],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: kCustomColors['text'],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServices() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Services',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        // Using a Column instead of nested ListView for better performance
        Column(
          children: _services.map((service) {
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: kCustomColors['primary']!.withOpacity(0.1),
                  child: Icon(
                    service['icon'] as IconData,
                    color: kCustomColors['primary'],
                  ),
                ),
                title: Text(service['title'] as String),
                subtitle: Text(service['subtitle'] as String),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => _showServiceDetails(service['title'] as String),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTransactionHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Transaction History',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () => _showAllTransactions(),
              child: Text(
                'View All',
                style: TextStyle(color: kCustomColors['primary']),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Using a Column instead of nested ListView for better performance
        Column(
          children: _transactions.map((transaction) {
            final isCredit = transaction['type'] == 'credit';
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: isCredit
                      ? kCustomColors['primary']!.withOpacity(0.1)
                      : Colors.red.withOpacity(0.1),
                  child: Icon(
                    isCredit ? Icons.add : Icons.remove,
                    color: isCredit ? kCustomColors['primary'] : Colors.red,
                  ),
                ),
                title: Text(transaction['title'] as String),
                subtitle: Text(transaction['date'] as String),
                trailing: Text(
                  transaction['amount'] as String,
                  style: TextStyle(
                    color: isCredit ? kCustomColors['primary'] : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  void _showServiceDetails(String service) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.fromLTRB(16, 16, 16, MediaQuery.of(context).viewInsets.bottom + 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              service,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Service details and application form will be displayed here.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: kCustomColors['primary'],
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text(
                'Apply Now',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAllTransactions() {
    // Generate more realistic transaction data
    final List<Map<String, dynamic>> allTransactions = List.generate(20, (index) {
      // Alternate between credit and debit
      final isCredit = index % 3 != 0;
      // Generate more realistic dates by going back from today
      final date = DateTime.now().subtract(Duration(days: index));
      final formattedDate = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      
      // Generate more realistic transaction titles
      final titles = [
        'Loan Payment',
        'Insurance Premium',
        'Savings Deposit',
        'Interest Earned',
        'Advisory Fee',
        'Account Maintenance',
        'Farm Equipment Purchase',
        'Crop Insurance Claim',
      ];
      
      return {
        'title': titles[index % titles.length],
        'amount': isCredit ? '+K ${(index + 1) * 100}' : '-K ${(index + 1) * 50}',
        'date': formattedDate,
        'type': isCredit ? 'credit' : 'debit'
      };
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('All Transactions'),
            backgroundColor: kCustomColors['primary'],
          ),
          body: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: allTransactions.length,
            itemBuilder: (context, index) {
              final transaction = allTransactions[index];
              final isCredit = transaction['type'] == 'credit';
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: isCredit
                        ? kCustomColors['primary']!.withOpacity(0.1)
                        : Colors.red.withOpacity(0.1),
                    child: Icon(
                      isCredit ? Icons.add : Icons.remove,
                      color: isCredit ? kCustomColors['primary'] : Colors.red,
                    ),
                  ),
                  title: Text(transaction['title'] as String),
                  subtitle: Text(transaction['date'] as String),
                  trailing: Text(
                    transaction['amount'] as String,
                    style: TextStyle(
                      color: isCredit ? kCustomColors['primary'] : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}