import 'package:flutter/material.dart';
import 'inventory_panti_produkbaru.dart';

// ─── Constants ───────────────────────────────────────────────────────────────

const Color kPink = Color(0xFFF28C9F);
const Color kPinkDark = Color(0xFFE5728A);
const Color kPinkLight = Color(0xFFFAE8EC);
const Color kRed = Color(0xFFE53935);

const List<double> _greyscaleMatrix = [
  0.2126, 0.7152, 0.0722, 0, 0,
  0.2126, 0.7152, 0.0722, 0, 0,
  0.2126, 0.7152, 0.0722, 0, 0,
  0,      0,      0,      1, 0,
];

// ═══════════════════════════════════════════════════════════════════════════════
// STOK MASUK MAIN SCREEN
// ═══════════════════════════════════════════════════════════════════════════════

class StokMasukScreen extends StatelessWidget {
  const StokMasukScreen({super.key});

  @override
  Widget build(BuildContext context) => const StokMasukDetailScreen();
}

// ─── Data Model ──────────────────────────────────────────────────────────────

class _KategoriItem {
  final String nama;
  final int jumlahJenis;
  final bool hasAlert;

  _KategoriItem({
    required this.nama,
    required this.jumlahJenis,
    this.hasAlert = false,
  });
}

// ═══════════════════════════════════════════════════════════════════════════════
// STOK MASUK DETAIL SCREEN
// ═══════════════════════════════════════════════════════════════════════════════

class StokMasukDetailScreen extends StatefulWidget {
  final String title;

  const StokMasukDetailScreen({
    super.key,
    this.title = 'Stok Masuk',
  });

  @override
  State<StokMasukDetailScreen> createState() => _StokMasukDetailScreenState();
}

class _StokMasukDetailScreenState extends State<StokMasukDetailScreen> {
  bool _isEditMode = false;

  final List<_KategoriItem> _items = [
    _KategoriItem(nama: 'Makanan', jumlahJenis: 6),
    _KategoriItem(nama: 'Minuman', jumlahJenis: 3),
    _KategoriItem(nama: 'Obat-Obatan', jumlahJenis: 7),
    _KategoriItem(nama: 'Bahan Pokok', jumlahJenis: 9, hasAlert: true),
  ];

  void _toggleEditMode() => setState(() => _isEditMode = !_isEditMode);

  void _confirmDelete(int index) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.35),
      builder: (_) => _ConfirmDeleteDialog(
        onHapus: () {
          setState(() => _items.removeAt(index));
          Navigator.pop(context);
        },
        onBatal: () => Navigator.pop(context),
      ),
    );
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
        title: Text(
          widget.title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1A1A1A),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: _buildSearchBar(),
          ),
          const SizedBox(height: 12),

          // Count label
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: RichText(
              text: TextSpan(
                text: 'Kategori: ',
                style: const TextStyle(fontSize: 14, color: Color(0xFF1A1A1A)),
                children: [
                  TextSpan(
                    text: '${_items.length}',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),

          // List - Fixed ColorFiltered blocking touches
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              itemCount: _items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                if (_isEditMode) {
                  return ColorFiltered(
                    colorFilter: const ColorFilter.matrix(_greyscaleMatrix),
                    child: _KategoriTile(
                      item: _items[index],
                      isEditMode: _isEditMode,
                      onDelete: () => _confirmDelete(index),
                      onTap: null,
                    ),
                  );
                }
                return _KategoriTile(
                  item: _items[index],
                  isEditMode: _isEditMode,
                  onDelete: () => _confirmDelete(index),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => StokMasukDetailKategoriScreen(kategori: _items[index]),
                    ),
                  ),
                );
              },
            ),
          ),

          // Tambahkan Kategori button (only visible when not in edit mode)
          if (!_isEditMode)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
              child: Center(
                child: ElevatedButton.icon(
                  onPressed: () => _showTambahKategoriDialog(),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text(
                    'Tambahkan Kategori',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPink,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                ),
              ),
            ),
        ],
      ),

      // Edit FAB
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleEditMode,
        backgroundColor: _isEditMode ? Colors.white : Colors.white,
        elevation: _isEditMode ? 2 : 4,
        shape: const CircleBorder(),
        child: Icon(
          Icons.edit_outlined,
          color: _isEditMode ? kPinkDark : kPink,
          size: 22,
        ),
      ),
    );
  }

  void _showTambahKategoriDialog() {
    showDialog(
      context: context,
      builder: (_) => _TambahKategoriDialog(
        onAdd: (nama) {
          setState(() => _items.add(_KategoriItem(nama: nama, jumlahJenis: 0)));
        },
      ),
    );
  }
}

