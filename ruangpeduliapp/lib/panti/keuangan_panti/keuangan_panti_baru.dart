import 'package:flutter/material.dart';

// ─── Constants ───────────────────────────────────────────────────────────────

const Color kPink = Color(0xFFF28C9F);
const Color kPinkLight = Color(0xFFFDE8EC);

// ─── Entry point for standalone testing ──────────────────────────────────────

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: KeuanganPantiBaru(),
  ));
}

// ═══════════════════════════════════════════════════════════════════════════════
// MAIN SCREEN
// ═══════════════════════════════════════════════════════════════════════════════

class KeuanganPantiBaru extends StatefulWidget {
  const KeuanganPantiBaru({super.key});

  @override
  State<KeuanganPantiBaru> createState() => _KeuanganPantiBaruState();
}

class _KeuanganPantiBaruState extends State<KeuanganPantiBaru>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: kPinkLight,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1A1A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Input Transaksi',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1A1A1A),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: _buildTabBar(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _TransaksiForm(isPemasukan: true),
          _TransaksiForm(isPemasukan: false),
        ],
      ),
    );
  }

  // ─── Custom Tab Bar ───────────────────────────────────────────────────────

  Widget _buildTabBar() {
    return AnimatedBuilder(
      animation: _tabController,
      builder: (context, _) {
        return Row(
          children: [
            _TabItem(
              label: 'Pemasukan',
              isSelected: _tabController.index == 0,
              onTap: () => _tabController.animateTo(0),
            ),
            _TabItem(
              label: 'Pengeluaran',
              isSelected: _tabController.index == 1,
              onTap: () => _tabController.animateTo(1),
            ),
          ],
        );
      },
    );
  }
}

class _TabItem extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabItem({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
            color: isSelected ? const Color(0xFF1A1A1A) : const Color(0xFFCC7080),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// TRANSAKSI FORM
// ═══════════════════════════════════════════════════════════════════════════════

class _TransaksiForm extends StatefulWidget {
  final bool isPemasukan;

  const _TransaksiForm({required this.isPemasukan});

  @override
  State<_TransaksiForm> createState() => _TransaksiFormState();
}

class _TransaksiFormState extends State<_TransaksiForm> {
  final _jumlahController = TextEditingController();
  final _catatanController = TextEditingController();
  String? _selectedJenis;

  List<String> get _jenisOptions => widget.isPemasukan
      ? ['Donasi', 'Penjualan', 'Hibah', 'Subsidi', 'Lainnya']
      : ['Bahan Pokok', 'Furnitur', 'Obat-obatan', 'Operasional', 'Lainnya'];

  String get _jenisLabel =>
      widget.isPemasukan ? 'Jenis Pemasukan' : 'Jenis Pengeluaran';

  String get _jumlahLabel =>
      widget.isPemasukan ? 'Jumlah Pemasukan' : 'Jumlah Pengeluaran';

  String get _jumlahHint =>
      widget.isPemasukan ? 'Ketik Jumlah Pemasukan' : 'Ketik Jumlah Pengeluaran';

  @override
  void dispose() {
    _jumlahController.dispose();
    _catatanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Jenis dropdown ────────────────────────────────────────────
          _buildLabel(_jenisLabel),
          const SizedBox(height: 8),
          _buildDropdown(
            hint: 'Pilih ${_jenisLabel}',
            value: _selectedJenis,
            items: _jenisOptions,
            onChanged: (v) => setState(() => _selectedJenis = v),
          ),
          const SizedBox(height: 20),

          // ── Jumlah with Rp prefix ─────────────────────────────────────
          _buildLabel(_jumlahLabel),
          const SizedBox(height: 8),
          _buildCurrencyField(),
          const SizedBox(height: 20),

          // ── Catatan ───────────────────────────────────────────────────
          _buildLabel('Catatan'),
          const SizedBox(height: 8),
          _buildMultilineField(),
          const SizedBox(height: 40),

          // ── Simpan button ─────────────────────────────────────────────
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
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
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
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

  // Currency field with "Rp" prefix separated by a divider
  Widget _buildCurrencyField() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          // Rp prefix
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: const Text(
              'Rp',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A1A),
              ),
            ),
          ),
          // Vertical divider
          Container(width: 1.5, height: 22, color: Colors.grey[350]),
          // Number input
          Expanded(
            child: TextField(
              controller: _jumlahController,
              keyboardType: TextInputType.number,
              style: const TextStyle(fontSize: 14, color: Color(0xFF1A1A1A)),
              decoration: InputDecoration(
                hintText: _jumlahHint,
                hintStyle: const TextStyle(color: Color(0xFFAAAAAA), fontSize: 14),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMultilineField() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        controller: _catatanController,
        maxLines: 4,
        style: const TextStyle(fontSize: 14, color: Color(0xFF1A1A1A)),
        decoration: const InputDecoration(
          hintText: 'Ketik Catatan',
          hintStyle: TextStyle(color: Color(0xFFAAAAAA), fontSize: 14),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(16),
        ),
      ),
    );
  }
}