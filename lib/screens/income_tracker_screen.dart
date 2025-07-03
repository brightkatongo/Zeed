import 'dart:typed_data';
import 'providers/app_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/main_navigation/profile_screen.dart'; // New
import 'screens/marketplace/marketplace_screen.dart'; // New
import 'screens/agricultural_management/farm_profile_screen.dart'; // New
import 'screens/financial_management/loans/loans_list_screen.dart'; // New
import 'screens/authentication/login_screen.dart'; // For logout navigation
import 'screens/dashboard_screen.dart'; // Assuming this is your dashboard content
import 'screens/marketplace/sell_products_screen.dart'; // Assuming this is correct
import 'screens/reports_analytics_screen.dart'; // Existing but ensure path is correct
import 'screens/financial_services_screen.dart'; // Existing but ensure path is correct

// Import your screens and providers

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..repeat();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // List of pages for the bottom navigation bar
  final List<Widget> _pages = [
    const DashboardScreen(), // Renamed to clearly indicate it's the dashboard content
    const LoansListScreen(),
    const FarmProfileScreen(),
    const MarketplaceScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // Initialize shared preferences
    ref.read(sharedPreferencesInitProvider);

    // Check authentication token
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAuthentication();
    });
  }

  Future<void> _checkAuthentication() async {
    final prefs = ref.read(sharedPreferencesProvider.notifier).state;
    if (prefs != null) {
      final token = prefs.getString('token');
      ref.read(authTokenProvider.notifier).state = token;

      if (token == null) {
        // Navigate to login screen if not authenticated
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        }
      }
    }
  }

  Future<void> _logout() async {
    final prefs = ref.read(sharedPreferencesProvider.notifier).state;
    if (prefs != null) {
      await prefs.remove('token');
      ref.read(authTokenProvider.notifier).state = null;

      // Navigate to login screen
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final customColors = ref.watch(customColorsProvider);
    final isEnglish = ref.watch(isEnglishProvider);
    final selectedIndex = ref.watch(selectedIndexProvider);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: customColors['background'],
      appBar: _buildAppBar(),
      drawer: _buildDrawer(),
      body: _pages[selectedIndex], // Display the selected page
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  AppBar _buildAppBar() {
    final customColors = ref.watch(customColorsProvider);
    final isEnglish = ref.watch(isEnglishProvider);

    return AppBar(
      backgroundColor: customColors['primary'],
      elevation: 2,
      leading: IconButton(
        icon: const Icon(Icons.menu, color: Colors.white),
        onPressed: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.agriculture, color: customColors['surface'], size: 24),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              'Agrifinance',
              style: TextStyle(
                color: customColors['surface'],
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(
            isEnglish ? Icons.language : Icons.translate,
            color: customColors['surface'],
          ),
          onPressed: () => ref.read(isEnglishProvider.notifier).state = !isEnglish,
        ),
        Badge(
          label: const Text('3'),
          child: IconButton(
            icon: Icon(Icons.notifications, color: customColors['surface']),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notifications')),
              );
            },
          ),
        ),
      ],
    );
  }

  // Moved the dashboard content to its own widget (DashboardScreen)
  // so HomePage can manage navigation properly.
  // The content of the original _buildBody() should go into DashboardScreen.
  // For now, _buildBody() is removed from HomePage and _pages[selectedIndex] handles it.

  Widget _buildFloatingActionButton() {
    final customColors = ref.watch(customColorsProvider);
    final isEnglish = ref.watch(isEnglishProvider);

    return FloatingActionButton.extended(
      onPressed: () {
        // Example action: navigate to a quick action screen or show a menu
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(isEnglish ? 'Quick action triggered!' : 'Zochita zachangu zayamba!')),
        );
      },
      label: Text(isEnglish ? 'Quick Action' : 'Zochita Zachangu'),
      icon: const Icon(Icons.add_circle_outline),
      backgroundColor: customColors['accent'],
      foregroundColor: customColors['text'],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }

  Widget _buildDrawer() {
    final customColors = ref.watch(customColorsProvider);
    final isEnglish = ref.watch(isEnglishProvider);
    final selectedIndex = ref.watch(selectedIndexProvider);

    final drawerItems = [
      {
        'icon': Icons.dashboard,
        'title': isEnglish ? 'Dashboard' : 'Mbiri Yonse',
        'index': 0, // Corresponds to the index in _pages
      },
      {
        'icon': Icons.account_balance_wallet,
        'title': isEnglish ? 'Loans' : 'Ngongole',
        'index': 1, // Corresponds to the index in _pages
      },
      {
        'icon': Icons.agriculture,
        'title': isEnglish ? 'Farm Management' : 'Kasamalidwe ka Famu',
        'index': 2, // Corresponds to the index in _pages
      },
      {
        'icon': Icons.store,
        'title': isEnglish ? 'Marketplace' : 'Msika',
        'index': 3, // Corresponds to the index in _pages
      },
      {
        'icon': Icons.person,
        'title': isEnglish ? 'Profile' : 'Mbiri Yanu',
        'index': 4, // Corresponds to the index in _pages
      },
      // Additional drawer items not in bottom navigation
      {
        'icon': Icons.analytics,
        'title': isEnglish ? 'Reports & Analytics' : 'Malipoti & Kuunika',
        'screen': const ReportsAnalyticsScreen(), // Navigate directly to screen
      },
      {
        'icon': Icons.savings,
        'title': isEnglish ? 'Savings Account' : 'Akaunti Yosungira Ndalama',
        'screen': const SavingsAccountScreen(),
      },
      {
        'icon': Icons.history,
        'title': isEnglish ? 'Transaction History' : 'Mbiri ya Malonda',
        'screen': const TransactionHistoryScreen(),
      },
      {
        'icon': Icons.money_off,
        'title': isEnglish ? 'Expense Tracker' : 'Kafukufuku wa Zopereka',
        'screen': const ExpenseTrackerScreen(),
      },
      {
        'icon': Icons.attach_money,
        'title': isEnglish ? 'Income Tracker' : 'Kafukufuku wa Ndalama',
        'screen': const IncomeTrackerScreen(),
      },
      {
        'icon': Icons.settings,
        'title': isEnglish ? 'Settings' : 'Zokonda',
        'screen': DashboardScreen(), // Placeholder for now, replace with actual SettingsScreen
      },
      {
        'icon': Icons.help,
        'title': isEnglish ? 'Help & Support' : 'Thandizo',
        'screen': DashboardScreen(), // Placeholder for now, replace with actual HelpScreen
      },
      {
        'icon': Icons.logout,
        'title': isEnglish ? 'Logout' : 'Tulukani',
        'action': _logout, // Call a function for logout
      },
    ];

    return Drawer(
      backgroundColor: customColors['surface'],
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: customColors['primary'],
              // FIX: Use a proper image for the header background
              image: const DecorationImage(
                image: AssetImage('assets/images/farm_background.jpg'), // Ensure this path is correct or use NetworkImage
                fit: BoxFit.cover,
                opacity: 0.2,
              ),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: customColors['surface'],
              child: Icon(Icons.person, color: customColors['primary'], size: 35),
            ),
            accountName: Text(
              isEnglish ? 'Bright Katongo' : 'Bright Katongo', // FIX: Removed trailing space
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: customColors['surface'], // Ensures text is visible
              ),
            ),
            accountEmail: Text(
              isEnglish ? 'Verified Farmer' : 'Mlimi Ovomekezeka',
              style: TextStyle(fontSize: 14, color: customColors['surface'].withOpacity(0.8)),
            ),
          ),
          ...drawerItems.map((item) {
            if (item.containsKey('index')) {
              // Item for bottom navigation pages
              return ListTile(
                leading: Icon(item['icon'] as IconData, color: customColors['text']),
                title: Text(item['title'] as String, style: TextStyle(color: customColors['text'])),
                selected: selectedIndex == item['index'],
                selectedColor: customColors['primary'],
                onTap: () {
                  ref.read(selectedIndexProvider.notifier).state = item['index'] as int;
                  Navigator.pop(context); // Close the drawer
                },
              );
            } else if (item.containsKey('screen')) {
              // Item for direct screen navigation
              return ListTile(
                leading: Icon(item['icon'] as IconData, color: customColors['text']),
                title: Text(item['title'] as String, style: TextStyle(color: customColors['text'])),
                onTap: () {
                  Navigator.pop(context); // Close the drawer first
                  Navigator.push(context, MaterialPageRoute(builder: (context) => item['screen'] as Widget));
                },
              );
            } else if (item.containsKey('action')) {
              // Item for an action like logout
              return ListTile(
                leading: Icon(item['icon'] as IconData, color: Colors.red),
                title: Text(item['title'] as String, style: const TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context); // Close the drawer first
                  (item['action'] as Function())(); // Execute the action
                },
              );
            }
            return const SizedBox.shrink(); // Fallback
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    final customColors = ref.watch(customColorsProvider);
    final selectedIndex = ref.watch(selectedIndexProvider);
    final isEnglish = ref.watch(isEnglishProvider);

    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: (index) {
        ref.read(selectedIndexProvider.notifier).state = index;
      },
      selectedItemColor: customColors['primary'],
      unselectedItemColor: customColors['subText'],
      backgroundColor: customColors['surface'],
      type: BottomNavigationBarType.fixed, // Ensures all labels are shown
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.home),
          label: isEnglish ? 'Home' : 'Kwathu',
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.account_balance_wallet),
          label: isEnglish ? 'Loans' : 'Ngongole',
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.agriculture),
          label: isEnglish ? 'Farm' : 'Famu',
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.store),
          label: isEnglish ? 'Market' : 'Msika',
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.person),
          label: isEnglish ? 'Profile' : 'Mbiri',
        ),
      ],
    );
  }
}