// ─── Search Bar ───────────────────────────────────────────────────────────────

Widget _buildSearchBar() {
  return Container(
    height: 44,
    decoration: BoxDecoration(
      color: const Color(0xFFF2F2F2),
      borderRadius: BorderRadius.circular(30),
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
  );
}

// ─── Kategori Tile ────────────────────────────────────────────────────────────

class _KategoriTile extends StatelessWidget {
  final _KategoriItem item;
  final bool isEditMode;
  final VoidCallback? onTap;
  final VoidCallback onDelete;

  const _KategoriTile({
    required this.item,
    required this.isEditMode,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: isEditMode ? const Color(0xFFF5F5F5) : kPinkLight,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        item.nama,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      if (item.hasAlert) ...[
                        const SizedBox(width: 6),
                        Icon(
                          isEditMode ? Icons.info_rounded : Icons.error_rounded,
                          color: isEditMode ? Colors.grey[500] : kRed,
                          size: 18,
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${item.jumlahJenis} Jenis',
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            // Trailing: X in edit mode, chevron otherwise
            if (isEditMode)
              GestureDetector(
                onTap: onDelete,
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Icon(Icons.close, color: Colors.grey[600], size: 22),
                ),
              )
            else
              Icon(Icons.chevron_right_rounded, color: Colors.grey[400], size: 24),
          ],
        ),
      ),
    );
  }
}

// ─── Confirm Delete Dialog ────────────────────────────────────────────────────

class _ConfirmDeleteDialog extends StatelessWidget {
  final VoidCallback onHapus;
  final VoidCallback onBatal;

  const _ConfirmDeleteDialog({
    required this.onHapus,
    required this.onBatal,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 40),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Apakah Anda yakin ingin menghapus kategori tersebut?',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1A1A1A),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Ya (confirm delete)
                OutlinedButton(
                  onPressed: onHapus,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF1A1A1A),
                    side: const BorderSide(color: Color(0xFFDDDDDD)),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text('Ya', style: TextStyle(fontWeight: FontWeight.w600)),
                ),
                const SizedBox(width: 10),
                // Tidak (cancel)
                ElevatedButton(
                  onPressed: onBatal,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPink,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text('Tidak', style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Tambah Kategori Dialog ───────────────────────────────────────────────────

class _TambahKategoriDialog extends StatefulWidget {
  final Function(String) onAdd;
  const _TambahKategoriDialog({required this.onAdd});

  @override
  State<_TambahKategoriDialog> createState() => _TambahKategoriDialogState();
}

class _TambahKategoriDialogState extends State<_TambahKategoriDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 32),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Nama Kategori Produk',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF1A1A1A)),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _controller,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Ketik Nama Kategori',
                hintStyle: const TextStyle(color: Color(0xFFAAAAAA), fontSize: 14),
                filled: true,
                fillColor: const Color(0xFFF2F2F2),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: kPink, width: 1.5),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  if (_controller.text.trim().isNotEmpty) {
                    widget.onAdd(_controller.text.trim());
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPink,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 11),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text('Tambahkan', style: TextStyle(fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// DETAIL KATEGORI SCREEN
// ═══════════════════════════════════════════════════════════════════════════════

class StokMasukDetailKategoriScreen extends StatelessWidget {
  final _KategoriItem kategori;

  const StokMasukDetailKategoriScreen({super.key, required this.kategori});

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
            Text(
              kategori.nama,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF1A1A1A)),
            ),
            if (kategori.hasAlert) ...[
              const SizedBox(width: 6),
              const Icon(Icons.error_rounded, color: kRed, size: 20),
            ],
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: _buildSearchBar(),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Produk dalam kategori',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1A1A1A)),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: kPinkLight, borderRadius: BorderRadius.circular(16)),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(Icons.folder_open_rounded, size: 48, color: Colors.grey[400]),
                        const SizedBox(height: 8),
                        Text('Kategori: ${kategori.nama}', style: const TextStyle(fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const TambahProdukScreen()),
        ),
        backgroundColor: kPink,
        elevation: 4,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 22),
      ),
    );
  }
}