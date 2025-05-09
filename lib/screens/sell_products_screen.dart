import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SellProductsScreen extends StatefulWidget {
  const SellProductsScreen({super.key});

  @override
  State<SellProductsScreen> createState() => _SellProductsScreenState();
}

class _SellProductsScreenState extends State<SellProductsScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _formController;
  late AnimationController _submitController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _formSlideAnimation;
  late Animation<double> _submitScaleAnimation;
  late Animation<double> _submitPulseAnimation;

  final List<String> _selectedImages = [];
  bool _isLoading = false;
  bool _isSubmitting = false;

  // Form controllers for validation
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();
  final _descriptionController = TextEditingController();

  // Custom colors with shimmer effect
  final Map<String, Color> customColors = {
    'primary': const Color(0xFF2E7D32),
    'secondary': const Color(0xFF1565C0),
    'accent': const Color(0xFFFFB74D),
    'background': const Color(0xFFF5F5F5),
    'surface': Colors.white,
    'text': const Color(0xFF212121),
  };

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    // Main controller for header animations
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Form controller for staggered animations
    _formController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Submit button controller for pulse animation
    _submitController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _formSlideAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _formController, curve: Curves.easeInOut),
    );

    _submitScaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _submitController, curve: Curves.easeInOut),
    );

    _submitPulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(
        parent: _submitController,
        curve: Curves.easeInOut,
      ),
    );

    // Start animations
    _controller.forward();
    _formController.forward();
    _submitController.repeat(reverse: true);
  }

  Future<void> _selectImage() async {
    setState(() => _isLoading = true);
    
    // Simulate image selection delay
    await Future.delayed(const Duration(milliseconds: 800));
    
    setState(() {
      _selectedImages.add('https://via.placeholder.com/150');
      _isLoading = false;
    });

    // Animate form entrance after image selection
    _formController.reset();
    _formController.forward();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isSubmitting = true);
      
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      setState(() => _isSubmitting = false);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('Product submitted successfully!'),
              ],
            ),
            backgroundColor: customColors['primary'],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _formController.dispose();
    _submitController.dispose();
    _nameController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildAnimatedHeader(),
            _buildAnimatedBody(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: Hero(
        tag: 'back_button',
        child: Material(
          color: Colors.transparent,
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      title: Text(
        'Sell Products',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
              offset: const Offset(1, 1),
              blurRadius: 3,
              color: Colors.black.withOpacity(0.3),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedHeader() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          height: 200,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                customColors['primary']!,
                customColors['secondary']!,
              ],
            ),
          ),
          child: Stack(
            children: [
              // Animated background pattern
              ...List.generate(3, (index) {
                return Positioned(
                  right: -50 + (index * 30 * _fadeAnimation.value),
                  top: -50 + (index * 20 * _fadeAnimation.value),
                  child: Transform.rotate(
                    angle: -math.pi / 4 + (index * 0.2 * _fadeAnimation.value),
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1 - (index * 0.02)),
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                );
              }),
              // Animated content
              Center(
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.0, end: 1.0),
                          duration: const Duration(milliseconds: 1000),
                          builder: (context, value, child) {
                            return Transform.scale(
                              scale: value,
                              child: const Icon(
                                Icons.store,
                                size: 50,
                                color: Colors.white,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'List Your Products',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAnimatedBody() {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            margin: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildImageSection(),
                  const SizedBox(height: 24),
                  _buildAnimatedForm(),
                  const SizedBox(height: 24),
                  _buildAnimatedSubmitButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Product Images',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: customColors['text'],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 120,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              ..._selectedImages.asMap().entries.map((entry) {
                return AnimatedBuilder(
                  animation: _formController,
                  builder: (context, child) {
                    final delay = entry.key * 0.2;
                    final animation = Tween<double>(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                        parent: _formController,
                        curve: Interval(delay, delay + 0.5, curve: Curves.easeOut),
                      ),
                    );
                    return Transform.scale(
                      scale: animation.value,
                      child: _buildImagePreview(entry.value),
                    );
                  },
                );
              }),
              _buildAddImageButton(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImagePreview(String imageUrl) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          children: [
            Hero(
              tag: imageUrl,
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
            Positioned(
              right: 4,
              top: 4,
              child: InkWell(
                onTap: () {
                  setState(() {
                    _selectedImages.remove(imageUrl);
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, size: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddImageButton() {
    return AnimatedBuilder(
      animation: _formController,
      builder: (context, child) {
        return Transform.scale(
          scale: _formSlideAnimation.value,
          child: InkWell(
            onTap: _isLoading ? null : _selectImage,
            child: Container(
              width: 120,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_photo_alternate, size: 32),
                        SizedBox(height: 8),
                        Text('Add Image'),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedForm() {
    return AnimatedBuilder(
      animation: _formController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - _formSlideAnimation.value)),
          child: Opacity(
            opacity: _formSlideAnimation.value,
            child: Column(
              children: [
                _buildAnimatedTextField(
                  controller: _nameController,
                  label: 'Product Name',
                  hint: 'Enter product name',
                  icon: Icons.inventory,
                  delay: 0.0,
                ),
                const SizedBox(height: 16),
                _buildAnimatedTextField(
                  controller: _priceController,
                  label: 'Price',
                  hint: 'Enter price in K',
                  icon: Icons.attach_money,
                  keyboardType: TextInputType.number,
                  delay: 0.2,
                ),
                const SizedBox(height: 16),
                _buildAnimatedTextField(
                  controller: _quantityController,
                  label: 'Quantity',
                  hint: 'Enter quantity available',
                  icon: Icons.shopping_bag,
                  keyboardType: TextInputType.number,
                  delay: 0.4,
                ),
                const SizedBox(height: 16),
                _buildAnimatedTextField(
                  controller: _descriptionController,
                  label: 'Description',
                  hint: 'Enter product description',
                  icon: Icons.description,
                  maxLines: 3,
                  delay: 0.6,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    double delay = 0.0,
  }) {
    return AnimatedBuilder(
      animation: _formController,
      builder: (context, child) {
        final animation = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _formController,
            curve: Interval(delay, delay + 0.5, curve: Curves.easeOut),
          ),
        );

        return Transform.translate(
          offset: Offset(100 * (2 - animation.value), 0),
          child: Opacity(
            opacity: animation.value,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: customColors['text'],
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: controller,
                  keyboardType: keyboardType,
                  maxLines: maxLines,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter $label';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: hint,
                    prefixIcon: Icon(icon),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: customColors['primary']!),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.red),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedSubmitButton() {
    return AnimatedBuilder(
      animation: _submitController,
      builder: (context, child) {
        return Transform.scale(
          scale: _submitPulseAnimation.value * _submitScaleAnimation.value,
          child: Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: customColors['primary']!.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: _isSubmitting ? null : _submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: customColors['primary']!,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: _isSubmitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      'Submit Product',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }
}