// Dummy DashboardScreen (assuming original HomePage body content moves here)
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customColors = ref.watch(customColorsProvider);
    final isEnglish = ref.watch(isEnglishProvider);
    late final AnimationController _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: Navigator.of(context), // Use NavigatorState as TickerProvider
    )..repeat(); // Removed .repeat() from here, it should be in Stateful Widget

    return RefreshIndicator(
      color: customColors['primary'],
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 1));
        // TODO: Implement actual data refresh logic here
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWeatherWidget(customColors, isEnglish, _controller),
            _buildSearchBar(isEnglish),
            _buildQuickActions(context, customColors, isEnglish),
            _buildMarketPrices(customColors, isEnglish),
            _buildActiveListings(customColors, isEnglish),
            _buildRecentTransactions(customColors, isEnglish),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherWidget(Map<String, Color> customColors, bool isEnglish, AnimationController controller) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [customColors['primary']!, customColors['secondary']!],
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.white, size: 16),
                  const SizedBox(width: 4),
                  const Text(
                    'Lusaka, Zambia',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Text(
                'Partly Cloudy • 24°C',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 8),
              Text(
                isEnglish ? 'Good day for farming!' : 'Tsiku labwino kwa ulimi!',
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
          RotationTransition(
            turns: Tween(begin: 0.0, end: 0.05).animate(controller),
            child: const Icon(Icons.wb_sunny, color: Colors.white, size: 48),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(bool isEnglish) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        decoration: InputDecoration(
          hintText: isEnglish ? 'Search products or farmers...' : 'Fufuzani zaulimi...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: const Icon(Icons.filter_list),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey[200],
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, Map<String, Color> customColors, bool isEnglish) {
    final actions = [
      {
        'title': isEnglish ? 'Sell Products' : 'Gulitsani',
        'icon': Icons.store,
        'color': customColors['primary'],
        'screen': const SellProductsScreen(),
      },
      {
        'title': isEnglish ? 'Buy Products' : 'Gurani',
        'icon': Icons.shopping_cart,
        'color': customColors['secondary'],
        'screen': const FinancialServicesScreen(), // Or MarketplaceScreen directly
      },
      {
        'title': isEnglish ? 'Transport' : 'Mayendedwe',
        'icon': Icons.local_shipping,
        'color': customColors['accent'],
        'screen': const SizedBox(), // Placeholder: replace with actual Transport screen
      },
      {
        'title': isEnglish ? 'Finance' : 'Ndalama',
        'icon': Icons.account_balance_wallet,
        'color': Colors.purple,
        'screen': const FinancialServicesScreen(),
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isEnglish ? 'Quick Actions' : 'Zochita Msanga',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: customColors['text'],
            ),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.5,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: actions.length,
            itemBuilder: (context, index) {
              return _buildActionCard(
                context,
                title: actions[index]['title'] as String,
                icon: actions[index]['icon'] as IconData,
                color: actions[index]['color'] as Color,
                screen: actions[index]['screen'] as Widget,
                customColors: customColors,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(
      BuildContext context, {
        required String title,
        required IconData icon,
        required Color color,
        required Widget screen,
        required Map<String, Color> customColors,
      }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      shadowColor: Colors.black26,
      child: InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => screen)),
        borderRadius: BorderRadius.circular(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withAlpha(25),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 28, color: color),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: customColors['text'],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMarketPrices(Map<String, Color> customColors, bool isEnglish) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isEnglish ? 'Today\'s Market Prices' : 'Mitengo ya Lero',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: customColors['text'],
                ),
              ),
              TextButton(
                onPressed: () {
                  // TODO: Navigate to MarketPricesScreen
                },
                child: Text(
                  isEnglish ? 'View All' : 'Onani Zonse',
                  style: TextStyle(color: customColors['primary']),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: 5,
            itemBuilder: (context, index) => _buildPriceCard(index, customColors),
          ),
        ),
      ],
    );
  }

  Widget _buildPriceCard(int index, Map<String, Color> customColors) {
    final products = [
      {'name': 'Maize', 'price': 'K250/50kg', 'trend': '+5%', 'icon': Icons.grass},
      {'name': 'Soya Beans', 'price': 'K450/50kg', 'trend': '+2%', 'icon': Icons.eco},
      {'name': 'Groundnuts', 'price': 'K350/50kg', 'trend': '-1%', 'icon': Icons.spa},
      {'name': 'Tomatoes', 'price': 'K80/box', 'trend': '+8%', 'icon': Icons.local_florist},
      {'name': 'Sweet Potatoes', 'price': 'K120/50kg', 'trend': '+3%', 'icon': Icons.grain},
    ];

    return Container(
      width: 160,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Card(
        elevation: 2,
        shadowColor: Colors.black26,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    products[index]['icon'] as IconData,
                    color: customColors['primary'],
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    products[index]['name'] as String,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: customColors['text'],
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                products[index]['price'] as String,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    (products[index]['trend'] as String).startsWith('+')
                        ? Icons.trending_up
                        : Icons.trending_down,
                    color: (products[index]['trend'] as String).startsWith('+')
                        ? Colors.green
                        : Colors.red,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    products[index]['trend'] as String,
                    style: TextStyle(
                      color: (products[index]['trend'] as String).startsWith('+')
                          ? Colors.green
                          : Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActiveListings(Map<String, Color> customColors, bool isEnglish) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isEnglish ? 'Active Listings' : 'Zoguritsa',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: customColors['text'],
                ),
              ),
              TextButton(
                onPressed: () {
                  // TODO: Navigate to MarketplaceScreen (ProductListingScreen)
                },
                child: Text(
                  isEnglish ? 'View All' : 'Onani Zonse',
                  style: TextStyle(color: customColors['primary']),
                ),
              ),
            ],
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 3,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemBuilder: (context, index) {
            final productTypes = ['Maize', 'Soya Beans', 'Groundnuts'];
            final quantities = ['500kg', '250kg', '120kg'];

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: CircleAvatar(
                  backgroundColor: customColors['primary']!.withAlpha(25),
                  child: Icon(Icons.agriculture, color: customColors['primary']),
                ),
                title: Row(
                  children: [
                    Text(
                      'Farmer ${index + 1}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: customColors['text'],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: customColors['primary']!.withAlpha(25),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Verified',
                        style: TextStyle(
                          fontSize: 10,
                          color: customColors['primary'],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                subtitle: Text(
                  isEnglish
                      ? 'Available: ${quantities[index]} ${productTypes[index]}'
                      : 'Zilipo: ${quantities[index]} ${productTypes[index]}',
                  style: const TextStyle(fontSize: 13),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                      onPressed: () {
                        // TODO: Implement contact farmer action
                      },
                      style: TextButton.styleFrom(
                        minimumSize: Size.zero,
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        isEnglish ? 'Contact' : 'Lankhulani',
                        style: TextStyle(color: customColors['secondary']),
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.chevron_right),
                  ],
                ),
                onTap: () {
                  // TODO: Navigate to ProductDetailsScreen
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildRecentTransactions(Map<String, Color> customColors, bool isEnglish) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isEnglish ? 'Recent Transactions' : 'Malonda Amene Achitika',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: customColors['text'],
                ),
              ),
              TextButton(
                onPressed: () {
                  // TODO: Navigate to TransactionHistoryScreen
                },
                child: Text(
                  isEnglish ? 'View All' : 'Onani Zonse',
                  style: TextStyle(color: customColors['primary']),
                ),
              ),
            ],
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 3,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemBuilder: (context, index) {
            final icons = [Icons.check_circle, Icons.access_time, Icons.check_circle];
            final colors = [Colors.green, Colors.orange, Colors.green];
            final bgColors = [Colors.green[100], Colors.orange[100], Colors.green[100]];
            final status = index == 1 ? (isEnglish ? 'Pending' : 'Yodikira') : (isEnglish ? 'Completed' : 'Yatha');

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: CircleAvatar(
                  backgroundColor: bgColors[index],
                  child: Icon(icons[index], color: colors[index]),
                ),
                title: Row(
                  children: [
                    Text(
                      isEnglish ? 'Transaction #${10235 + index}' : 'Malonda #${10235 + index}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: customColors['text'],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: colors[index].withAlpha(25),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          fontSize: 10,
                          color: colors[index],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                subtitle: Text(
                  isEnglish ? '23 Dec 2024 • Maize Sale' : '23 Dec 2024 • Kugulitsa Chimanga',
                  style: const TextStyle(fontSize: 13),
                ),
                trailing: Text(
                  'K${2500 - index * 200}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: customColors['primary'],
                  ),
                ),
                onTap: () {
                  // TODO: Navigate to LoanDetailsScreen or TransactionDetailsScreen
                },
              ),
            );
          },
        ),
      ],
    );
  }
}

