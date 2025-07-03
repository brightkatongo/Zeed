import '../models/dashboard.dart';
import 'package:flutter/material.dart';

class RecentTransactionsWidget extends StatelessWidget {
  final List<Transaction> transactions;
  
  const RecentTransactionsWidget({Key? key, required this.transactions}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: transactions.map((transaction) => _buildTransactionCard(transaction)).toList(),
    );
  }
  
  Widget _buildTransactionCard(Transaction transaction) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getStatusColor(transaction.status).withOpacity(0.2),
          child: Icon(
            _getStatusIcon(transaction.status),
            color: _getStatusColor(transaction.status),
            size: 20,
          ),
        ),
        title: Text('Transaction #${transaction.id}'),
        subtitle: Text('${transaction.date} • ${transaction.type}'),
        trailing: Text(
          transaction.amount,
          style: TextStyle(
            color: Colors.green.shade600,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        onTap: () {
          // Navigate to transaction details
        },
      ),
    );
  }
  
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }
  
  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Icons.check_circle;
      case 'pending':
        return Icons.access_time;
      case 'cancelled':
        return Icons.cancel;
      default:
        return Icons.info;
    }
  }
}
