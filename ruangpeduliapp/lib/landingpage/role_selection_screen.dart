import 'package:flutter/material.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoAnimation;
  late Animation<double> _titleAnimation;
  late Animation<double> _button1Animation;
  late Animation<double> _button2Animation;
  late Animation<Offset> _slideAnimation;
  bool _isPantiHovered = false;
  bool _isMasyarakatHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );

    _logoAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      ),
    );

    _titleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.6, curve: Curves.easeOut),
      ),
    );

    _button1Animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 0.8, curve: Curves.elasticOut),
      ),
    );

    _button2Animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 0.9, curve: Curves.elasticOut),
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.2, 0.7, curve: Curves.easeOut),
          ),
        );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.0,
            colors: [
              Color(0xFFFFA5B1), // rgba(255,165,177,1)
              Color(0xFFF47B8C), // rgba(244,123,140,1)
              Color(0xFFF45C75), // rgba(244,92,117,1)
              Color(0xFFF43D5E), // rgba(244,61,94,1)
            ],
            stops: [0.0, 0.49038, 0.74519, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Logo and app name at the top
            Positioned(
              top: -140,
              left: -121,
              child: FadeTransition(
                opacity: _logoAnimation,
                child: Image.network(
                  'https://www.figma.com/api/mcp/asset/8d8528d5-cb23-40ad-a058-712e3bca707f',
                  width: 678,
                  height: 847,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 678,
                      height: 847,
                      color: Colors.transparent,
                    );
                  },
                ),
              ),
            ),

            // Bottom wave background
            Positioned(
              bottom: 0,
              left: -5,
              right: 0,
              child: Image.network(
                'https://www.figma.com/api/mcp/asset/a1116e40-d4e4-4f22-8e5e-e3a7881b6ed8',
                width: 446,
                height: 600,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 446,
                    height: 600,
                    color: Colors.transparent,
                  );
                },
              ),
            ),

            // Back button at top
            Positioned(
              left: 35,
              top: 74,
              child: FadeTransition(
                opacity: _logoAnimation,
                child: ScaleTransition(
                  scale: _logoAnimation,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2C2C2C),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // "Pilih peran Anda" text
            Positioned(
              left: 35,
              top: 648,
              child: SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _titleAnimation,
                  child: const Text(
                    'Pilih peran Anda',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),

            // Panti Sosial button
            Positioned(
              left: 35,
              right: 37,
              top: 743,
              child: ScaleTransition(
                scale: _button1Animation,
                child: MouseRegion(
                  onEnter: (_) => setState(() => _isPantiHovered = true),
                  onExit: (_) => setState(() => _isPantiHovered = false),
                  child: AnimatedScale(
                    scale: _isPantiHovered ? 1.03 : 1.0,
                    duration: const Duration(milliseconds: 200),
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Navigate to Panti Sosial flow
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Panti Sosial selected'),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2C2C2C),
                        foregroundColor: const Color(0xFFF5F5F5),
                        padding: const EdgeInsets.all(12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: _isPantiHovered ? 6 : 2,
                      ),
                      child: const Text(
                        'Panti Sosial',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Masyarakat button
            Positioned(
              left: 35,
              right: 37,
              top: 819,
              child: ScaleTransition(
                scale: _button2Animation,
                child: MouseRegion(
                  onEnter: (_) => setState(() => _isMasyarakatHovered = true),
                  onExit: (_) => setState(() => _isMasyarakatHovered = false),
                  child: AnimatedScale(
                    scale: _isMasyarakatHovered ? 1.03 : 1.0,
                    duration: const Duration(milliseconds: 200),
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Navigate to Masyarakat flow
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Masyarakat selected')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2C2C2C),
                        foregroundColor: const Color(0xFFF5F5F5),
                        padding: const EdgeInsets.all(12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: _isMasyarakatHovered ? 6 : 2,
                      ),
                      child: const Text(
                        'Masyarakat',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
