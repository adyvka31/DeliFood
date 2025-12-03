import 'package:ecommerce_mobile/features/onboarding/onboarding2.dart';
import 'package:flutter/material.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> with TickerProviderStateMixin {
  late PageController _pageController;
  int _currentPage = 0;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  final tealColor = const Color(0xff70B2B2);
  final darkGrey = const Color(0xff1a1a1a);
  final lightGrey = const Color(0xfff5f5f5);
  final errorRed = const Color(0xffef4444);

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage == 0) {
      if (_formKey.currentState!.validate()) {
        _pageController.animateToPage(
          1,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOutCubic,
        );
      }
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.animateToPage(
        _currentPage - 1,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Progress bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Row(
                children: [
                  // Back button (hidden on first page)
                  if (_currentPage > 0)
                    GestureDetector(
                      onTap: _previousPage,
                      child: Container(
                        child: Icon(
                          Icons.arrow_back,
                          size: 20,
                          color: darkGrey,
                        ),
                      ),
                    ),
                  const Spacer(),
                  // Progress indicator
                  Text(
                    '${_currentPage + 1}/2',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: tealColor,
                    ),
                  ),
                ],
              ),
            ),

            // Progress line
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: LinearProgressIndicator(
                  value: (_currentPage + 1) / 2,
                  minHeight: 3,
                  backgroundColor: lightGrey,
                  valueColor: AlwaysStoppedAnimation<Color>(tealColor),
                ),
              ),
            ),

            // PageView content
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                children: [_buildPage1(isMobile), _buildPage2(isMobile)],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage1(bool isMobile) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 24,
          vertical: isMobile ? 24 : 40,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Headline
              Text(
                'Free Delivery',
                style: TextStyle(
                  fontSize: isMobile ? 40 : 48,
                  fontWeight: FontWeight.w900,
                  color: darkGrey,
                  letterSpacing: -1,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 12),

              // Subheadline
              Text(
                'Reach your destination faster with our free delivery service',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  height: 1.6,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 48),

              // Image with subtle shadow
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: tealColor.withOpacity(0.1),
                      blurRadius: 24,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Image.asset(
                  "assets/images/onboarding1.png",
                  width: isMobile ? 280 : 350,
                  height: isMobile ? 280 : 350,
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 56),

              // Name input field
              SizedBox(
                width: isMobile ? double.infinity : 380,
                child: TextFormField(
                  controller: _nameController,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: darkGrey,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    hintText: "How can we call you?",
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                      fontWeight: FontWeight.w400,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.grey[200]!,
                        width: 1.5,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.grey[200]!,
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: tealColor, width: 2),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: errorRed, width: 2),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: errorRed, width: 2),
                    ),
                    filled: true,
                    fillColor: lightGrey,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 20,
                    ),
                    errorStyle: TextStyle(
                      color: errorRed,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Mohon isi nama Anda untuk melanjutkan!';
                    }
                    if (value.length < 2) {
                      return 'Nama minimal 2 karakter';
                    }
                    return null;
                  },
                ),
              ),

              const SizedBox(height: 32),

              // Next button
              SizedBox(
                width: isMobile ? double.infinity : 380,
                height: 56,
                child: ElevatedButton(
                  onPressed: _nextPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: tealColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Lanjutkan",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPage2(bool isMobile) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 24,
          vertical: isMobile ? 24 : 40,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Headline
            Text(
              "Welcome, ${_nameController.text}!",
              style: TextStyle(
                fontSize: isMobile ? 32 : 40,
                fontWeight: FontWeight.w900,
                color: darkGrey,
                letterSpacing: -1,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 12),

            // Subheadline
            Text(
              'Your journey to seamless shopping starts here',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.6,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 48),

            // Benefits list
            ...List.generate(3, (index) => _buildBenefitCard(isMobile, index)),

            const SizedBox(height: 48),

            // Call-to-action button
            SizedBox(
              width: isMobile ? double.infinity : 380,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to signup page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          Onboarding2(name: _nameController.text),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: tealColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Mulai Sekarang',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitCard(bool isMobile, int index) {
    final benefits = [
      {
        'icon': Icons.local_shipping_outlined,
        'title': 'Pengiriman Cepat',
        'desc': 'Terima pesanan dalam 24 jam',
      },
      {
        'icon': Icons.verified_outlined,
        'title': 'Produk Original',
        'desc': 'Semua produk dijamin autentik',
      },
      {
        'icon': Icons.headset_mic_outlined,
        'title': 'Customer Support',
        'desc': 'Tim support siap membantu 24/7',
      },
    ];

    final benefit = benefits[index];

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        decoration: BoxDecoration(
          color: lightGrey,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!, width: 1),
        ),
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: tealColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                benefit['icon'] as IconData,
                color: tealColor,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    benefit['title'] as String,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: darkGrey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    benefit['desc'] as String,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w400,
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
}
