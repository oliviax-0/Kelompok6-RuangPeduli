import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ruangpeduliapp/auth_widgets.dart';
import 'package:ruangpeduliapp/verification_screen.dart';

class FillDataPantiScreen extends StatefulWidget {
  const FillDataPantiScreen({super.key});

  @override
  State<FillDataPantiScreen> createState() => _FillDataPantiScreenState();
}

class _FillDataPantiScreenState extends State<FillDataPantiScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  final _namaPantiController = TextEditingController();
  final _alamatPantiController = TextEditingController();
  final _usernameController = TextEditingController();
  final _namaPJController = TextEditingController();
  final _nomorPJController = TextEditingController();
  bool _agreeTnC = true;

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
    _namaPantiController.dispose();
    _alamatPantiController.dispose();
    _usernameController.dispose();
    _namaPJController.dispose();
    _nomorPJController.dispose();
    super.dispose();
  }

  void _onSelanjutnya() {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => VerificationScreen(
          role: 'Panti Sosial',
          email: '',
        ),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 350),
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

          // Wave — tinggi sedang ~75%
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: size.height * 0.75,
              width: size.width,
              child: CustomPaint(painter: _FillDataWavePainter()),
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

                    SizedBox(height: size.height * 0.18),

                    // Scrollable content
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 28),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),

                            // Title
                            const Text(
                              'Isi Data',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF1A1A1A),
                              ),
                            ),
                            const SizedBox(height: 28),

                            // Nama Panti
                            _SectionLabel('Nama Panti'),
                            const SizedBox(height: 8),
                            _RoundedField(
                              controller: _namaPantiController,
                              hint: 'Contoh: Panti Sayap Ibu Bintaro',
                            ),
                            const SizedBox(height: 20),

                            // Alamat Panti
                            _SectionLabel('Alamat Panti'),
                            const SizedBox(height: 8),
                            _RoundedField(
                              controller: _alamatPantiController,
                              hint: 'Contoh: Jalan Sudirman 123',
                            ),
                            const SizedBox(height: 20),

                            // Username
                            _SectionLabel('Username'),
                            const SizedBox(height: 8),
                            _RoundedField(
                              controller: _usernameController,
                              hint: 'Contoh: panti_sayapibu',
                            ),
                            const SizedBox(height: 8),

                            // Divider Penanggungjawab
                            Center(
                              child: Text(
                                'Penanggungjawab',
                                style: TextStyle(
                                    fontSize: 13, color: Colors.grey.shade500),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Nama Penanggungjawab
                            _SectionLabel('Nama Penanggungjawab'),
                            const SizedBox(height: 8),
                            _RoundedField(
                              controller: _namaPJController,
                              hint: 'Masukan Nama Lengkap',
                            ),
                            const SizedBox(height: 20),

                            // Nomor Penanggungjawab
                            _SectionLabel('Nomor Penanggungjawab/Panti'),
                            const SizedBox(height: 8),
                            _RoundedField(
                              controller: _nomorPJController,
                              hint: 'Masukan Nomor Telepon Aktif',
                              keyboardType: TextInputType.phone,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                            ),
                            const SizedBox(height: 24),

                            // Syarat dan Ketentuan
                            const Text(
                              'Syarat dan Ketentuan',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1A1A1A),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: Checkbox(
                                    value: _agreeTnC,
                                    onChanged: (val) =>
                                        setState(() => _agreeTnC = val ?? false),
                                    activeColor: const Color(0xFF2C2C2C),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4)),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: RichText(
                                    text: TextSpan(
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade600,
                                          height: 1.5),
                                      children: const [
                                        TextSpan(
                                            text:
                                                'Saya mengakui telah membaca dan menyetujui Syarat & Ketentuan dan Kebijakan Ruang Peduli. '),
                                        TextSpan(
                                          text: 'Baca selengkapnya.',
                                          style: TextStyle(
                                            color: Color(0xFFF43D5E),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 40),

                            // Selanjutnya button
                            Center(
                              child: SizedBox(
                                width: size.width * 0.55,
                                child: DarkButton(
                                  label: 'Sign Up',
                                  onTap: _onSelanjutnya,
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
}

// ── Reusable widgets ──

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: Color(0xFF1A1A1A),
      ),
    );
  }
}

class _RoundedField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final TextInputType keyboardType;
  final List<TextInputFormatter> inputFormatters;

  const _RoundedField({
    required this.controller,
    required this.hint,
    this.keyboardType = TextInputType.text,
    this.inputFormatters = const [],
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      style: const TextStyle(fontSize: 14, color: Color(0xFF1A1A1A)),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
        filled: true,
        fillColor: const Color(0xFFF0E8EA),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              const BorderSide(color: Color(0xFFF43D5E), width: 1.5),
        ),
      ),
    );
  }
}

// ── Wave painter ──
class _FillDataWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintBack = Paint()
      ..color = Colors.white.withOpacity(0.40)
      ..style = PaintingStyle.fill;

    final pathBack = Path()
      ..moveTo(0, size.height * 0.14)
      ..quadraticBezierTo(size.width * 0.20, size.height * 0.02,
          size.width * 0.50, size.height * 0.10)
      ..quadraticBezierTo(size.width * 0.80, size.height * 0.18,
          size.width, size.height * 0.07)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(pathBack, paintBack);

    final paintFront = Paint()
      ..color = const Color(0xFFFFF0F2)
      ..style = PaintingStyle.fill;

    final pathFront = Path()
      ..moveTo(0, size.height * 0.22)
      ..quadraticBezierTo(size.width * 0.22, size.height * 0.08,
          size.width * 0.50, size.height * 0.16)
      ..quadraticBezierTo(size.width * 0.78, size.height * 0.24,
          size.width, size.height * 0.13)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(pathFront, paintFront);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}