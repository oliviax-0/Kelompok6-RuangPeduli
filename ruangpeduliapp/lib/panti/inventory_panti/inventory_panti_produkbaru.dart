import 'package:flutter/material.dart';
// import 'package:ruangpeduliapp/panti/inventory_panti/inventory_panti_stok.dart';
// ↑ Uncomment to use StokProduk model from stok file,
//   OR keep the model definition below if you prefer this file to be standalone.

// ─── Constants ───────────────────────────────────────────────────────────────

const Color kPink = Color(0xFFF28C9F);

// ─── StokProduk model (copy here if not importing from inventory_panti_stok) ─
// If you import StokProduk from inventory_panti_stok.dart, delete this class.

class StokProduk {
  final String nama;
  final double jumlah;
  final String satuan;
  final String phrr;
  final bool isLow;

  const StokProduk({
    required this.nama,
    required this.jumlah,
    required this.satuan,
    required this.phrr,
    this.isLow = false,
  });
}

// ═══════════════════════════════════════════════════════════════════════════════
// TAMBAH PRODUK SCREEN
// ═══════════════════════════════════════════════════════════════════════════════

class TambahProdukScreen extends StatefulWidget {
  /// Pre-fills the Kategori dropdown when navigating from a specific category.
  final String? kategoriNama;

  const TambahProdukScreen({super.key, this.kategoriNama});

  @override
  State<TambahProdukScreen> createState() => _TambahProdukScreenState();
}

class _TambahProdukScreenState extends State<TambahProdukScreen> {
  final _namaController = TextEditingController();
  final _pemakaianController = TextEditingController();
  final _waktuTungguController = TextEditingController();

  String? _selectedKategori;
  String? _selectedSatuan;
  String? _selectedSatuanWaktu;

  final List<String> _kategoriOptions = [
    'Makanan', 'Minuman', 'Obat-obatan', 'Bahan Pokok', 'Lainnya',
  ];
  final List<String> _satuanOptions = [
    'kg', 'liter', 'pcs', 'box', 'pack', 'butir', 'lusin',
  ];
  final List<String> _satuanWaktuOptions = ['Hari', 'Minggu', 'Bulan'];

  @override
  void initState() {
    super.initState();
    // Pre-select kategori if navigated from a specific category page
    if (widget.kategoriNama != null && _kategoriOptions.contains(widget.kategoriNama)) {
      _selectedKategori = widget.kategoriNama;
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _pemakaianController.dispose();
    _waktuTungguController.dispose();
    super.dispose();
  }

  void _onTambahkan() {
    final produk = StokProduk(
      nama: _namaController.text.isNotEmpty ? _namaController.text : 'Produk Baru',
      jumlah: 0,
      satuan: _selectedSatuan ?? 'pcs',
      phrr: _pemakaianController.text.isNotEmpty
          ? '${_pemakaianController.text} per hari'
          : '0 per hari',
    );
    // Returns the new product to the caller via pop result
    Navigator.pop(context, produk);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1A1A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            const Text(
              'Tambahkan Produk',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(width: 6),
            Icon(Icons.info_outline_rounded, size: 18, color: Colors.grey[400]),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Kategori Produk ───────────────────────────────────
                  _buildLabel('Kategori Produk'),
                  const SizedBox(height: 8),
                  _buildDropdown(
                    hint: 'Pilih Kategori Produk',
                    value: _selectedKategori,
                    items: _kategoriOptions,
                    onChanged: (v) => setState(() => _selectedKategori = v),
                  ),
                  const SizedBox(height: 18),

                  // ── Nama Produk ───────────────────────────────────────
                  _buildLabel('Nama Produk'),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: _namaController,
                    hint: 'Ketik Nama Produk',
                  ),
                  const SizedBox(height: 18),

                  // ── Satuan ────────────────────────────────────────────
                  _buildLabel('Satuan'),
                  const SizedBox(height: 8),
                  _buildDropdown(
                    hint: 'Pilih satuan yang digunakan',
                    value: _selectedSatuan,
                    items: _satuanOptions,
                    onChanged: (v) => setState(() => _selectedSatuan = v),
                  ),
                  const SizedBox(height: 18),

                  // ── Pemakaian Harian Rata-Rata ────────────────────────
                  Row(children: [
                    _buildLabel('Pemakaian Harian Rata-Rata'),
                    const SizedBox(width: 6),
                    Icon(Icons.info_outline_rounded, size: 16, color: Colors.grey[400]),
                  ]),
                  const SizedBox(height: 8),
                  _buildAITextField(
                    controller: _pemakaianController,
                    hint: 'Ketik atau gunakan Rekomendasi AI',
                  ),
                  const SizedBox(height: 18),

                  // ── Waktu Tunggu Produk ───────────────────────────────
                  Row(children: [
                    _buildLabel('Waktu Tunggu Produk'),
                    const SizedBox(width: 6),
                    Icon(Icons.info_outline_rounded, size: 16, color: Colors.grey[400]),
                  ]),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: _waktuTungguController,
                          hint: 'Ketik Angka',
                          inputType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildDropdown(
                          hint: 'Satuan Waktu',
                          value: _selectedSatuanWaktu,
                          items: _satuanWaktuOptions,
                          onChanged: (v) => setState(() => _selectedSatuanWaktu = v),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ── Tambahkan Button (pinned at bottom) ───────────────────────
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _onTambahkan,
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
                    'Tambahkan',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Helpers ─────────────────────────────────────────────────────────────

  Widget _buildLabel(String text) => Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: Color(0xFF1A1A1A),
        ),
      );

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType inputType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: inputType,
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

  Widget _buildAITextField({
    required TextEditingController controller,
    required String hint,
  }) {
    return TextField(
      controller: controller,
      style: const TextStyle(fontSize: 14, color: Color(0xFF1A1A1A)),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFFAAAAAA), fontSize: 14),
        filled: true,
        fillColor: const Color(0xFFF2F2F2),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Container(
            width: 32,
            height: 32,
            margin: const EdgeInsets.symmetric(vertical: 6),
            decoration: const BoxDecoration(color: kPink, shape: BoxShape.circle),
            child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 16),
          ),
        ),
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

  Widget _buildDropdown({
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(30),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: Text(hint, style: const TextStyle(color: Color(0xFFAAAAAA), fontSize: 14)),
          value: value,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF1A1A1A)),
          style: const TextStyle(fontSize: 14, color: Color(0xFF1A1A1A)),
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}