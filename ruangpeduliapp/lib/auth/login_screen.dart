import 'package:flutter/material.dart';
import 'package:ruangpeduliapp/auth/auth_widgets.dart';

class LoginScreen extends StatefulWidget {
  final String role;
  const LoginScreen({super.key, required this.role});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    Future.delayed(const Duration(milliseconds: 80), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin() {
    // TODO: Implement real login (call backend, then navigate to home screen)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Login belum diimplementasikan')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: AuthBackground(
        child: SafeArea(
          child: FadeTransition(
            opacity: _fade,
            child: SlideTransition(
              position: _slide,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back button
                    const Padding(
                      padding: EdgeInsets.only(left: 16, top: 8),
                      child: AuthBackButton(),
                    ),

                    // Spacer turun ke bawah wave
                    SizedBox(height: size.height * 0.38),

                    // Konten di area putih/cream
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 12),

                          // Title
                          const Text('Log In',
                              style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF1A1A1A))),
                          const SizedBox(height: 4),
                          Text(widget.role,
                              style: const TextStyle(
                                  fontSize: 13, color: Colors.teal)),
                          const SizedBox(height: 32),

                          // Email
                          UnderlineField(
                            label: 'Email',
                            hint: 'Masukan Email',
                            controller: _emailController,
                          ),
                          const SizedBox(height: 24),

                          // Sandi
                          UnderlineField(
                            label: 'Sandi',
                            hint: 'Masukan Sandi',
                            obscure: true,
                            controller: _passwordController,
                          ),
                          const SizedBox(height: 40),

                          // Log In button (centered)
                          Center(
                            child: SizedBox(
                              width: size.width * 0.58,
                              child:
                                  DarkButton(label: 'Log In', onTap: _onLogin),
                            ),
                          ),
                          const SizedBox(height: 28),

                          // Google Login — tanpa background, logo asli + teks
                          GestureDetector(
                            onTap: () {
                              // TODO: Google Sign-In
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/logo_google.png',
                                  width: 28,
                                  height: 28,
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  'Log In dengan Google',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF1A1A1A),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
