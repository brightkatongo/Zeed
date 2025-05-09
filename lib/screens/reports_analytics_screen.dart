import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ReportsAnalyticsScreen extends StatefulWidget {
  final Map<String, Color> customColors;
  final bool isEnglish;

  const ReportsAnalyticsScreen({
    super.key,
    required this.customColors,
    required this.isEnglish,
  });

  @override
  State<ReportsAnalyticsScreen> createState() => _ReportsAnalyticsScreenState();
}

class _ReportsAnalyticsScreenState extends State<ReportsAnalyticsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _animationController;
  late AnimationController _slideController;
  
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  final List<Map<String, dynamic>> _salesData = List.generate(
    5,
    (index) => {
      'date': DateTime(2024, index + 1),
      'sales': (index + 1) * 100,
      'revenue': (index + 1) * 1000,
    },
  );

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeIn,
    ));

    _slideController.forward();
    _animationController.forward();

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        _animationController.reset();
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  String get _currencySymbol => widget.isEnglish ? '\$' : 'TSh';

  @override
  Widget build(BuildContext context) {
    final primaryColor = widget.customColors['primary'] ?? Theme.of(context).primaryColor;
    
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Theme(
          data: Theme.of(context).copyWith(
            primaryColor: primaryColor,
            cardTheme: CardTheme(
              elevation: 4,
              shadowColor: primaryColor.withAlpha(51), // Replace withOpacity(0.2)
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          child: Scaffold(
            appBar: _buildAppBar(context),
            body: SafeArea(
              child: Column(
                children: [
                  _buildTabBar(),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildSalesReport(),
                        _buildInventoryReport(),
                        _buildPriceTrends(),
                        _buildMarketAnalysis(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSalesReport() {
    return FadeTransition(
      opacity: _animationController,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSummaryCards(),
            const SizedBox(height: 24),
            _buildLineChart(),
            const SizedBox(height: 24),
            _buildSalesTable(),
          ],
        ),
      ),
    );
  }

  Widget _buildInventoryReport() {
    return FadeTransition(
      opacity: _animationController,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inventory_2,
              size: 48,
              color: widget.customColors['primary'],
            ),
            const SizedBox(height: 16),
            Text(
              widget.isEnglish ? 'Inventory Report' : 'Ripoti ya Hifadhi',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceTrends() {
    return FadeTransition(
      opacity: _animationController,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.trending_up,
              size: 48,
              color: widget.customColors['primary'],
            ),
            const SizedBox(height: 16),
            Text(
              widget.isEnglish ? 'Price Trends' : 'Mwenendo wa Bei',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMarketAnalysis() {
    return FadeTransition(
      opacity: _animationController,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.analytics,
              size: 48,
              color: widget.customColors['primary'],
            ),
            const SizedBox(height: 16),
            Text(
              widget.isEnglish ? 'Market Analysis' : 'Uchambuzi wa Soko',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCards() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _buildSummaryCard(
          title: widget.isEnglish ? 'Total Sales' : 'Jumla ya Mauzo',
          value: '${_currencySymbol}15,000',
          icon: Icons.trending_up,
          change: '+15%',
        ),
        _buildSummaryCard(
          title: widget.isEnglish ? 'Average Order' : 'Wastani wa Oda',
          value: '${_currencySymbol}250',
          icon: Icons.shopping_cart,
          change: '+5%',
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required IconData icon,
    required String change,
  }) {
    final primaryColor = widget.customColors['primary'] ?? Theme.of(context).primaryColor;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: primaryColor),
                Text(
                  change,
                  style: TextStyle(
                    color: change.startsWith('+') ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              title,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLineChart() {
    final primaryColor = widget.customColors['primary'] ?? Theme.of(context).primaryColor;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.isEnglish ? 'Sales Trend' : 'Mwenendo wa Mauzo',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        FlSpot(0, 3 * _animationController.value),
                        FlSpot(2, 5 * _animationController.value),
                        FlSpot(4, 4 * _animationController.value),
                        FlSpot(6, 6 * _animationController.value),
                      ],
                      isCurved: true,
                      color: primaryColor,
                      barWidth: 3,
                      dotData: FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: primaryColor.withAlpha(26), // Replace withOpacity(0.1)
                      ),
                    ),
                  ],
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(show: false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSalesTable() {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              widget.isEnglish ? 'Sales Details' : 'Maelezo ya Mauzo',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: [
                DataColumn(label: Text(widget.isEnglish ? 'Date' : 'Tarehe')),
                DataColumn(label: Text(widget.isEnglish ? 'Sales' : 'Mauzo')),
                DataColumn(label: Text(widget.isEnglish ? 'Revenue' : 'Mapato')),
              ],
              rows: _salesData.map((data) {
                return DataRow(cells: [
                  DataCell(Text(
                    '${data['date'].month}/${data['date'].year}',
                  )),
                  DataCell(Text('${data['sales']}')),
                  DataCell(Text('$_currencySymbol${data['revenue']}')),
                ]);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final textColor = widget.customColors['text'] ?? Colors.black;
    final primaryColor = widget.customColors['primary'] ?? Theme.of(context).primaryColor;

    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: Hero(
        tag: 'back_button',
        child: Material(
          color: Colors.transparent,
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: primaryColor),
            onPressed: () {
              _slideController.reverse().then((_) {
                Navigator.of(context).pop();
              });
            },
          ),
        ),
      ),
      title: Text(
        widget.isEnglish ? 'Reports & Analytics' : 'Ripoti na Uchambuzi',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
      actions: [_buildMoreMenu(primaryColor)],
    );
  }

  Widget _buildMoreMenu(Color primaryColor) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert, color: primaryColor),
      onSelected: _handleMenuSelection,
      itemBuilder: (BuildContext context) => [
        PopupMenuItem<String>(
          value: 'export',
          child: Row(
            children: [
              Icon(Icons.download, size: 20, color: primaryColor),
              const SizedBox(width: 8),
              Text(widget.isEnglish ? 'Export Data' : 'Pakua Data'),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'refresh',
          child: Row(
            children: [
              Icon(Icons.refresh, size: 20, color: primaryColor),
              const SizedBox(width: 8),
              Text(widget.isEnglish ? 'Refresh' : 'Onyesha Upya'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    final primaryColor = widget.customColors['primary'] ?? Theme.of(context).primaryColor;
    
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        labelColor: primaryColor,
        unselectedLabelColor: Colors.grey,
        indicatorColor: primaryColor,
        indicatorWeight: 3,
        labelStyle: const TextStyle(fontWeight: FontWeight.bold),
        tabs: [
          Tab(text: widget.isEnglish ? 'Sales' : 'Mauzo'),
          Tab(text: widget.isEnglish ? 'Inventory' : 'Hifadhi'),
          Tab(text: widget.isEnglish ? 'Prices' : 'Bei'),
          Tab(text: widget.isEnglish ? 'Market' : 'Soko'),
        ],
      ),
    );
  }

  void _handleMenuSelection(String value) {
    switch (value) {
      case 'export':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.isEnglish ? 'Exporting data...' : 'Inapakua data...',
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: widget.customColors['primary'],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
        break;
   case 'refresh':
        setState(() {
          _animationController.reset();
          _animationController.forward();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.isEnglish ? 'Refreshing...' : 'Inaonyesha upya...',
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: widget.customColors['primary'],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
        break;
    }
  }
}