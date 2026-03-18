import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ruangpeduliapp/auth_widgets.dart';
import 'package:ruangpeduliapp/success_screen.dart';

class VerificationScreen extends StatefulWidget {
  final String role;
  final String email;
  const VerificationScreen({super.key, required this.role, required this.email});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  final List<TextEditingController> _otpControllers =
      List.generate(5, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(5, (_) => FocusNode());

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
    for (var c in _otpControllers) { c.dispose(); }
    for (var f in _focusNodes) { f.dispose(); }
    super.dispose();
  }

  void _onVerify() {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => SuccessScreen(role: widget.role),
        transitionsBuilder: (_, anim, __, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOut)),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // Gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFFFA5B1),
                  Color(0xFFF47B8C),
                  Color(0xFFF43D5E),
                ],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
          ),

          // Wave sangat tinggi — hanya pojok kanan atas yang pink
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: size.height * 0.85,
              width: size.width,
              child: CustomPaint(painter: _VerifWavePainter()),
            ),
          ),

          // Konten
          SafeArea(
            child: FadeTransition(
              opacity: _fade,
              child: SlideTransition(
                position: _slide,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back button
                    const Padding(
                      padding: EdgeInsets.only(left: 16, top: 8),
                      child: AuthBackButton(),
                    ),

                    SizedBox(height: size.height * 0.28),

                    // Konten
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 28),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 12),

                            const Text(
                              'Verifikasi',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF1A1A1A),
                              ),
                            ),
                            const SizedBox(height: 16),

                            Text(
                              'Masukkan kode 5 digit yang sudah dikirimkan\npada email ${widget.email.isNotEmpty ? widget.email : "com."}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 40),

                            // 5 OTP boxes
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List.generate(5, (i) => _buildOtpBox(i)),
                            ),

                            const Spacer(),

                            // Verifikasi button
                            Center(
                              child: SizedBox(
                                width: size.width * 0.55,
                                child: DarkButton(
                                  label: 'Verifikasi',
                                  onTap: _onVerify,
                                ),
                              ),
                            ),
                            const SizedBox(height: 40),
                          ],
                        ),
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
  }

  Widget _buildOtpBox(int index) {
    return SizedBox(
      width: 58,
      height: 72,
      child: TextField(
        controller: _otpControllers[index],
        focusNode: _focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A1A)),
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: const Color(0xFFF0E8EA),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                const BorderSide(color: Color(0xFFF43D5E), width: 1.5),
          ),
        ),
        onChanged: (val) {
          if (val.isNotEmpty && index < 4) {
            _focusNodes[index + 1].requestFocus();
          } else if (val.isEmpty && index > 0) {
            _focusNodes[index - 1].requestFocus();
          }
        },
      ),
    );
  }
}

class _VerifWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintBack = Paint()
      ..color = Colors.white.withOpacity(0.40)
      ..style = PaintingStyle.fill;

    final pathBack = Path()
      ..moveTo(0, size.height * 0.10)
      ..quadraticBezierTo(
          size.width * 0.20, size.height * 0.01,
          size.width * 0.50, size.height * 0.07)
      ..quadraticBezierTo(
          size.width * 0.80, size.height * 0.13,
          size.width, size.height * 0.05)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(pathBack, paintBack);

    final paintFront = Paint()
      ..color = const Color(0xFFFFF0F2)
      ..style = PaintingStyle.fill;

    final pathFront = Path()
      ..moveTo(0, size.height * 0.17)
      ..quadraticBezierTo(
          size.width * 0.22, size.height * 0.06,
          size.width * 0.50, size.height * 0.12)
      ..quadraticBezierTo(
          size.width * 0.78, size.height * 0.18,
          size.width, size.height * 0.10)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(pathFront, paintFront);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}