import 'package:flutter/material.dart';
import 'package:ruangpeduliapp/auth/auth_widgets.dart';
import 'package:ruangpeduliapp/data/data.dart';
import 'package:ruangpeduliapp/masyarakat/home_masyarakat_screen.dart';
import 'package:ruangpeduliapp/panti/home_panti_screen.dart';

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
  final _api = AuthApi();
  bool _loading = false;

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

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor:
            isError ? Colors.red.shade400 : const Color(0xFF2C2C2C),
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Future<void> _onLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showSnackBar('Email dan sandi wajib diisi', isError: true);
      return;
    }

    setState(() => _loading = true);

    try {
      final result = await _api.login(email, password);
      if (!mounted) return;

      print('✅ Login berhasil! Role: ${result.role}');

      // Navigate berdasarkan role dari backend
      final Widget home = result.role == 'panti'
          ? const HomePantiScreen()
          : const HomeMasyarakatScreen();

      Navigator.of(context).pushAndRemoveUntil(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => home,
          transitionsBuilder: (_, anim, __, child) =>
              FadeTransition(opacity: anim, child: child),
          transitionDuration: const Duration(milliseconds: 400),
        ),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      print('❌ Login error: $e');
      _showSnackBar('$e', isError: true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
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
                    const Padding(
                      padding: EdgeInsets.only(left: 16, top: 8),
                      child: AuthBackButton(),
                    ),

                    SizedBox(height: size.height * 0.38),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 12),

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

                          UnderlineField(
                            label: 'Email',
                            hint: 'Masukan Email',
                            controller: _emailController,
                          ),
                          const SizedBox(height: 24),

                          UnderlineField(
                            label: 'Sandi',
                            hint: 'Masukan Sandi',
                            obscure: true,
                            controller: _passwordController,
                          ),
                          const SizedBox(height: 40),

                          // Log In button
                          Center(
                            child: SizedBox(
                              width: size.width * 0.58,
                              child: GestureDetector(
                                onTap: _loading ? null : _onLogin,
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 100),
                                  height: 52,
                                  decoration: BoxDecoration(
                                    color: _loading
                                        ? Colors.grey.shade400
                                        : const Color(0xFF2C2C2C),
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: _loading
                                        ? []
                                        : [
                                            BoxShadow(
                                              color: Colors.black
                                                  .withOpacity(0.20),
                                              blurRadius: 8,
                                              offset: const Offset(0, 3),
                                            )
                                          ],
                                  ),
                                  child: Center(
                                    child: _loading
                                        ? const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Colors.white,
                                            ),
                                          )
                                        : const Text(
                                            'Log In',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 28),

                          // Google Login
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
                                  errorBuilder: (_, __, ___) => const Icon(
                                      Icons.g_mobiledata_rounded,
                                      size: 28),
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