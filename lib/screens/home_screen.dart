import 'dart:typed_data';
import 'loginScreen.dart';
import 'dashboard_screen.dart';
import 'ai_assistant_screen.dart';
import 'sell_products_screen.dart';
import 'package:flutter/material.dart';
import 'reports_analytics_screen.dart';
import 'financial_services_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Add these imports for your screen files

// Auth token provider
final authTokenProvider = StateProvider<String?>((ref) => null);

// Custom colors provider
final customColorsProvider = Provider<Map<String, Color>>((ref) => {
      'primary': const Color(0xFF2E7D32),
      'secondary': const Color(0xFF1565C0),
      'accent': const Color(0xFFFFB74D),
      'background': const Color(0xFFF5F5F5),
      'surface': Colors.white,
      'text': const Color(0xFF212121),
    });

// Language provider
final isEnglishProvider = StateProvider<bool>((ref) => true);

// Selected index provider for bottom navigation
final selectedIndexProvider = StateProvider<int>((ref) => 0);

// Shared preferences provider
final sharedPreferencesProvider = StateProvider<SharedPreferences?>((ref) => null);

// Shared preferences initialization provider
final sharedPreferencesInitProvider = FutureProvider<SharedPreferences>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  ref.read(sharedPreferencesProvider.notifier).state = prefs;
  return prefs;
});

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
      body: _buildBody(),
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

  Widget _buildBody() {
    final customColors = ref.watch(customColorsProvider);
    
    return RefreshIndicator(
      color: customColors['primary'],
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 1));
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWeatherWidget(),
            _buildSearchBar(),
            _buildQuickActions(),
            _buildMarketPrices(),
            _buildActiveListings(),
            _buildRecentTransactions(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherWidget() {
    final customColors = ref.watch(customColorsProvider);
    final isEnglish = ref.watch(isEnglishProvider);
    
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
            turns: Tween(begin: 0.0, end: 0.05).animate(_controller),
            child: const Icon(Icons.wb_sunny, color: Colors.white, size: 48),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    final isEnglish = ref.watch(isEnglishProvider);
    
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

  Widget _buildQuickActions() {
    final customColors = ref.watch(customColorsProvider);
    final isEnglish = ref.watch(isEnglishProvider);
    
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
        'screen': const FinancialServicesScreen(),
      },
      {
        'title': isEnglish ? 'Transport' : 'Mayendedwe',
        'icon': Icons.local_shipping,
        'color': customColors['accent'],
        'screen': DashboardScreen(customColors: customColors, isEnglish: isEnglish),
      },
      {
        'title': isEnglish ? 'Finance' : 'Ndalama',
        'icon': Icons.account_balance_wallet,
        'color': Colors.purple,
        'screen': ReportsAnalyticsScreen(customColors: customColors, isEnglish: isEnglish),
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
                title: actions[index]['title'] as String,
                icon: actions[index]['icon'] as IconData,
                color: actions[index]['color'] as Color,
                screen: actions[index]['screen'] as Widget,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required String title,
    required IconData icon,
    required Color color,
    required Widget screen,
  }) {
    final customColors = ref.watch(customColorsProvider);
    
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

  Widget _buildMarketPrices() {
    final customColors = ref.watch(customColorsProvider);
    final isEnglish = ref.watch(isEnglishProvider);
    
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
                onPressed: () {},
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
            itemBuilder: (context, index) => _buildPriceCard(index),
          ),
        ),
      ],
    );
  }

  Widget _buildPriceCard(int index) {
    final customColors = ref.watch(customColorsProvider);
    
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

  Widget _buildActiveListings() {
    final customColors = ref.watch(customColorsProvider);
    final isEnglish = ref.watch(isEnglishProvider);
    
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
                onPressed: () {},
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
                      onPressed: () {},
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
                onTap: () {},
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildRecentTransactions() {
    final customColors = ref.watch(customColorsProvider);
    final isEnglish = ref.watch(isEnglishProvider);
    
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
                onPressed: () {},
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
                onTap: () {},
              ),
            );
          },
        ),
      ],
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
        'screen': DashboardScreen(customColors: customColors, isEnglish: isEnglish),
      },
      {
        'icon': Icons.home,
        'title': isEnglish ? 'Home' : 'Kwathu',
        'screen': const HomePage(),
      },
      {
        'icon': Icons.analytics,
        'title': isEnglish ? 'Reports' : 'Malipoti',
        'screen': ReportsAnalyticsScreen(customColors: customColors, isEnglish: isEnglish),
      },
      {
        'icon': Icons.account_balance_wallet,
        'title': isEnglish ? 'Financial Services' : 'Ndalama',
        'screen': const FinancialServicesScreen(),
      },
      {
        'icon': Icons.local_shipping,
        'title': isEnglish ? 'Transport' : 'Mayendedwe',
        'screen': DashboardScreen(customColors: customColors, isEnglish: isEnglish),
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
              image: DecorationImage(
                image: MemoryImage(
                  Uint8List.fromList([
                    0xFF, 0x2E, 0x7D, 0x32,
                    0xFF, 0x2E, 0x7D, 0x32,
                  ]),
                ),
                fit: BoxFit.cover,
                opacity: 0.2,
              ),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: customColors['surface'],
              child: Icon(Icons.person, color: customColors['primary'], size: 35),
            ),
            accountName: Text(
              isEnglish ? 'Bright Katongo' : ' Bright Katongo',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            accountEmail: Text(
              isEnglish ? 'Verified Farmer' : 'Mlimi Ovomekezeka',
              style: const TextStyle(fontSize: 14),
            ),
          ),
          ...drawerItems.map((item) => _buildDrawerItem(
                icon: item['icon'] as IconData,
                title: item['title'] as String,
                screen: item['screen'] as Widget,
              )),
          const Divider(),
          _buildDrawerItem(
            icon: Icons.chat_bubble,
            title: isEnglish ? 'AI Assistant' : 'Wothandiza wa AI',
            screen: AIAssistantScreen(isEnglish: isEnglish, customColors: customColors),
          ),
          _buildDrawerItem(
            icon: Icons.help,
            title: isEnglish ? 'Help & Support' : 'Thandizo',
            screen: AIAssistantScreen(isEnglish: isEnglish, customColors: customColors),
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.logout, color: customColors['text']),
            title: Text(
              isEnglish ? 'Log Out' : 'Tulukani',
              style: TextStyle(color: customColors['text']),
            ),
            onTap: () => _logout(),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required Widget screen,
  }) {
    final customColors = ref.watch(customColorsProvider);
    final isEnglish = ref.watch(isEnglishProvider);
    final selectedIndex = ref.watch(selectedIndexProvider);
    
    final bool isSelected = (title == (isEnglish ? 'Home' : 'Kwathu') && selectedIndex == 0);
    
    return ListTile(
      leading: Icon(
        icon, 
        color: isSelected ? customColors['primary'] : customColors['text'],
      ),
      title: Text(
        title, 
        style: TextStyle(
          color: isSelected ? customColors['primary'] : customColors['text'],
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      tileColor: isSelected ? customColors['primary']!.withAlpha(25) : null,
      onTap: () {
        Navigator.pop(context);
        if (screen is! HomePage) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
        }
      },
    );
  }

  Widget _buildBottomNavigationBar() {
    final customColors = ref.watch(customColorsProvider);
    final isEnglish = ref.watch(isEnglishProvider);
    final selectedIndex = ref.watch(selectedIndexProvider);
    
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: (index) {
        ref.read(selectedIndexProvider.notifier).state = index;
        if (index != selectedIndex) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              switch (index) {
                case 1:
                  return const SellProductsScreen();
                case 2:
                  return const FinancialServicesScreen();
                default:
                  return const HomePage();
              }
            }),
          );
        }
      },
      selectedItemColor: customColors['primary'],
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.home),
          label: isEnglish ? 'Home' : 'Kwathu',
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.sell),
          label: isEnglish ? 'Sell' : 'Gulitsani',
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.account_balance_wallet),
          label: isEnglish ? 'Finance' : 'Ndalama',
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.person),
          label: isEnglish ? 'Profile' : 'Mbiri Yanu',
        ),
      ],
    );
  }

  Widget _buildFloatingActionButton() {
    final customColors = ref.watch(customColorsProvider);
    final isEnglish = ref.watch(isEnglishProvider);
    
    return FloatingActionButton(
      backgroundColor: customColors['accent'],
      child: const Icon(Icons.chat_bubble, color: Colors.white),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AIAssistantScreen(
              isEnglish: isEnglish,
              customColors: customColors,
            ),
          ),
        );
      },
    );
  }
}