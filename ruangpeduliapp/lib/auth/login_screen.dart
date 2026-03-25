import 'package:flutter/material.dart';
import 'package:ruangpeduliapp/auth/auth_widgets.dart';
<<<<<<< HEAD
import 'package:ruangpeduliapp/data/data.dart';
import 'package:ruangpeduliapp/masyarakat/home_masyarakat_screen.dart';
import 'package:ruangpeduliapp/panti/home_panti_screen.dart';
=======
import 'package:ruangpeduliapp/auth/forgot_password_screen.dart';
import 'package:ruangpeduliapp/auth/fill_data_masyarakat_screen.dart';
import 'package:ruangpeduliapp/auth/fill_data_panti_screen.dart';
import 'package:ruangpeduliapp/data/data.dart';
import 'package:ruangpeduliapp/masyarakat/home/home_masyarakat_screen.dart';
import 'package:ruangpeduliapp/panti/home_panti/home_panti.dart';
>>>>>>> 1fafb9b0f0707a41060aad0efc7f798faaee26f8

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
<<<<<<< HEAD
=======
  bool _googleLoading = false;
  String? _emailError;
  String? _passwordError;
  String? _generalError;
>>>>>>> 1fafb9b0f0707a41060aad0efc7f798faaee26f8

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

<<<<<<< HEAD
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
=======
  Future<void> _onGoogleLogin() async {
    final backendRole = widget.role.toLowerCase().contains('panti') ? 'panti' : 'masyarakat';

    setState(() { _googleLoading = true; _generalError = null; });
    try {
      final idToken = await GoogleSignInService.signIn();
      if (idToken == null) return; // user cancelled

      final result = await _api.googleAuth(idToken, backendRole);

      if (!mounted) return;

      if (result['exists'] == true) {
        final role = result['role'] as String;
        final userId = result['user_id'] as int?;
        final pantiId = result['panti_id'] as int?;
        final Widget home = role == 'panti'
            ? HomePanti(userId: userId, pantiId: pantiId)
            : HomeMasyarakatScreen(userId: userId);
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => home),
          (route) => false,
        );
      } else {
        // Account doesn't exist → go to fill data with Google token
        final email = result['email'] as String? ?? '';
        if (backendRole == 'panti') {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => FillDataPantiScreen(
              email: email,
              password: '',
              googleIdToken: idToken,
            ),
          ));
        } else {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => FillDataMasyarakatScreen(
              email: email,
              password: '',
              googleIdToken: idToken,
            ),
          ));
        }
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _generalError = '$e');
    } finally {
      if (mounted) setState(() => _googleLoading = false);
    }
  }

  Future<void> _onLogin() async {
    final emailErr = _emailController.text.isEmpty ? 'Email wajib diisi' : null;
    final passErr = _passwordController.text.isEmpty ? 'Sandi wajib diisi' : null;
    setState(() {
      _emailError = emailErr;
      _passwordError = passErr;
      _generalError = null;
    });
    if (emailErr != null || passErr != null) return;
>>>>>>> 1fafb9b0f0707a41060aad0efc7f798faaee26f8

    setState(() => _loading = true);

    try {
<<<<<<< HEAD
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
=======
      final backendRole = widget.role.toLowerCase().contains('panti') ? 'panti' : 'masyarakat';
      final result = await _api.login(
        _emailController.text.trim(),
        _passwordController.text,
        backendRole,
      );

      if (!mounted) return;

      final role = result['role'] as String;
      final userId = result['user_id'] as int?;
      final pantiId = result['panti_id'] as int?;
      final Widget home = role == 'panti'
          ? HomePanti(userId: userId, pantiId: pantiId)
          : HomeMasyarakatScreen(userId: userId);

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => home),
>>>>>>> 1fafb9b0f0707a41060aad0efc7f798faaee26f8
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;
<<<<<<< HEAD
      print('❌ Login error: $e');
      _showSnackBar('$e', isError: true);
=======
      setState(() => _generalError = '$e');
>>>>>>> 1fafb9b0f0707a41060aad0efc7f798faaee26f8
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
<<<<<<< HEAD
=======
                    // Back button
>>>>>>> 1fafb9b0f0707a41060aad0efc7f798faaee26f8
                    const Padding(
                      padding: EdgeInsets.only(left: 16, top: 8),
                      child: AuthBackButton(),
                    ),

<<<<<<< HEAD
                    SizedBox(height: size.height * 0.38),

=======
                    // Spacer turun ke bawah wave
                    SizedBox(height: size.height * 0.38),

                    // Konten di area putih/cream
>>>>>>> 1fafb9b0f0707a41060aad0efc7f798faaee26f8
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 12),

<<<<<<< HEAD
=======
                          // Title
>>>>>>> 1fafb9b0f0707a41060aad0efc7f798faaee26f8
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

<<<<<<< HEAD
=======
                          // Email
>>>>>>> 1fafb9b0f0707a41060aad0efc7f798faaee26f8
                          UnderlineField(
                            label: 'Email',
                            hint: 'Masukan Email',
                            controller: _emailController,
<<<<<<< HEAD
                          ),
                          const SizedBox(height: 24),

=======
                            errorText: _emailError,
                            onChanged: (_) => setState(() => _emailError = null),
                          ),
                          const SizedBox(height: 24),

                          // Sandi
>>>>>>> 1fafb9b0f0707a41060aad0efc7f798faaee26f8
                          UnderlineField(
                            label: 'Sandi',
                            hint: 'Masukan Sandi',
                            obscure: true,
                            controller: _passwordController,
<<<<<<< HEAD
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
=======
                            errorText: _passwordError,
                            onChanged: (_) => setState(() => _passwordError = null),
                          ),
                          const SizedBox(height: 8),

                          // Lupa Sandi
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ForgotPasswordScreen(role: widget.role),
                                ),
                              ),
                              child: const Text(
                                'Lupa Sandi?',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFFF43D5E),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),

                          InlineMessage(message: _generalError),
                          if (_generalError != null) const SizedBox(height: 12),

                          // Log In button (centered)
                          Center(
                            child: SizedBox(
                              width: size.width * 0.58,
                              child: DarkButton(
                                label: _loading ? 'Memproses...' : 'Log In',
                                onTap: _loading ? () {} : _onLogin,
>>>>>>> 1fafb9b0f0707a41060aad0efc7f798faaee26f8
                              ),
                            ),
                          ),
                          const SizedBox(height: 28),

<<<<<<< HEAD
                          // Google Login
                          GestureDetector(
                            onTap: () {
                              // TODO: Google Sign-In
                            },
=======
                          // Google Login — tanpa background, logo asli + teks
                          GestureDetector(
                            onTap: (_loading || _googleLoading) ? null : _onGoogleLogin,
>>>>>>> 1fafb9b0f0707a41060aad0efc7f798faaee26f8
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/logo_google.png',
                                  width: 28,
                                  height: 28,
<<<<<<< HEAD
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
=======
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  _googleLoading ? 'Memproses...' : 'Log In dengan Google',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: _googleLoading ? Colors.grey : const Color(0xFF1A1A1A),
>>>>>>> 1fafb9b0f0707a41060aad0efc7f798faaee26f8
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
<<<<<<< HEAD
}
=======
}
>>>>>>> 1fafb9b0f0707a41060aad0efc7f798faaee26f8
