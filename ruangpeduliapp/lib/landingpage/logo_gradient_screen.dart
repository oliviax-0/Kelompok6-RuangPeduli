import 'package:flutter/material.dart';
import 'welcome_screen.dart';

class LogoGradientScreen extends StatefulWidget {
  const LogoGradientScreen({super.key});

  @override
  State<LogoGradientScreen> createState() => _LogoGradientScreenState();
}

class _LogoGradientScreenState extends State<LogoGradientScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _textFadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 3500),
      vsync: this,
    );

    _logoAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
      ),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.5, curve: Curves.easeInOut),
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(1.5, 0), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.4, 0.7, curve: Curves.easeOut),
          ),
        );

    _textFadeAnimation =
        TweenSequence<double>([
          TweenSequenceItem(
            tween: Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).chain(CurveTween(curve: Curves.easeIn)),
            weight: 30,
          ),
          TweenSequenceItem(tween: ConstantTween<double>(1.0), weight: 40),
          TweenSequenceItem(
            tween: Tween<double>(
              begin: 1.0,
              end: 0.0,
            ).chain(CurveTween(curve: Curves.easeOut)),
            weight: 30,
          ),
        ]).animate(
          CurvedAnimation(parent: _controller, curve: const Interval(0.4, 1.0)),
        );

    _controller.forward();

    // Navigate to welcome screen after animation
    Future.delayed(const Duration(milliseconds: 3800), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const WelcomeScreen(),
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
            // Logo centered
            Positioned(
              top: 21,
              left: -119,
              child: FadeTransition(
                opacity: _logoAnimation,
                child: ScaleTransition(
                  scale: _pulseAnimation,
                  child: Image.network(
                    'https://www.figma.com/api/mcp/asset/94130157-4996-49d2-96bd-66c005b79f70',
                    width: 678,
                    height: 847,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      // Fallback if image doesn't load
                      return Container(
                        width: 678,
                        height: 847,
                        color: Colors.transparent,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 200,
                                height: 200,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.favorite,
                                    size: 100,
                                    color: Color(0xFFF43D5E),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 30),
                              const Text(
                                'Ruang Peduli',
                                style: TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            // "Satu Ruang, Seribu Harapan" text that slides from right and fades
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 500),
                child: SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _textFadeAnimation,
                    child: const Text(
                      'Satu Ruang, Seribu Harapan',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        letterSpacing: 0.5,
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
