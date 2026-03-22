import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Panti App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFF28C9F)),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const EditProfilePanti(),
    );
  }
}

// ─── Constants ───────────────────────────────────────────────────────────────

const Color kPink = Color(0xFFF28C9F);

// ─── Edit Profile Page ───────────────────────────────────────────────────────

class EditProfilePanti extends StatefulWidget {
  const EditProfilePanti({super.key});

  @override
  State<EditProfilePanti> createState() => _EditProfilePantiState();
}

class _EditProfilePantiState extends State<EditProfilePanti> {
  final _namaController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _namaController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1A1A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Edit Profil',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1A1A1A),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Avatar ───────────────────────────────────────────────────
            _buildAvatarPicker(),
            const SizedBox(height: 32),

            // ── Form Fields ──────────────────────────────────────────────
            _buildLabel('Nama'),
            const SizedBox(height: 8),
            _buildTextField(
              controller: _namaController,
              hint: 'Nama Panti',
              inputType: TextInputType.name,
            ),
            const SizedBox(height: 18),

            _buildLabel('Username'),
            const SizedBox(height: 8),
            _buildTextField(
              controller: _usernameController,
              hint: '@usernamepanti',
            ),
            const SizedBox(height: 18),

            _buildLabel('Alamat Email'),
            const SizedBox(height: 8),
            _buildTextField(
              controller: _emailController,
              hint: 'namapanti@gmail.com',
              inputType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 18),

            _buildLabel('Nomor Telepon'),
            const SizedBox(height: 8),
            _buildTextField(
              controller: _phoneController,
              hint: '+62812-3456-7890',
              inputType: TextInputType.phone,
            ),
            const SizedBox(height: 18),

            _buildLabel('Kata Sandi'),
            const SizedBox(height: 8),
            _buildTextField(
              controller: _passwordController,
              hint: '**********',
              obscure: true,
            ),
            const SizedBox(height: 8),

            // Ganti kata sandi link
            Center(
              child: TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF555555),
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'Ganti kata sandi',
                  style: TextStyle(
                    fontSize: 13,
                    decoration: TextDecoration.underline,
                    decorationColor: Color(0xFF555555),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            // ── Save Button ──────────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPink,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Simpan',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Avatar Picker ────────────────────────────────────────────────────────

  Widget _buildAvatarPicker() {
    return Center(
      child: Stack(
        children: [
          // Avatar circle
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: const Color(0xFFE0E0E0),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person_rounded,
              size: 56,
              color: Color(0xFFBDBDBD),
            ),
          ),
          // Camera badge
          Positioned(
            bottom: 2,
            right: 2,
            child: GestureDetector(
              onTap: () {},
              child: Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  color: Color(0xFF1A1A1A),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.camera_alt_rounded,
                  size: 15,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Label ────────────────────────────────────────────────────────────────

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: Color(0xFF1A1A1A),
      ),
    );
  }

  // ─── Text Field ───────────────────────────────────────────────────────────

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType inputType = TextInputType.text,
    bool obscure = false,
  }) {
    return TextField(
      controller: controller,
      keyboardType: inputType,
      obscureText: obscure,
      style: const TextStyle(fontSize: 14, color: Color(0xFF1A1A1A)),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFFAAAAAA), fontSize: 14),
        filled: true,
        fillColor: const Color(0xFFF2F2F2),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: kPink, width: 1.5),
        ),
      ),
    );
  }
}