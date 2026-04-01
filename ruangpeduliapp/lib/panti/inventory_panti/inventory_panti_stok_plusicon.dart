import 'package:flutter/material.dart';

// ─── Constants ───────────────────────────────────────────────────────────────

const Color kPink = Color(0xFFF28C9F);
const Color kPinkLight = Color(0xFFFDE8EC);
const Color kGreen = Color(0xFF2DB34A);
const Color kRed = Color(0xFFE53935);

// ═══════════════════════════════════════════════════════════════════════════════
// MAIN FLOW — Opsi Dialog
// ═══════════════════════════════════════════════════════════════════════════════

/// Call this from inventaris_panti.dart when the + button in Stok is tapped
void showStokOpsiDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.35),
    builder: (_) => const _StokOpsiDialog(),
  );
}

class _StokOpsiDialog extends StatelessWidget {
  const _StokOpsiDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      backgroundColor: kPink,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Opsi lain',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: Color(0xFF1A1A1A),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close, color: Colors.white, size: 18),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Tambahkan Produk
            _OpsiTile(
              icon: Icons.add_box_outlined,
              label: 'Tambahkan Produk',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TambahProdukScreen()),
                );
              },
            ),
            const SizedBox(height: 10),
            // Lihat Laporan
            _OpsiTile(
              icon: Icons.description_outlined,
              label: 'Lihat Laporan',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LaporanStokScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _OpsiTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _OpsiTile({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Colors.white, size: 22),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// FLOW 1 — Tambahkan Produk
// ═══════════════════════════════════════════════════════════════════════════════

class TambahProdukScreen extends StatefulWidget {
  const TambahProdukScreen({super.key});

  @override
  State<TambahProdukScreen> createState() => _TambahProdukScreenState();
}

class _TambahProdukScreenState extends State<TambahProdukScreen> {
  final _namaController = TextEditingController();
  final _satuanController = TextEditingController();
  final _pemakaianController = TextEditingController();
  final _waktuTungguController = TextEditingController();

  String? _selectedKategori;
  String? _selectedSatuan;
  String? _selectedSatuanWaktu;

  final List<String> _kategoriOptions = [
    'Bahan Pokok', 'Minuman', 'Obat-obatan', 'Furnitur', 'Perlengkapan', 'Lainnya',
  ];
  final List<String> _satuanOptions = ['kg', 'liter', 'pcs', 'box', 'pack', 'lusin'];
  final List<String> _satuanWaktuOptions = ['Hari', 'Minggu', 'Bulan'];

  @override
  void dispose() {
    _namaController.dispose();
    _satuanController.dispose();
    _pemakaianController.dispose();
    _waktuTungguController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPinkLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF1A1A1A)),
            ),
            const SizedBox(width: 6),
            Icon(Icons.info_outline_rounded, size: 18, color: Colors.grey[400]),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Kategori Produk
            _buildLabel('Kategori Produk'),
            const SizedBox(height: 8),
            _buildDropdown(
              hint: 'Pilih Kategori Produk',
              value: _selectedKategori,
              items: _kategoriOptions,
              onChanged: (v) => setState(() => _selectedKategori = v),
            ),
            const SizedBox(height: 20),

            // Nama Produk
            _buildLabel('Nama Produk'),
            const SizedBox(height: 8),
            _buildTextField(controller: _namaController, hint: 'Ketik Nama Produk'),
            const SizedBox(height: 20),

            // Satuan
            _buildLabel('Satuan'),
            const SizedBox(height: 8),
            _buildDropdown(
              hint: 'Pilih satuan yang digunakan',
              value: _selectedSatuan,
              items: _satuanOptions,
              onChanged: (v) => setState(() => _selectedSatuan = v),
            ),
            const SizedBox(height: 20),

            // Pemakaian Harian Rata-Rata
            Row(
              children: [
                _buildLabel('Pemakaian Harian Rata-Rata'),
                const SizedBox(width: 6),
                Icon(Icons.info_outline_rounded, size: 16, color: Colors.grey[400]),
              ],
            ),
            const SizedBox(height: 8),
            _buildAITextField(controller: _pemakaianController, hint: 'Ketik atau gunakan Rekomendasi AI'),
            const SizedBox(height: 20),

            // Waktu Tunggu Produk
            Row(
              children: [
                _buildLabel('Waktu Tunggu Produk'),
                const SizedBox(width: 6),
                Icon(Icons.info_outline_rounded, size: 16, color: Colors.grey[400]),
              ],
            ),
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
            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPink,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text('Simpan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
  }

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
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFFAAAAAA), fontSize: 14),
        filled: true,
        fillColor: Colors.white.withOpacity(0.7),
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

  Widget _buildAITextField({required TextEditingController controller, required String hint}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFFAAAAAA), fontSize: 14),
        filled: true,
        fillColor: Colors.white.withOpacity(0.7),
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
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
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

// ═══════════════════════════════════════════════════════════════════════════════
// FLOW 2 & 3 — Laporan Stok
// ═══════════════════════════════════════════════════════════════════════════════

class _LaporanItem {
  final String kategori;
  final String subLabel;
  final String amount;
  final bool isMasuk;

  const _LaporanItem({
    required this.kategori,
    required this.subLabel,
    required this.amount,
    required this.isMasuk,
  });
}

