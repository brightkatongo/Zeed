import '../models/dashboard.dart';
import 'package:flutter/material.dart';

class ActiveListingsWidget extends StatelessWidget {
  final List<ActiveListing> activeListings;
  
  const ActiveListingsWidget({Key? key, required this.activeListings}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: activeListings.map((listing) => _buildListingCard(listing)).toList(),
    );
  }
  
  Widget _buildListingCard(ActiveListing listing) {
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
          backgroundColor: Colors.green.shade100,
          child: Text(
            listing.farmer.substring(0, 1),
            style: TextStyle(
              color: Colors.green.shade800,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Row(
          children: [
            Text(listing.farmer),
            if (listing.verified)
              Container(
                margin: EdgeInsets.only(left: 8),
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Verified',
                  style: TextStyle(
                    color: Colors.green.shade800,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        subtitle: Text('Available: ${listing.quantity} ${listing.product}'),
        trailing: Icon(Icons.chevron_right),
        onTap: () {
          // Navigate to listing details
        },
      ),
    );
  }
}
