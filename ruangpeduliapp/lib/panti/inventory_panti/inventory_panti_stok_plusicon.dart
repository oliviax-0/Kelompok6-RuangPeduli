import 'package:flutter/material.dart';
import 'package:ruangpeduliapp/data/inventory_api.dart';
import 'inventory_panti_produkbaru.dart' show TambahProdukScreen;

// ─── Constants ───────────────────────────────────────────────────────────────

const Color kPink = Color(0xFFF28C9F);
const Color kPinkLight = Color(0xFFFDE8EC);
const Color kGreen = Color(0xFF2DB34A);
const Color kRed = Color(0xFFE53935);

// ═══════════════════════════════════════════════════════════════════════════════
// MAIN FLOW — Opsi Dialog
// ═══════════════════════════════════════════════════════════════════════════════

/// Call this from inventaris_panti.dart when the + button in Stok is tapped
void showStokOpsiDialog(BuildContext context, {int? pantiId, int? userId}) {
  showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.35),
    builder: (_) => _StokOpsiDialog(pantiId: pantiId, userId: userId),
  );
}

class _StokOpsiDialog extends StatelessWidget {
  final int? pantiId;
  final int? userId;
  const _StokOpsiDialog({this.pantiId, this.userId});

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
                if (pantiId != null && userId != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TambahProdukScreen(
                        pantiId: pantiId!,
                        userId: userId!,
                      ),
                    ),
                  );
                }
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
                  MaterialPageRoute(builder: (_) => LaporanStokScreen(pantiId: pantiId)),
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
// FLOW 2 & 3 — Laporan Stok
// ═══════════════════════════════════════════════════════════════════════════════

const List<LaporanItemModel> _dummyLaporan = [
  LaporanItemModel(categoryName: 'Bahan Pokok', productName: 'Beras Merah',    amount: 5,  unit: 'kg',    isMasuk: true),
  LaporanItemModel(categoryName: 'Minuman',     productName: 'Susu Kedelai',   amount: 3,  unit: 'liter', isMasuk: false),
  LaporanItemModel(categoryName: 'Bahan Pokok', productName: 'Minyak Goreng',  amount: 2,  unit: 'liter', isMasuk: true),
  LaporanItemModel(categoryName: 'Bahan Pokok', productName: 'Minyak Goreng',  amount: 1,  unit: 'liter', isMasuk: false),
  LaporanItemModel(categoryName: 'Obat-obatan', productName: 'Obat Pilek',     amount: 10, unit: 'pcs',   isMasuk: true),
  LaporanItemModel(categoryName: 'Bahan Pokok', productName: 'Singkong',       amount: 5,  unit: 'kg',    isMasuk: true),
  LaporanItemModel(categoryName: 'Minuman',     productName: 'Teh Kotak',      amount: 12, unit: 'pcs',   isMasuk: false),
  LaporanItemModel(categoryName: 'Perlengkapan',productName: 'Sabun Mandi',    amount: 6,  unit: 'pcs',   isMasuk: true),
  LaporanItemModel(categoryName: 'Bahan Pokok', productName: 'Gula Pasir',     amount: 3,  unit: 'kg',    isMasuk: false),
  LaporanItemModel(categoryName: 'Obat-obatan', productName: 'Vitamin C',      amount: 20, unit: 'pcs',   isMasuk: true),
  LaporanItemModel(categoryName: 'Perlengkapan',productName: 'Deterjen',       amount: 2,  unit: 'kg',    isMasuk: false),
  LaporanItemModel(categoryName: 'Bahan Pokok', productName: 'Tepung Terigu',  amount: 4,  unit: 'kg',    isMasuk: true),
];

class LaporanStokScreen extends StatefulWidget {
  final int? pantiId;
  const LaporanStokScreen({super.key, this.pantiId});

  @override
  State<LaporanStokScreen> createState() => _LaporanStokScreenState();
}

class _LaporanStokScreenState extends State<LaporanStokScreen> {
  String _filterValue = 'Semua';
  String _searchQuery = '';
  final List<String> _filterOptions = ['Semua', 'Stok Masuk', 'Stok Keluar'];
  final _searchController = TextEditingController();

  List<LaporanItemModel> _allData = _dummyLaporan;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchLaporan();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchLaporan() async {
    if (widget.pantiId == null) {
      if (mounted) setState(() => _loading = false);
      return;
    }
    if (mounted) setState(() { _loading = true; _error = null; });
    try {
      final data = await InventoryApi().fetchLaporan(widget.pantiId!);
      if (mounted) setState(() { _allData = data.isEmpty ? _dummyLaporan : data; _loading = false; });
    } catch (_) {
      if (mounted) setState(() { _allData = _dummyLaporan; _loading = false; });
    }
  }

  List<LaporanItemModel> get _filtered {
    var list = _allData;
    if (_filterValue == 'Stok Masuk') list = list.where((e) => e.isMasuk).toList();
    if (_filterValue == 'Stok Keluar') list = list.where((e) => !e.isMasuk).toList();
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list.where((e) =>
        e.categoryName.toLowerCase().contains(q) ||
        e.productName.toLowerCase().contains(q),
      ).toList();
    }
    return list;
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
                      controller: _searchController,
                      onChanged: (v) => setState(() => _searchQuery = v),
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
                                value: _filterValue,
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
                                onChanged: (v) => setState(() => _filterValue = v ?? 'Semua'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // List
                    Expanded(
                      child: _loading
                          ? const Center(child: CircularProgressIndicator(color: Colors.white))
                          : _error != null
                              ? Center(
                                  child: Text(
                                    _error!,
                                    style: const TextStyle(color: Colors.white),
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              : _filtered.isEmpty
                                  ? const Center(
                                      child: Text(
                                        'Tidak ada data laporan.',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    )
                                  : ListView.separated(
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
  final LaporanItemModel item;
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
                  item.categoryName,
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Color(0xFF1A1A1A)),
                ),
                const SizedBox(height: 2),
                Text(item.productName, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                item.formattedAmount,
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