final List<_LaporanItem> _laporanData = [
  _LaporanItem(kategori: 'Bahan Pokok', subLabel: 'Beras Merah', amount: '+5kg', isMasuk: true),
  _LaporanItem(kategori: 'Minuman', subLabel: 'Susu Kedelai', amount: '-3kg', isMasuk: false),
  _LaporanItem(kategori: 'Bahan Pokok', subLabel: 'Beras Merah', amount: '+5kg', isMasuk: true),
  _LaporanItem(kategori: 'Bahan Pokok', subLabel: 'Minyak Goreng', amount: '-3kg', isMasuk: false),
  _LaporanItem(kategori: 'Bahan Pokok', subLabel: 'Singkong', amount: '+5kg', isMasuk: true),
  _LaporanItem(kategori: 'Bahan Pokok', subLabel: 'Beras Merah', amount: '-3kg', isMasuk: false),
  _LaporanItem(kategori: 'Bahan Pokok', subLabel: 'Beras Merah', amount: '+5kg', isMasuk: true),
  _LaporanItem(kategori: 'Bahan Pokok', subLabel: 'Beras Merah', amount: '-3kg', isMasuk: false),
  _LaporanItem(kategori: 'Bahan Pokok', subLabel: 'Beras Merah', amount: '+5kg', isMasuk: true),
  _LaporanItem(kategori: 'Obat-obatan', subLabel: 'Obat Pilek', amount: '-3kg', isMasuk: false),
  _LaporanItem(kategori: 'Bahan Pokok', subLabel: 'Beras Merah', amount: '+5kg', isMasuk: true),
  _LaporanItem(kategori: 'Bahan Pokok', subLabel: 'Beras Merah', amount: '-3kg', isMasuk: false),
];

class LaporanStokScreen extends StatefulWidget {
  const LaporanStokScreen({super.key});

  @override
  State<LaporanStokScreen> createState() => _LaporanStokScreenState();
}

class _LaporanStokScreenState extends State<LaporanStokScreen> {
  String? _filterValue;
  final List<String> _filterOptions = ['Semua', 'Stok Masuk', 'Stok Keluar'];

  List<_LaporanItem> get _filtered {
    if (_filterValue == null || _filterValue == 'Semua') return _laporanData;
    if (_filterValue == 'Stok Masuk') return _laporanData.where((e) => e.isMasuk).toList();
    return _laporanData.where((e) => !e.isMasuk).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Stack(
        children: [
          // ── Fixed top section ──────────────────────────────────────────
          SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // AppBar area
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 8, 16, 0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1A1A)),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Row(
                        children: [
                          const Text(
                            'Laporan',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1A1A1A),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Icon(Icons.info_outline_rounded, size: 18, color: Colors.grey[400]),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Search bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2)),
                      ],
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search',
                        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                        prefixIcon: Icon(Icons.mic_none_rounded, color: Colors.grey[400], size: 20),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Draggable sheet ────────────────────────────────────────────
          DraggableScrollableSheet(
            initialChildSize: 0.72,
            minChildSize: 0.72,
            maxChildSize: 1.0,
            snap: true,
            snapSizes: const [0.72, 1.0],
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: kPink,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: Column(
                  children: [
                    // Drag handle
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 6),
                      child: Container(
                        width: 36,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),

                    // Filter row
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _filterValue ?? 'Semua',
                                isDense: true,
                                icon: const Icon(Icons.tune_rounded, size: 18, color: Color(0xFF1A1A1A)),
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1A1A1A),
                                ),
                                items: _filterOptions
                                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                                    .toList(),
                                onChanged: (v) => setState(() => _filterValue = v),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // List
                    Expanded(
                      child: ListView.separated(
                        controller: scrollController,
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 40),
                        itemCount: _filtered.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          return _LaporanTile(item: _filtered[index]);
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ─── Laporan Tile ─────────────────────────────────────────────────────────────

class _LaporanTile extends StatelessWidget {
  final _LaporanItem item;
  const _LaporanTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final color = item.isMasuk ? kGreen : kRed;
    final icon = item.isMasuk ? Icons.add : Icons.remove;
    final arrow = item.isMasuk ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(color: color.withOpacity(0.12), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 10),
          Container(width: 1.5, height: 36, color: Colors.grey[200]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.kategori,
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Color(0xFF1A1A1A)),
                ),
                const SizedBox(height: 2),
                Text(item.subLabel, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                item.amount,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Color(0xFF1A1A1A)),
              ),
              const SizedBox(height: 2),
              Icon(arrow, color: color, size: 16),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

/// Call this from stock detail screens to show the FAB selection menu
void showStokDetailFabMenu(BuildContext context) {
  showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.35),
    builder: (_) => const _StokDetailFabMenu(),
  );
}

class _StokDetailFabMenu extends StatelessWidget {
  const _StokDetailFabMenu();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      backgroundColor: kPink,
      insetPadding: const EdgeInsets.symmetric(horizontal: 60),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Tambahkan Produk option
            _FabMenuOption(
              icon: Icons.inventory_2_outlined,
              label: 'Tambahkan Produk',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TambahProdukScreen()),
                );
              },
            ),
            const SizedBox(height: 12),
            // Lihat Laporan option
            _FabMenuOption(
              icon: Icons.description_outlined,
              label: 'Lihat Laporan',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LaporanStokScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _FabMenuOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _FabMenuOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(icon, color: kPink, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_rounded, color: kPink, size: 20),
          ],
        ),
      ),
    );
  }
}

// WRAPPER — Stock Detail Screen with FAB
// ═══════════════════════════════════════════════════════════════════════════════

/// Wrap your stock detail screen content with this to add FAB functionality
class StockDetailWithFab extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const StockDetailWithFab({
    required this.title,
    required this.children,
    super.key,
  });

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
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1A1A1A),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
        child: Column(children: children),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showStokDetailFabMenu(context),
        backgroundColor: Colors.white,
        shape: const CircleBorder(),
        elevation: 4,
        child: const Icon(Icons.add, color: kPink, size: 28),
      ),
    );
  }
}