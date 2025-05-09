import 'package:flutter/material.dart';

class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({super.key});

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  final customColors = {
    'primary': const Color(0xFF2E7D32),
    'secondary': const Color(0xFF1565C0),
    'accent': const Color(0xFFFFB74D),
    'background': const Color(0xFFF5F5F5),
    'surface': Colors.white,
    'text': const Color(0xFF212121),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Marketplace'),
        backgroundColor: customColors['primary'],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSearchBar(),
          const SizedBox(height: 16),
          _buildCategories(),
          const SizedBox(height: 16),
          _buildFeaturedListings(),
          const SizedBox(height: 16),
          _buildRecentListings(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddListingDialog(),
        backgroundColor: customColors['primary'],
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search products...',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  Widget _buildCategories() {
    final categories = [
      {'name': 'Grains', 'icon': Icons.grass},
      {'name': 'Vegetables', 'icon': Icons.eco},
      {'name': 'Fruits', 'icon': Icons.apple},
      {'name': 'Equipment', 'icon': Icons.agriculture},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Categories',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: categories
                .map((category) => _buildCategoryCard(
                      category['name'] as String,
                      category['icon'] as IconData,
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryCard(String name, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          child: Row(
            children: [
              Icon(icon, color: customColors['primary']),
              const SizedBox(width: 8),
              Text(name),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedListings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Featured Listings',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.8,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: 4,
          itemBuilder: (context, index) {
            return _buildProductCard(
              'Product ${index + 1}',
              'K${(index + 1) * 100}',
              '${(index + 1) * 10}kg',
            );
          },
        ),
      ],
    );
  }

  Widget _buildRecentListings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Listings',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 5,
          itemBuilder: (context, index) {
            return _buildListingItem(
              'Recent Product ${index + 1}',
              'K${(index + 1) * 150}',
              '${(index + 1) * 5}kg',
            );
          },
        ),
      ],
    );
  }

  Widget _buildProductCard(String name, String price, String quantity) {
    return Card(
      child: InkWell(
        onTap: () {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(4),
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.image,
                    size: 40,
                    color: Colors.grey[400],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    quantity,
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    price,
                    style: TextStyle(
                      color: customColors['primary'],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListingItem(String name, String price, String quantity) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
            child: Icon(
              Icons.image,
              color: Colors.grey[400],
            ),
          ),
        ),
        title: Text(name),
        subtitle: Text(quantity),
        trailing: Text(
          price,
          style: TextStyle(
            color: customColors['primary'],
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: () {},
      ),
    );
  }

  void _showAddListingDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Add New Listing',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Product Name',
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Price',
                        border: const OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Quantity',
                        border: const OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: customColors['primary'],
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: const Text(
                  'Add Listing',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}