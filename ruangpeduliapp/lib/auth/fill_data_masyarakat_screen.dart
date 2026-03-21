import 'package:flutter/material.dart';
import 'package:ruangpeduliapp/auth/auth_widgets.dart';
import 'package:ruangpeduliapp/data/data.dart';
import 'package:ruangpeduliapp/auth/verification_screen.dart';

class FillDataMasyarakatScreen extends StatefulWidget {
  final String email;
  final String password; // <-- tambah

  const FillDataMasyarakatScreen({
    super.key,
    required this.email,
    required this.password, // <-- tambah
  });

  @override
  State<FillDataMasyarakatScreen> createState() =>
      _FillDataMasyarakatScreenState();
}

class _FillDataMasyarakatScreenState extends State<FillDataMasyarakatScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  final _namaPenggunaController = TextEditingController();
  final _alamatController = TextEditingController();
  final _usernameController = TextEditingController();
  bool _agreeTnC = true;

  final _api = AuthApi(); // <-- tambah
  bool _loading = false; // <-- tambah

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
    _namaPenggunaController.dispose();
    _alamatController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  void _onSelanjutnya() {
    print("=== TOMBOL DITEKAN ==="); // Debug 1

    if (!_agreeTnC) {
      print("❌ S&K belum dicentang");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Anda harus menyetujui S&K terlebih dahulu')),
      );
      return;
    }
    print("✓ S&K sudah dicentang");

    if (_namaPenggunaController.text.isEmpty ||
        _alamatController.text.isEmpty ||
        _usernameController.text.isEmpty) {
      print("❌ Ada field kosong:");
      print("  - Nama: ${_namaPenggunaController.text}");
      print("  - Alamat: ${_alamatController.text}");
      print("  - Username: ${_usernameController.text}");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua field wajib diisi')),
      );
      return;
    }
    print("✓ Semua field terisi");

    final data = RegisterData(
      username: _usernameController.text.trim(),
      email: widget.email,
      password: widget.password,
      role: 'masyarakat',
      namaPengguna: _namaPenggunaController.text.trim(),
      alamat: _alamatController.text.trim(),
    );

    print("=== MULAI REGISTER ==="); // Debug 2
    print("Email: ${data.email}");
    print("Username: ${data.username}");

    setState(() => _loading = true);

    _api.startRegister(data).then((pendingId) {
      print("✓ REGISTER BERHASIL, pendingId: $pendingId"); // Debug 3
      if (!mounted) {
        print("❌ Widget tidak mounted, tidak bisa navigate");
        return;
      }
      print("✓ Widget mounted, navigasi ke VerificationScreen");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VerificationScreen(
            pendingId: pendingId,
            email: widget.email,
          ),
        ),
      );
    }).catchError((e) {
      print("❌ REGISTER GAGAL: $e"); // Debug 4
      print("Error type: ${e.runtimeType}");
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mendaftar: $e')),
      );
    }).whenComplete(() {
      print("=== REGISTER SELESAI ===");
      if (mounted) setState(() => _loading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // Gradient
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

          // Wave
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: size.height * 0.78,
              width: size.width,
              child: CustomPaint(painter: _MasyarakatWavePainter()),
            ),
          ),

          // Content
          SafeArea(
            child: FadeTransition(
              opacity: _fade,
              child: SlideTransition(
                position: _slide,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 16, top: 8),
                      child: AuthBackButton(),
                    ),
                    SizedBox(height: size.height * 0.16),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 28),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),

                            const Text('Isi Data',
                                style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF1A1A1A))),
                            const SizedBox(height: 28),

                            // Nama Pengguna
                            _FieldLabel('Nama Pengguna'),
                            const SizedBox(height: 8),
                            _RoundedInput(
                              controller: _namaPenggunaController,
                              hint: 'Contoh: Sienna Malik',
                            ),
                            const SizedBox(height: 20),

                            // Alamat
                            _FieldLabel('Alamat'),
                            const SizedBox(height: 8),
                            _RoundedInput(
                              controller: _alamatController,
                              hint: 'Contoh: Jalan Sudirman 123',
                            ),
                            const SizedBox(height: 20),

                            // Username
                            _FieldLabel('Username'),
                            const SizedBox(height: 8),
                            _RoundedInput(
                              controller: _usernameController,
                              hint: 'Contoh: sunshinebecomesyou14',
                            ),
                            const SizedBox(height: 28),

                            // Syarat dan Ketentuan
                            const Text('Syarat dan Ketentuan',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF1A1A1A))),
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
                            const SizedBox(height: 40),

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

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A1A)));
  }
}

class _RoundedInput extends StatelessWidget {
  final TextEditingController controller;
  final String hint;

  const _RoundedInput({required this.controller, required this.hint});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
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
          borderSide: const BorderSide(color: Color(0xFFF43D5E), width: 1.5),
        ),
      ),
    );
  }
}

class _MasyarakatWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintBack = Paint()
      ..color = Colors.white.withOpacity(0.40)
      ..style = PaintingStyle.fill;

    final pathBack = Path()
      ..moveTo(0, size.height * 0.12)
      ..quadraticBezierTo(size.width * 0.20, size.height * 0.01,
          size.width * 0.50, size.height * 0.08)
      ..quadraticBezierTo(
          size.width * 0.80, size.height * 0.15, size.width, size.height * 0.06)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(pathBack, paintBack);

    final paintFront = Paint()
      ..color = const Color(0xFFFFF0F2)
      ..style = PaintingStyle.fill;

    final pathFront = Path()
      ..moveTo(0, size.height * 0.20)
      ..quadraticBezierTo(size.width * 0.22, size.height * 0.07,
          size.width * 0.50, size.height * 0.14)
      ..quadraticBezierTo(
          size.width * 0.78, size.height * 0.21, size.width, size.height * 0.12)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(pathFront, paintFront);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