// Dummy screens for now, you will replace these with actual implementations.
// Ensure these files are created in your project if they don't exist.
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Simulate successful login
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          },
          child: const Text('Simulate Login (Go to Home)'),
        ),
      ),
    );
  }
}

class FinancialServicesScreen extends ConsumerWidget {
  const FinancialServicesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customColors = ref.watch(customColorsProvider);
    final isEnglish = ref.watch(isEnglishProvider);
    return Scaffold(
      appBar: AppBar(title: Text(isEnglish ? 'Financial Services' : 'Ntchito Zandalama', style: TextStyle(color: customColors['surface']))),
      body: Center(child: Text(isEnglish ? 'Financial Services Content' : 'Zinthu Zandalama', style: TextStyle(color: customColors['text']))),
    );
  }
}

class SellProductsScreen extends ConsumerWidget {
  const SellProductsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customColors = ref.watch(customColorsProvider);
    final isEnglish = ref.watch(isEnglishProvider);
    return Scaffold(
      appBar: AppBar(title: Text(isEnglish ? 'Sell Products' : 'Gulitsani Zinthu', style: TextStyle(color: customColors['surface']))),
      body: Center(child: Text(isEnglish ? 'Sell Products Content' : 'Zogulitsa Zinthu', style: TextStyle(color: customColors['text']))),
    );
  }
}

class ReportsAnalyticsScreen extends ConsumerWidget {
  const ReportsAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customColors = ref.watch(customColorsProvider);
    final isEnglish = ref.watch(isEnglishProvider);
    return Scaffold(
      appBar: AppBar(title: Text(isEnglish ? 'Reports & Analytics' : 'Malipoti & Kuunika', style: TextStyle(color: customColors['surface']))),
      body: Center(child: Text(isEnglish ? 'Reports and Analytics Content' : 'Malipoti ndi Kuunika', style: TextStyle(color: customColors['text']))),
    );
  }
}