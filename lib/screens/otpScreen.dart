import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/app_providers.dart'; // Adjust path as needed

class MarketplaceScreen extends ConsumerWidget {
  const MarketplaceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customColors = ref.watch(customColorsProvider);
    final isEnglish = ref.watch(isEnglishProvider);

    final List<Map<String, dynamic>> products = [
      {'name': 'Fresh Tomatoes', 'price': 'K85/box', 'location': 'Lusaka', 'image': Icons.local_florist, 'color': Colors.red},
      {'name': 'Hybrid Maize Seeds', 'price': 'K300/bag', 'location': 'Choma', 'image': Icons.eco, 'color': Colors.green},
      {'name': 'Dairy Cows', 'price': 'K8,000/head', 'location': 'Mazabuka', 'image': Icons.pets, 'color': Colors.brown},
      {'name': 'Irrigation Pump', 'price': 'K4,500', 'location': 'Kabwe', 'image': Icons.water, 'color': Colors.blue},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEnglish ? 'Marketplace' : 'Msika',
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
              isEnglish ? 'Browse agricultural products and services.' : 'Fufuzani zinthu ndi ntchito za ulimi.',
              style: TextStyle(fontSize: 16, color: customColors['text']!.withOpacity(0.8)),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.8, // Adjust as needed
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return _buildProductGridCard(
                    context,
                    product: products[index],
                    customColors: customColors,
                    isEnglish: isEnglish,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductGridCard(
    BuildContext context, {
    required Map<String, dynamic> product,
    required Map<String, Color> customColors,
    required bool isEnglish,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(isEnglish ? 'Tapped on ${product['name']}!' : 'Anakanikizidwa pa ${product['name']}!')),
          );
          // TODO: Navigate to ProductDetailsScreen
        },
        borderRadius: BorderRadius.circular(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: (product['color'] as Color).withOpacity(0.1),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                ),
                child: Center(
                  child: Icon(
                    product['image'] as IconData,
                    size: 60,
                    color: product['color'] as Color,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['name'] as String,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: customColors['text'],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product['price'] as String,
                    style: TextStyle(
                      fontSize: 14,
                      color: customColors['primary'],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 14, color: customColors['text']!.withOpacity(0.6)),
                      const SizedBox(width: 4),
                      Text(
                        product['location'] as String,
                        style: TextStyle(fontSize: 12, color: customColors['text']!.withOpacity(0.6)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}