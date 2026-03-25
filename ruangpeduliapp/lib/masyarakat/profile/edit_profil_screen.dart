import 'package:flutter/material.dart';
import 'package:ruangpeduliapp/data/profile_api.dart';
import 'package:ruangpeduliapp/data/data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditProfilScreen extends StatefulWidget {
  final SocietyProfileModel? profile;
  final int? userId;

  const EditProfilScreen({super.key, this.profile, this.userId});

  @override
  State<EditProfilScreen> createState() => _EditProfilScreenState();
}

class _EditProfilScreenState extends State<EditProfilScreen> {
  late final TextEditingController _namaDepanCtrl;
  late final TextEditingController _namaBelakangCtrl;
  late final TextEditingController _usernameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _teleponCtrl;
  late final TextEditingController _jenisKelaminCtrl;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final p = widget.profile;
    // Split nama_pengguna into first/last name
    final namaParts = (p?.namaPengguna ?? '').trim().split(' ');
    final namaDepan = namaParts.isNotEmpty ? namaParts.first : '';
    final namaBelakang = namaParts.length > 1 ? namaParts.sublist(1).join(' ') : '';

    _namaDepanCtrl = TextEditingController(text: namaDepan);
    _namaBelakangCtrl = TextEditingController(text: namaBelakang);
    _usernameCtrl = TextEditingController(text: p?.username ?? '');
    _emailCtrl = TextEditingController(text: p?.email ?? '');
    _teleponCtrl = TextEditingController(text: p?.nomorTelepon ?? '');
    _jenisKelaminCtrl = TextEditingController(text: p?.jenisKelamin ?? '');
  }

  @override
  void dispose() {
    _namaDepanCtrl.dispose();
    _namaBelakangCtrl.dispose();
    _usernameCtrl.dispose();
    _emailCtrl.dispose();
    _teleponCtrl.dispose();
    _jenisKelaminCtrl.dispose();
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
      builder: (_) => _GantiSandiSheet(userId: widget.userId),
    );
  }

  Future<void> _onSimpan() async {
    final profileId = widget.profile?.id;
    if (profileId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Profil tidak ditemukan'),
          backgroundColor: Colors.red.shade400,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    setState(() => _saving = true);
    try {
      final namaDepan = _namaDepanCtrl.text.trim();
      final namaBelakang = _namaBelakangCtrl.text.trim();
      final namaPengguna = namaBelakang.isNotEmpty
          ? '$namaDepan $namaBelakang'
          : namaDepan;

      final updated = await ProfileApi().updateMasyarakatProfile(
        profileId,
        namaPengguna: namaPengguna.isNotEmpty ? namaPengguna : null,
        alamat: widget.profile?.alamat,
        username: _usernameCtrl.text.trim().isNotEmpty ? _usernameCtrl.text.trim() : null,
        email: _emailCtrl.text.trim().isNotEmpty ? _emailCtrl.text.trim() : null,
        nomorTelepon: _teleponCtrl.text.trim(),
        jenisKelamin: _jenisKelaminCtrl.text.trim(),
      );

      if (!mounted) return;
      Navigator.of(context).pop(updated);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Profil berhasil diperbarui'),
          backgroundColor: const Color(0xFFF47B8C),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan: $e'),
          backgroundColor: Colors.red.shade400,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
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
                              color: Colors.grey.shade200,
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
                    _EditField(label: 'Nama Belakang', controller: _namaBelakangCtrl),
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
                        onPressed: _saving ? null : _onSimpan,
                        child: _saving
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 2),
                              )
                            : const Text('Simpan',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w600)),
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
          style: const TextStyle(fontSize: 14, color: Color(0xFF1A1A1A)),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            filled: true,
            fillColor: const Color(0xFFF5F5F5),
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
        ),
        const SizedBox(height: 14),
      ],
    );
  }
}

// ── Ganti Sandi Bottom Sheet ──
class _GantiSandiSheet extends StatefulWidget {
  final int? userId;
  const _GantiSandiSheet({this.userId});

  @override
  State<_GantiSandiSheet> createState() => _GantiSandiSheetState();
}

class _GantiSandiSheetState extends State<_GantiSandiSheet> {
  final _lamaCtrl = TextEditingController();
  final _baruCtrl = TextEditingController();
  final _konfirmCtrl = TextEditingController();
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _lamaCtrl.dispose();
    _baruCtrl.dispose();
    _konfirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _onGanti() async {
    if (_baruCtrl.text != _konfirmCtrl.text) {
      setState(() => _error = 'Konfirmasi kata sandi tidak cocok');
      return;
    }
    if (_baruCtrl.text.length < 8) {
      setState(() => _error = 'Kata sandi baru minimal 8 karakter');
      return;
    }
    setState(() { _saving = true; _error = null; });
    try {
      final uri = Uri.parse('${AppConfig.baseUrl}/change-password/');
      final res = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_id': widget.userId,
          'current_password': _lamaCtrl.text,
          'new_password': _baruCtrl.text,
        }),
      ).timeout(const Duration(seconds: 15));
      if (!mounted) return;
      if (res.statusCode == 200) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Kata sandi berhasil diubah'),
            backgroundColor: const Color(0xFFF47B8C),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      } else {
        final body = jsonDecode(res.body);
        setState(() => _error = body['error'] ?? 'Gagal mengubah kata sandi');
      }
    } catch (e) {
      if (mounted) setState(() => _error = 'Tidak bisa konek ke server');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
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

          if (_error != null) ...[
            Text(_error!,
                style: const TextStyle(color: Colors.red, fontSize: 13)),
            const SizedBox(height: 8),
          ],

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
              onPressed: _saving ? null : _onGanti,
              child: _saving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2),
                    )
                  : const Text('Ganti',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }
}
