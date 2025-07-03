import 'package:flutter/material.dart';
import '../../providers/app_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'login_screen.dart'; // Navigate to Login after onboarding

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final customColors = ref.watch(customColorsProvider);
    final isEnglish = ref.watch(isEnglishProvider);

    final List<Map<String, dynamic>> onboardingPages = [
      {
        'image': Icons.agriculture,
        'title': isEnglish ? 'Empower Your Farm' : 'Mphamvu ku Famu Yanu',
        'description': isEnglish ? 'Access loans, market prices, and expert advice to boost your yield.' : 'Pezani ngongole, mitengo yamsika, ndi malangizo a akatswiri kuti muwonjezere zokolola zanu.',
        'color': customColors['primary'],
      },
      {
        'image': Icons.account_balance_wallet,
        'title': isEnglish ? 'Manage Your Finances' : 'Sinthani Ndalama Zanu',
        'description': isEnglish ? 'Track income and expenses, apply for loans, and manage savings effortlessly.' : 'Tsatirani ndalama zolowa ndi zotuluka, pemphani ngongole, ndipo sinthani ndalama zanu mosavuta.',
        'color': customColors['secondary'],
      },
      {
        'image': Icons.store,
        'title': isEnglish ? 'Connect to Markets' : 'Lumikizanani ndi Misika',
        'description': isEnglish ? 'Buy and sell produce directly, find transport, and check live prices.' : 'Gulani ndi kugulitsa zokolola mwachindunji, pezani mayendedwe, ndi kuwona mitengo yamakono.',
        'color': customColors['accent'],
      },
    ];

    return Scaffold(
      backgroundColor: customColors['background'],
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: onboardingPages.length,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemBuilder: (context, index) {
              final pageData = onboardingPages[index];
              return Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      pageData['image'] as IconData,
                      size: 150,
                      color: pageData['color'] as Color,
                    ),
                    const SizedBox(height: 40),
                    Text(
                      pageData['title'] as String,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: customColors['text'],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      pageData['description'] as String,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: customColors['subText'],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 50.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      onboardingPages.length,
                      (index) => _buildDot(index, customColors),
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_currentPage < onboardingPages.length - 1) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeIn,
                          );
                        } else {
                          // Last page, navigate to login
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => const LoginScreen()),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: customColors['primary'],
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        _currentPage == onboardingPages.length - 1
                            ? (isEnglish ? 'Get Started' : 'Yambani')
                            : (isEnglish ? 'Next' : 'Kenako'),
                        style: TextStyle(fontSize: 18, color: customColors['surface']),
                      ),
                    ),
                  ),
                  if (_currentPage < onboardingPages.length - 1)
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                        );
                      },
                      child: Text(
                        isEnglish ? 'Skip' : 'Dulani',
                        style: TextStyle(color: customColors['subText']),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index, Map<String, Color> customColors) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 10,
      width: _currentPage == index ? 24 : 10,
      decoration: BoxDecoration(
        color: _currentPage == index ? customColors['primary'] : Colors.grey.withOpacity(0.5),
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}