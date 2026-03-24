import 'package:flutter/material.dart';

class EditProfilScreen extends StatefulWidget {
  const EditProfilScreen({super.key});

  @override
  State<EditProfilScreen> createState() => _EditProfilScreenState();
}

class _EditProfilScreenState extends State<EditProfilScreen> {
  final _namaDepanCtrl = TextEditingController(text: 'Sienna');
  final _namaBelakangCtrl = TextEditingController(text: 'Malik');
  final _usernameCtrl = TextEditingController(text: '@sunshinebecomesy0u');
  final _emailCtrl = TextEditingController(text: 'siennaamelie@gmail.com');
  final _teleponCtrl = TextEditingController(text: '+62812-3456-7890');
  final _jenisKelaminCtrl = TextEditingController(text: 'Perempuan');
  final _sandiCtrl = TextEditingController();

  @override
  void dispose() {
    _namaDepanCtrl.dispose();
    _namaBelakangCtrl.dispose();
    _usernameCtrl.dispose();
    _emailCtrl.dispose();
    _teleponCtrl.dispose();
    _jenisKelaminCtrl.dispose();
    _sandiCtrl.dispose();
    super.dispose();
  }

  void _showGantiSandi() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const _GantiSandiSheet(),
    );
  }

  void _onSimpan() {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Profil berhasil diperbarui'),
        backgroundColor: const Color(0xFFF47B8C),
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── App Bar ──
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(Icons.arrow_back_rounded,
                        size: 22, color: Color(0xFF1A1A1A)),
                  ),
                  const Expanded(
                    child: Text(
                      'Edit Profil',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1A1A)),
                    ),
                  ),
                  const SizedBox(width: 22),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Avatar ──
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: const Color(0xFFF43D5E), width: 2),
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                'assets/images/profile_photo.png',
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Icon(
                                    Icons.person_rounded,
                                    size: 44,
                                    color: Colors.grey.shade400),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 26,
                              height: 26,
                              decoration: const BoxDecoration(
                                color: Color(0xFFF47B8C),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.camera_alt_rounded,
                                  color: Colors.white, size: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),

                    // ── Fields ──
                    _EditField(label: 'Nama Depan', controller: _namaDepanCtrl),
                    _EditField(
                        label: 'Nama Belakang', controller: _namaBelakangCtrl),
                    _EditField(label: 'Username', controller: _usernameCtrl),
                    _EditField(
                        label: 'Alamat Email',
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress),
                    _EditField(
                        label: 'Nomor Telepon',
                        controller: _teleponCtrl,
                        keyboardType: TextInputType.phone),
                    _EditField(
                        label: 'Jenis Kelamin',
                        controller: _jenisKelaminCtrl),
                    _EditField(
                        label: 'Kata Sandi',
                        controller: _sandiCtrl,
                        obscure: true,
                        hint: '**********'),

                    // Ganti kata sandi link
                    GestureDetector(
                      onTap: _showGantiSandi,
                      child: const Center(
                        child: Text(
                          'Ganti kata sandi',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF1A1A1A),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // ── Simpan button ──
                    Center(
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF47B8C),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            elevation: 0,
                          ),
                          onPressed: _onSimpan,
                          child: const Text('Simpan',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Edit Field ──
class _EditField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool obscure;
  final String? hint;
  final TextInputType keyboardType;

  const _EditField({
    required this.label,
    required this.controller,
    this.obscure = false,
    this.hint,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1A1A1A))),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          style:
              const TextStyle(fontSize: 14, color: Color(0xFF1A1A1A)),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle:
                TextStyle(color: Colors.grey.shade400, fontSize: 14),
            filled: true,
            fillColor: const Color(0xFFF5F5F5),
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 14),
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
        ),
        const SizedBox(height: 14),
      ],
    );
  }
}

// ── Ganti Sandi Bottom Sheet ──
class _GantiSandiSheet extends StatefulWidget {
  const _GantiSandiSheet();

  @override
  State<_GantiSandiSheet> createState() => _GantiSandiSheetState();
}

class _GantiSandiSheetState extends State<_GantiSandiSheet> {
  final _lamaCtrl = TextEditingController();
  final _baruCtrl = TextEditingController();
  final _konfirmCtrl = TextEditingController();

  @override
  void dispose() {
    _lamaCtrl.dispose();
    _baruCtrl.dispose();
    _konfirmCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),

          _EditField(
              label: 'Kata Sandi Lama',
              controller: _lamaCtrl,
              obscure: true,
              hint: '**********'),
          _EditField(
              label: 'Kata Sandi Baru',
              controller: _baruCtrl,
              obscure: true,
              hint: '************'),
          _EditField(
              label: 'Konfirmasi Kata Sandi Baru',
              controller: _konfirmCtrl,
              obscure: true,
              hint: '***********'),
          const SizedBox(height: 8),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF47B8C),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                elevation: 0,
              ),
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Kata sandi berhasil diubah'),
                    backgroundColor: const Color(0xFFF47B8C),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                );
              },
              child: const Text('Ganti',
                  style: TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }
}