import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  final Map<String, Color> customColors;
  final bool isEnglish;

  const DashboardScreen({
    super.key,
    required this.customColors,
    required this.isEnglish,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late List<Animation<double>> _cardAnimations;
  
  // Sample data structure for dashboard metrics
  final List<DashboardMetric> _metrics = [
    DashboardMetric(
      titleEn: 'Total Sales',
      titleLocal: 'Zamgulira Zonse',
      value: 'K125,000',
      icon: Icons.trending_up,
      colorName: 'success',
      change: '+15%',
    ),
    DashboardMetric(
      titleEn: 'Active Listings',
      titleLocal: 'Zamalonda',
      value: '15',
      icon: Icons.store,
      colorName: 'secondary',
      change: '+3',
    ),
    DashboardMetric(
      titleEn: 'Products',
      titleLocal: 'Katundu',
      value: '8',
      icon: Icons.inventory,
      colorName: 'accent',
      change: 'New',
    ),
    DashboardMetric(
      titleEn: 'Rating',
      titleLocal: 'Mayankho',
      value: '4.8',
      icon: Icons.star,
      colorName: 'warning',
      change: '+0.2',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _cardAnimations = List.generate(
      _metrics.length,
      (index) => Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(
            index * 0.1,
            0.6 + (index * 0.1),
            curve: Curves.easeOut,
          ),
        ),
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.isEnglish ? 'Dashboard' : 'Mbiri Yonse',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: widget.customColors['text'],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // Implement notifications
            },
          ),
        ],
        backgroundColor: widget.customColors['surface'],
        elevation: 0,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshDashboard,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildWelcomeText(),
                const SizedBox(height: 24),
                _buildMetricsGrid(),
                const SizedBox(height: 24),
                _buildRecentActivity(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeText() {
    return Text(
      widget.isEnglish ? 'Welcome back!' : 'Muli bwanji!',
      style: TextStyle(
        fontSize: 14,
        color: widget.customColors['text']?.withOpacity(0.6),
      ),
    );
  }

  Widget _buildMetricsGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 600 ? 4 : 2;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.2,
          ),
          itemCount: _metrics.length,
          itemBuilder: (context, index) {
            return FadeTransition(
              opacity: _cardAnimations[index],
              child: _buildDashboardCard(_metrics[index]),
            );
          },
        );
      },
    );
  }

  Widget _buildDashboardCard(DashboardMetric metric) {
    final color = _getColorForName(metric.colorName);
    
    return Material(
      elevation: 2,
      shadowColor: Colors.grey.withOpacity(0.2),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () => _onMetricTap(metric),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: widget.customColors['surface'],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(metric.icon, color: color, size: 24),
                  if (metric.change != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        metric.change!,
                        style: TextStyle(
                          color: color,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              const Spacer(),
              Text(
                widget.isEnglish ? metric.titleEn : metric.titleLocal,
                style: TextStyle(
                  color: widget.customColors['text']?.withOpacity(0.6),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                metric.value,
                style: TextStyle(
                  color: widget.customColors['text'],
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.isEnglish ? 'Recent Activity' : 'Zochitika Posachedwa',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: widget.customColors['text'],
          ),
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 2,
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 3,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: widget.customColors['primary']?.withOpacity(0.1),
                  child: Icon(
                    Icons.shopping_bag,
                    color: widget.customColors['primary'],
                  ),
                ),
                title: Text(
                  widget.isEnglish ? 'New Sale' : 'Kugulitsa Kwatsopano',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  widget.isEnglish ? '2 minutes ago' : 'Mphindi 2 zapitazo',
                ),
                trailing: const Text('K1,200'),
              );
            },
          ),
        ),
      ],
    );
  }

  Color _getColorForName(String name) {
    switch (name) {
      case 'success':
        return Colors.green;
      case 'warning':
        return Colors.amber;
      case 'secondary':
        return widget.customColors['secondary'] ?? Colors.blue;
      case 'accent':
        return widget.customColors['accent'] ?? Colors.purple;
      default:
        return widget.customColors['primary'] ?? Colors.blue;
    }
  }

  void _onMetricTap(DashboardMetric metric) {
    // Implement metric tap handling
    debugPrint('Tapped on ${metric.titleEn}');
  }

  Future<void> _refreshDashboard() async {
    // Implement refresh logic
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      // Update data here
    });
  }
}

class DashboardMetric {
  final String titleEn;
  final String titleLocal;
  final String value;
  final IconData icon;
  final String colorName;
  final String? change;

  const DashboardMetric({
    required this.titleEn,
    required this.titleLocal,
    required this.value,
    required this.icon,
    required this.colorName,
    this.change,
  });
}