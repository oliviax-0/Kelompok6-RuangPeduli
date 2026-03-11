import 'package:flutter/material.dart';
import 'logo_gradient_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _swipeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _logoAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _colorAnimation =
        ColorTween(
          begin: Colors.black,
          end: const Color(0xFFF43D5E), // Pink color
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.6, 0.6, curve: Curves.easeInOut),
          ),
        );

    _swipeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 1.0, curve: Curves.easeIn),
      ),
    );

    _controller.forward();

    // Navigate to next screen after animation
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const LogoGradientScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // White background
          Container(color: Colors.white),

          // Pink gradient background that swipes from bottom to top
          AnimatedBuilder(
            animation: _swipeAnimation,
            builder: (context, child) {
              return ClipRect(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  heightFactor: _swipeAnimation.value,
                  child: Container(
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
                  ),
                ),
              );
            },
          ),

          // Logo in center
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _logoAnimation,
                child: AnimatedBuilder(
                  animation: _colorAnimation,
                  builder: (context, child) {
                    return ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        _colorAnimation.value ?? Colors.black,
                        BlendMode.srcATop,
                      ),
                      child: Image.network(
                        'https://www.figma.com/api/mcp/asset/f2635f32-4804-4520-a634-5a73511be4c9',
                        width: 595,
                        height: 744,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              color:
                                  _colorAnimation.value ??
                                  const Color(0xFFF43D5E),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: const Center(
                              child: Text(
                                'RP',
                                style: TextStyle(
                                  fontSize: 80,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
