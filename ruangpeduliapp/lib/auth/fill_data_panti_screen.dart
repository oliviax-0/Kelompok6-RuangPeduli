import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ruangpeduliapp/auth/auth_widgets.dart';
import 'package:ruangpeduliapp/data/data.dart';
import 'package:ruangpeduliapp/auth/verification_screen.dart';
import 'package:ruangpeduliapp/auth/success_screen.dart';

class FillDataPantiScreen extends StatefulWidget {
  final String email;
  final String password;
  final String? googleIdToken; // non-null → Google mode (skip OTP)

  const FillDataPantiScreen({
    super.key,
    required this.email,
    required this.password,
    this.googleIdToken,
  });

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
  final _nomorPantiController = TextEditingController();
  bool _agreeTnC = true;
  String? _namaPantiError;
  String? _alamatPantiError;
  String? _usernameError;
  String? _nomorPantiError;
  String? _tncError;
  String? _generalError;
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
    _namaPantiController.dispose();
    _alamatPantiController.dispose();
    _usernameController.dispose();
    _nomorPantiController.dispose();
    super.dispose();
  }

  void _onSelanjutnya() {
    final username = _usernameController.text.trim();
    final namaPantiErr = _namaPantiController.text.isEmpty ? 'Wajib diisi' : null;
    final alamatErr = _alamatPantiController.text.isEmpty ? 'Wajib diisi' : null;
    final usernameErr = username.isEmpty
        ? 'Wajib diisi'
        : (!RegExp(r'[a-zA-Z]').hasMatch(username) || !RegExp(r'\d').hasMatch(username))
            ? 'Username harus mengandung huruf dan angka'
            : null;
    final nomorErr = _nomorPantiController.text.isEmpty ? 'Wajib diisi' : null;
    final tncErr = !_agreeTnC ? 'Anda harus menyetujui S&K terlebih dahulu' : null;

    setState(() {
      _namaPantiError = namaPantiErr;
      _alamatPantiError = alamatErr;
      _usernameError = usernameErr;
      _nomorPantiError = nomorErr;
      _tncError = tncErr;
      _generalError = null;
    });

    if (namaPantiErr != null || alamatErr != null || usernameErr != null ||
        nomorErr != null || tncErr != null) return;

    setState(() => _loading = true);

    if (widget.googleIdToken != null) {
      // Google mode — register directly, no OTP
      _api.googleRegister(
        idToken: widget.googleIdToken!,
        role: 'panti',
        username: username,
        namaPanti: _namaPantiController.text.trim(),
        alamatPanti: _alamatPantiController.text.trim(),
        nomorPanti: _nomorPantiController.text.trim(),
      ).then((result) {
        if (!mounted) return;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => SuccessScreen(
            role: 'panti',
            userId: result['user_id'] as int?,
            pantiId: result['panti_id'] as int?,
          )),
          (route) => false,
        );
      }).catchError((e) {
        if (!mounted) return;
        setState(() => _generalError = '$e');
      }).whenComplete(() {
        if (mounted) setState(() => _loading = false);
      });
    } else {
      _api.startRegister(RegisterData(
        username: username,
        email: widget.email,
        password: widget.password,
        role: 'panti',
        namaPanti: _namaPantiController.text.trim(),
        alamatPanti: _alamatPantiController.text.trim(),
        nomorPanti: _nomorPantiController.text.trim(),
      )).then((pendingId) {
        if (!mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => VerificationScreen(
              pendingId: pendingId,
              email: widget.email,
              role: 'panti',
            ),
          ),
        );
      }).catchError((e) {
        if (!mounted) return;
        setState(() => _generalError = '$e');
      }).whenComplete(() {
        if (mounted) setState(() => _loading = false);
      });
    }
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
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Back button
                      const Padding(
                        padding: EdgeInsets.only(left: 16, top: 8),
                        child: AuthBackButton(),
                      ),

                      SizedBox(height: size.height * 0.18),

                      Padding(
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
                              errorText: _namaPantiError,
                              onChanged: (_) => setState(() => _namaPantiError = null),
                            ),
                            const SizedBox(height: 20),

                            // Alamat Panti
                            _SectionLabel('Alamat Panti'),
                            const SizedBox(height: 8),
                            _RoundedField(
                              controller: _alamatPantiController,
                              hint: 'Contoh: Jalan Sudirman 123',
                              errorText: _alamatPantiError,
                              onChanged: (_) => setState(() => _alamatPantiError = null),
                            ),
                            const SizedBox(height: 20),

                            // Username
                            _SectionLabel('Username'),
                            const SizedBox(height: 8),
                            _RoundedField(
                              controller: _usernameController,
                              hint: 'Contoh: panti_sayapibu1',
                              errorText: _usernameError,
                              onChanged: (_) => setState(() => _usernameError = null),
                            ),
                            const SizedBox(height: 20),

                            // Nomor Panti
                            const _SectionLabel('Nomor Panti'),
                            const SizedBox(height: 8),
                            _RoundedField(
                              controller: _nomorPantiController,
                              hint: 'Masukan Nomor Telepon Aktif',
                              keyboardType: TextInputType.phone,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              errorText: _nomorPantiError,
                              onChanged: (_) => setState(() => _nomorPantiError = null),
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
                                    onChanged: (val) => setState(
                                        () => _agreeTnC = val ?? false),
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
                            if (_tncError != null)
                              InlineMessage(message: _tncError),
                            const SizedBox(height: 24),

                            InlineMessage(message: _generalError),
                            if (_generalError != null) const SizedBox(height: 8),

                            // Selanjutnya button
                            Center(
                              child: SizedBox(
                                width: size.width * 0.55,
                                child: DarkButton(
                                  label: _loading ? 'Memproses...' : 'Sign Up',
                                  onTap: _loading ? () {} : _onSelanjutnya,
                                ),
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
  final String? errorText;
  final ValueChanged<String>? onChanged;

  const _RoundedField({
    required this.controller,
    required this.hint,
    this.keyboardType = TextInputType.text,
    this.inputFormatters = const [],
    this.errorText,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null && errorText!.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          onChanged: onChanged,
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
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: hasError
                  ? const BorderSide(color: Color(0xFFF43D5E), width: 1.5)
                  : BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFF43D5E), width: 1.5),
            ),
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.info_outline_rounded, size: 13, color: Color(0xFFF43D5E)),
              const SizedBox(width: 4),
              Text(
                errorText!,
                style: const TextStyle(fontSize: 12, color: Color(0xFFF43D5E)),
              ),
            ],
          ),
        ],
      ],
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
      ..quadraticBezierTo(
          size.width * 0.80, size.height * 0.18, size.width, size.height * 0.07)
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
      ..quadraticBezierTo(
          size.width * 0.78, size.height * 0.24, size.width, size.height * 0.13)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(pathFront, paintFront);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
