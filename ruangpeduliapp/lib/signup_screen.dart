import 'package:flutter/material.dart';
import 'package:ruangpeduliapp/auth_widgets.dart';
import 'package:ruangpeduliapp/fill_data_panti_screen.dart';
import 'package:ruangpeduliapp/fill_data_masyarakat_screen.dart';

class SignUpScreen extends StatefulWidget {
  final String role;
  const SignUpScreen({super.key, required this.role});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
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
    Future.delayed(const Duration(milliseconds: 80),
        () { if (mounted) _controller.forward(); });
  }

  @override
  void dispose() {
    _controller.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onSignUp() {
    if (widget.role == 'Panti Sosial') {
      Navigator.of(context).push(PageRouteBuilder(
        pageBuilder: (_, __, ___) => const FillDataPantiScreen(),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 350),
      ));
    } else {
      Navigator.of(context).push(PageRouteBuilder(
        pageBuilder: (_, __, ___) =>
            FillDataMasyarakatScreen(email: _emailController.text),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 350),
      ));
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

                          const Text('Sign Up',
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

                          Center(
                            child: SizedBox(
                              width: size.width * 0.58,
                              child: DarkButton(
                                  label: 'Selanjutnya', onTap: _onSignUp),
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