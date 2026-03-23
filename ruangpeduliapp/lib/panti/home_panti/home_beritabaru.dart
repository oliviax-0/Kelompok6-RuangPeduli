import 'package:flutter/material.dart';

// ─── Constants ───────────────────────────────────────────────────────────────

const Color kPink = Color(0xFFF28C9F);

// ─── Screen ───────────────────────────────────────────────────────────────────

class BeritaBaruPanti extends StatefulWidget {
  const BeritaBaruPanti({super.key});

  @override
  State<BeritaBaruPanti> createState() => _BeritaBaruPantiState();
}

class _BeritaBaruPantiState extends State<BeritaBaruPanti> {
  final _judulController = TextEditingController();
  final _isiController = TextEditingController();
  final _penulisController = TextEditingController();

  @override
  void dispose() {
    _judulController.dispose();
    _isiController.dispose();
    _penulisController.dispose();
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
        automaticallyImplyLeading: false,
        titleSpacing: 20,
        title: const Text(
          'Postingan Baru',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1A1A1A),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Color(0xFF1A1A1A), size: 26),
            onPressed: () => Navigator.pop(context),
            padding: const EdgeInsets.only(right: 12),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Media Upload Area ─────────────────────────────────────────
            _buildMediaPlaceholder(),
            const SizedBox(height: 24),

            // ── Judul ─────────────────────────────────────────────────────
            _buildLabel('Judul'),
            const SizedBox(height: 8),
            _buildTextField(
              controller: _judulController,
              hint: 'Ketik Judul',
              maxLines: 1,
            ),
            const SizedBox(height: 18),

            // ── Isi Artikel ───────────────────────────────────────────────
            _buildLabel('Isi Artikel'),
            const SizedBox(height: 8),
            _buildTextField(
              controller: _isiController,
              hint: 'Ketik Isi Artikel',
              maxLines: 8,
            ),
            const SizedBox(height: 18),

            // ── Penulis ───────────────────────────────────────────────────
            _buildLabel('Penulis'),
            const SizedBox(height: 8),
            _buildTextField(
              controller: _penulisController,
              hint: 'Ketik Penulis',
              maxLines: 1,
            ),
            const SizedBox(height: 32),

            // ── Bagikan Button ────────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: handle post submission
                  Navigator.pop(context);
                },
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
                  'Bagikan',
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

  // ─── Media Placeholder ────────────────────────────────────────────────────

  Widget _buildMediaPlaceholder() {
    return GestureDetector(
      onTap: () {
        // TODO: open image picker
      },
      child: Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          color: const Color(0xFFE8E8E8),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Icon(
            Icons.add,
            size: 56,
            color: Color(0xFF1A1A1A),
          ),
        ),
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
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(fontSize: 14, color: Color(0xFF1A1A1A)),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFFAAAAAA), fontSize: 14),
        filled: true,
        fillColor: const Color(0xFFF2F2F2),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: kPink, width: 1.5),
        ),
      ),
    );
  }
}