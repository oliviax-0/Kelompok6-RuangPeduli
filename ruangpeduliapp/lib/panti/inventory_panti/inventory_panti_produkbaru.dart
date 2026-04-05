import 'package:flutter/material.dart';
import 'package:ruangpeduliapp/data/inventory_api.dart';

// ─── Constants ───────────────────────────────────────────────────────────────

const Color kPink = Color(0xFFF28C9F);

// ═══════════════════════════════════════════════════════════════════════════════
// TAMBAH PRODUK SCREEN
// ═══════════════════════════════════════════════════════════════════════════════

class TambahProdukScreen extends StatefulWidget {
  final int pantiId;
  final int userId;

  const TambahProdukScreen({
    super.key,
    required this.pantiId,
    required this.userId,
  });

  @override
  State<TambahProdukScreen> createState() => _TambahProdukScreenState();
}

class _TambahProdukScreenState extends State<TambahProdukScreen> {
  final _namaController       = TextEditingController();
  final _pemakaianController  = TextEditingController();
  final _waktuTungguController = TextEditingController();

  String? _selectedKategori;
  String? _selectedSatuan;
  String? _selectedSatuanWaktu;
  bool _saving      = false;
  bool _predictingAI = false;
  String? _aiReasoning;

  final List<String> _kategoriOptions = [
    'Makanan', 'Minuman', 'Obat-obatan', 'Bahan Pokok', 'Lainnya',
  ];
  final List<String> _satuanOptions = [
    'kg', 'liter', 'pcs', 'box', 'pack', 'butir', 'lusin',
  ];
  final List<String> _satuanWaktuOptions = ['Hari', 'Minggu', 'Bulan'];

  // Maps satuan waktu label → days multiplier
  static const _satuanToDays = {'Hari': 1, 'Minggu': 7, 'Bulan': 30};

  @override
  void dispose() {
    _namaController.dispose();
    _pemakaianController.dispose();
    _waktuTungguController.dispose();
    super.dispose();
  }

  // ── AI Prediction ──────────────────────────────────────────────────────────

  Future<void> _predictPhrr() async {
    final nama = _namaController.text.trim();
    final satuan = _selectedSatuan ?? 'pcs';
    if (nama.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Isi nama produk terlebih dahulu.')),
      );
      return;
    }
    setState(() { _predictingAI = true; _aiReasoning = null; });
    try {
      final result = await InventoryApi().predictPhrr(widget.pantiId, nama, satuan);
      if (!mounted) return;
      setState(() {
        _pemakaianController.text = result.dailyUsage.toString();
        _aiReasoning = result.reasoning;
        _predictingAI = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _predictingAI = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$e'), backgroundColor: Colors.red),
      );
    }
  }

  // ── Submit ─────────────────────────────────────────────────────────────────

  Future<void> _onTambahkan() async {
    final nama = _namaController.text.trim();
    if (_selectedKategori == null || nama.isEmpty || _selectedSatuan == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lengkapi kategori, nama produk, dan satuan.')),
      );
      return;
    }

    // Parse PHRR
    final double? dailyUsage = double.tryParse(_pemakaianController.text.trim());

    // Parse lead time in days
    int? leadTimeDays;
    final wtVal = int.tryParse(_waktuTungguController.text.trim());
    if (wtVal != null && _selectedSatuanWaktu != null) {
      leadTimeDays = wtVal * (_satuanToDays[_selectedSatuanWaktu!] ?? 1);
    }

    setState(() => _saving = true);
    try {
      final existing = await InventoryApi().fetchCategories(widget.pantiId);
      final duplicate = existing.any(
        (c) => c.name.toLowerCase() == _selectedKategori!.toLowerCase(),
      );

      if (!mounted) return;

      if (duplicate) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Kategori "$_selectedKategori" sudah ada.'),
            backgroundColor: Colors.orange.shade700,
          ),
        );
        return;
      }

      final category = await InventoryApi().addCategory(widget.userId, _selectedKategori!);
      await InventoryApi().addItem(
        widget.userId, category.id, nama, 0, _selectedSatuan!,
        dailyUsage: dailyUsage,
        leadTimeDays: leadTimeDays,
      );

      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  // ── Build ──────────────────────────────────────────────────────────────────

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
        title: const Text(
          'Tambahkan Produk',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF1A1A1A)),
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
                  _buildTextField(controller: _namaController, hint: 'Ketik Nama Produk'),
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

                  // ── Pemakaian Harian Rata-Rata (AI) ───────────────────
                  Row(children: [
                    _buildLabel('Pemakaian Harian Rata-Rata'),
                    const SizedBox(width: 6),
                    Tooltip(
                      message: 'AI memprediksi berdasarkan jenis produk & jumlah penghuni panti',
                      child: Icon(Icons.info_outline_rounded, size: 16, color: Colors.grey[400]),
                    ),
                  ]),
                  const SizedBox(height: 8),
                  _buildAIField(),
                  if (_aiReasoning != null) ...[
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: kPink.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.auto_awesome_rounded, size: 14, color: kPink),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              _aiReasoning!,
                              style: const TextStyle(fontSize: 12, color: Color(0xFF555555)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 18),

                  // ── Waktu Tunggu Produk ───────────────────────────────
                  Row(children: [
                    _buildLabel('Waktu Tunggu Produk'),
                    const SizedBox(width: 6),
                    Tooltip(
                      message: 'Berapa lama waktu dari pemesanan sampai produk tiba',
                      child: Icon(Icons.info_outline_rounded, size: 16, color: Colors.grey[400]),
                    ),
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

          // ── Tambahkan Button ──────────────────────────────────────────
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saving ? null : _onTambahkan,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPink,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: _saving
                      ? const SizedBox(
                          width: 20, height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Text('Tambahkan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── AI text field with tappable AI button ─────────────────────────────────

  Widget _buildAIField() {
    return TextField(
      controller: _pemakaianController,
      keyboardType: TextInputType.number,
      style: const TextStyle(fontSize: 14, color: Color(0xFF1A1A1A)),
      decoration: InputDecoration(
        hintText: 'Ketik angka atau tap ✨ untuk Rekomendasi AI',
        hintStyle: const TextStyle(color: Color(0xFFAAAAAA), fontSize: 13),
        filled: true,
        fillColor: const Color(0xFFF2F2F2),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 8),
          child: GestureDetector(
            onTap: _predictingAI ? null : _predictPhrr,
            child: Container(
              width: 32,
              height: 32,
              margin: const EdgeInsets.symmetric(vertical: 6),
              decoration: const BoxDecoration(color: kPink, shape: BoxShape.circle),
              child: _predictingAI
                  ? const Padding(
                      padding: EdgeInsets.all(8),
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 16),
            ),
          ),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: kPink, width: 1.5),
        ),
      ),
    );
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────

  Widget _buildLabel(String text) => Text(
        text,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF1A1A1A)),
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
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
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
      decoration: BoxDecoration(color: const Color(0xFFF2F2F2), borderRadius: BorderRadius.circular(30)),
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
