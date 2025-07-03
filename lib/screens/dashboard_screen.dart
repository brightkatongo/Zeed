import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  final Map<String, Color> customColors;
  final bool isEnglish;

  const DashboardScreen({
    super.key,
    required this.customColors,
    required this.isEnglish,
  });

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.customColors['background'],
      appBar: AppBar(
        title: Text(
          widget.isEnglish ? 'Dashboard' : 'Mbiri Yonse',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: widget.customColors['primary'],
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 2,
      ),
      body: RefreshIndicator(
        color: widget.customColors['primary'],
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1));
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildOverviewCards(),
              const SizedBox(height: 20),
              _buildRecentActivity(),
              const SizedBox(height: 20),
              _buildPerformanceMetrics(),
              const SizedBox(height: 20),
              _buildQuickStats(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOverviewCards() {
    final cards = [
      {
        'title': widget.isEnglish ? 'Total Sales' : 'Malonda Onse',
        'value': 'K45,230',
        'change': '+12%',
        'icon': Icons.trending_up,
        'color': Colors.green,
      },
      {
        'title': widget.isEnglish ? 'Active Listings' : 'Zoguritsa',
        'value': '24',
        'change': '+3',
        'icon': Icons.inventory,
        'color': widget.customColors['primary']!,
      },
      {
        'title': widget.isEnglish ? 'Pending Orders' : 'Malonda Oyembekezera',
        'value': '8',
        'change': '-2',
        'icon': Icons.pending,
        'color': Colors.orange,
      },
      {
        'title': widget.isEnglish ? 'Revenue' : 'Ndalama Zolowa',
        'value': 'K32,450',
        'change': '+8%',
        'icon': Icons.attach_money,
        'color': Colors.blue,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.isEnglish ? 'Overview' : 'Chidule',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: widget.customColors['text'],
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: cards.length,
          itemBuilder: (context, index) {
            final card = cards[index];
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        card['icon'] as IconData,
                        color: card['color'] as Color,
                        size: 24,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: (card['change'] as String).startsWith('+')
                              ? Colors.green.withOpacity(0.1)
                              : Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          card['change'] as String,
                          style: TextStyle(
                            fontSize: 10,
                            color: (card['change'] as String).startsWith('+')
                                ? Colors.green
                                : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    card['value'] as String,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    card['title'] as String,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildRecentActivity() {
    final activities = [
      {
        'title': widget.isEnglish ? 'New order received' : 'Order yatsopano yalandidwa',
        'subtitle': widget.isEnglish ? 'Maize - 100kg' : 'Chimanga - 100kg',
        'time': '2 hours ago',
        'icon': Icons.shopping_cart,
        'color': Colors.green,
      },
      {
        'title': widget.isEnglish ? 'Payment processed' : 'Malipiro apangidwa',
        'subtitle': 'K2,500',
        'time': '4 hours ago',
        'icon': Icons.payment,
        'color': Colors.blue,
      },
      {
        'title': widget.isEnglish ? 'Product listed' : 'Chinthu chalemba',
        'subtitle': widget.isEnglish ? 'Soya Beans - 50kg' : 'Soya - 50kg',
        'time': '6 hours ago',
        'icon': Icons.add_circle,
        'color': widget.customColors['primary']!,
      },
      {
        'title': widget.isEnglish ? 'Transport arranged' : 'Mayendedwe akonzedwa',
        'subtitle': widget.isEnglish ? 'Delivery to Lusaka' : 'Kutumiza ku Lusaka',
        'time': '1 day ago',
        'icon': Icons.local_shipping,
        'color': Colors.orange,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.isEnglish ? 'Recent Activity' : 'Zochitika Posachedwa',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: widget.customColors['text'],
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                widget.isEnglish ? 'View All' : 'Onani Zonse',
                style: TextStyle(color: widget.customColors['primary']),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: activities.length,
          itemBuilder: (context, index) {
            final activity = activities[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: (activity['color'] as Color).withOpacity(0.1),
                  child: Icon(
                    activity['icon'] as IconData,
                    color: activity['color'] as Color,
                    size: 20,
                  ),
                ),
                title: Text(
                  activity['title'] as String,
                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                ),
                subtitle: Text(
                  activity['subtitle'] as String,
                  style: const TextStyle(fontSize: 12),
                ),
                trailing: Text(
                  activity['time'] as String,
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildPerformanceMetrics() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.isEnglish ? 'Performance Metrics' : 'Zoyeserera',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: widget.customColors['text'],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildMetricRow(
                widget.isEnglish ? 'Sales Growth' : 'Kukula kwa Malonda',
                '12%',
                0.75,
                Colors.green,
              ),
              const SizedBox(height: 16),
              _buildMetricRow(
                widget.isEnglish ? 'Customer Satisfaction' : 'Kukondwera kwa Makasitomala',
                '4.8/5',
                0.96,
                Colors.blue,
              ),
              const SizedBox(height: 16),
              _buildMetricRow(
                widget.isEnglish ? 'Order Fulfillment' : 'Kukwaniritsa ma Order',
                '94%',
                0.94,
                widget.customColors['primary']!,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMetricRow(String title, String value, double progress, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey[200],
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      ],
    );
  }

  Widget _buildQuickStats() {
    final stats = [
      {
        'label': widget.isEnglish ? 'Products Sold' : 'Zinthu Zogulitsidwa',
        'value': '156',
        'icon': Icons.shopping_bag,
      },
      {
        'label': widget.isEnglish ? 'Happy Customers' : 'Makasitomala Osangalala',
        'value': '89',
        'icon': Icons.people,
      },
      {
        'label': widget.isEnglish ? 'Deliveries' : 'Zotumizidwa',
        'value': '124',
        'icon': Icons.local_shipping,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.isEnglish ? 'Quick Stats' : 'Ziwerengero Zachangu',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: widget.customColors['text'],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: stats.map((stat) => Expanded(
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Icon(
                    stat['icon'] as IconData,
                    color: widget.customColors['primary'],
                    size: 28,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    stat['value'] as String,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    stat['label'] as String,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          )).toList(),
        ),
      ],
    );
  }
}