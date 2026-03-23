import 'package:flutter/material.dart';

// ─── Constants ───────────────────────────────────────────────────────────────

const Color kPink = Color(0xFFF28C9F);
const Color kPinkLight = Color(0xFFFDE8EC);
const Color kCardPink = Color(0xFFFAE8EC);
const Color kRed = Color(0xFFE53935);

// ═══════════════════════════════════════════════════════════════════════════════
// SHARED WIDGETS
// ═══════════════════════════════════════════════════════════════════════════════

Widget _buildLabel(String text) => Text(
      text,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF1A1A1A)),
    );

Widget _buildInputField({
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
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: kPink, width: 1.5),
      ),
    ),
  );
}

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

// ═══════════════════════════════════════════════════════════════════════════════
// FLOW 1 — DAFTAR PEGAWAI
// ═══════════════════════════════════════════════════════════════════════════════

class _PegawaiItem {
  final String nama;
  final String divisi;
  final String jabatan;
  const _PegawaiItem({required this.nama, required this.divisi, required this.jabatan});
}

final List<_PegawaiItem> _pegawaiData = List.generate(
  8,
  (_) => const _PegawaiItem(nama: 'Eko Sutrisno', divisi: 'Administrasi', jabatan: 'Staf'),
);

class DaftarPegawaiScreen extends StatefulWidget {
  const DaftarPegawaiScreen({super.key});

  @override
  State<DaftarPegawaiScreen> createState() => _DaftarPegawaiScreenState();
}

class _DaftarPegawaiScreenState extends State<DaftarPegawaiScreen> {
  String? _filterValue;
  final List<String> _filterOptions = ['Semua', 'Administrasi', 'Keuangan', 'Logistik'];

  List<_PegawaiItem> get _filtered {
    if (_filterValue == null || _filterValue == 'Semua') return _pegawaiData;
    return _pegawaiData.where((e) => e.divisi == _filterValue).toList();
  }

  void _showTambahPegawaiDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.35),
      builder: (_) => const _TambahPegawaiDialog(),
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
        title: const Text(
          'Pegawai',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF1A1A1A)),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search + Filter row
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Row(
              children: [
                Expanded(child: _buildSearchBar()),
                const SizedBox(width: 10),
                // Filter dropdown
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F2F2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _filterValue ?? 'Semua',
                      isDense: true,
                      icon: const Icon(Icons.tune_rounded, size: 18, color: Color(0xFF1A1A1A)),
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1A1A1A)),
                      items: _filterOptions.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                      onChanged: (v) => setState(() => _filterValue = v),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Jumlah: ${_filtered.length}',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1A1A1A)),
            ),
          ),
          const SizedBox(height: 10),

          // List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
              itemCount: _filtered.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, index) => _PegawaiCard(item: _filtered[index]),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showTambahPegawaiDialog,
        backgroundColor: Colors.white,
        elevation: 4,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Color(0xFFE5728A), size: 28),
      ),
    );
  }
}

class _PegawaiCard extends StatelessWidget {
  final _PegawaiItem item;
  const _PegawaiCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          barrierColor: Colors.black.withOpacity(0.35),
          builder: (_) => _EditPegawaiDialog(item: item),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: kCardPink,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _infoRow('Nama', item.nama),
            const SizedBox(height: 4),
            _infoRow('Divisi', item.divisi),
            const SizedBox(height: 4),
            _infoRow('Posisi/jabatan', item.jabatan),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      children: [
        SizedBox(
          width: 110,
          child: Text(label, style: const TextStyle(fontSize: 13, color: Color(0xFF555555))),
        ),
        Text(': ', style: const TextStyle(fontSize: 13, color: Color(0xFF555555))),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1A1A1A)),
          ),
        ),
      ],
    );
  }
}

// ─── Tambah Pegawai Dialog ────────────────────────────────────────────────────

class _TambahPegawaiDialog extends StatefulWidget {
  const _TambahPegawaiDialog();

  @override
  State<_TambahPegawaiDialog> createState() => _TambahPegawaiDialogState();
}

class _TambahPegawaiDialogState extends State<_TambahPegawaiDialog> {
  final _namaController = TextEditingController();
  final _divisiController = TextEditingController();
  final _jabatanController = TextEditingController();

  @override
  void dispose() {
    _namaController.dispose();
    _divisiController.dispose();
    _jabatanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel('Nama Lengkap'),
            const SizedBox(height: 8),
            _buildInputField(controller: _namaController, hint: 'Ketik Nama Staf'),
            const SizedBox(height: 14),

            _buildLabel('Divisi'),
            const SizedBox(height: 8),
            _buildInputField(controller: _divisiController, hint: 'Ketik Divisi'),
            const SizedBox(height: 14),

            _buildLabel('Jabatan'),
            const SizedBox(height: 8),
            _buildInputField(controller: _jabatanController, hint: 'Ketik Jabatan'),
            const SizedBox(height: 20),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF1A1A1A),
                      side: const BorderSide(color: Color(0xFFDDDDDD)),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    child: const Text('Batal', style: TextStyle(fontWeight: FontWeight.w600)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPink,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    child: const Text('Unggah', style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Edit Pegawai Dialog ──────────────────────────────────────────────────────

class _EditPegawaiDialog extends StatefulWidget {
  final _PegawaiItem item;
  const _EditPegawaiDialog({required this.item});

  @override
  State<_EditPegawaiDialog> createState() => _EditPegawaiDialogState();
}

class _EditPegawaiDialogState extends State<_EditPegawaiDialog> {
  late final TextEditingController _namaController;
  late final TextEditingController _divisiController;
  late final TextEditingController _jabatanController;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.item.nama);
    _divisiController = TextEditingController(text: widget.item.divisi);
    _jabatanController = TextEditingController(text: widget.item.jabatan);
  }

  @override
  void dispose() {
    _namaController.dispose();
    _divisiController.dispose();
    _jabatanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title with edit icon
            Row(
              children: const [
                Icon(Icons.edit_outlined, size: 20, color: Color(0xFF1A1A1A)),
                SizedBox(width: 8),
                Text(
                  'Edit Pegawai',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF1A1A1A)),
                ),
              ],
            ),
            const SizedBox(height: 18),

            _buildLabel('Nama Lengkap'),
            const SizedBox(height: 8),
            _buildInputField(controller: _namaController, hint: 'Nama Lengkap'),
            const SizedBox(height: 14),

            _buildLabel('Divisi'),
            const SizedBox(height: 8),
            _buildInputField(controller: _divisiController, hint: 'Divisi'),
            const SizedBox(height: 14),

            _buildLabel('Jabatan'),
            const SizedBox(height: 8),
            _buildInputField(controller: _jabatanController, hint: 'Jabatan'),
            const SizedBox(height: 20),

            // Buttons row: Batal | Simpan | Delete icon
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF1A1A1A),
                      side: const BorderSide(color: Color(0xFFDDDDDD)),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    child: const Text('Batal', style: TextStyle(fontWeight: FontWeight.w600)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPink,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    child: const Text('Simpan', style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ),
                const SizedBox(width: 10),
                // Delete button
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: kRed.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.delete_outline_rounded, color: kRed, size: 22),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// ═══════════════════════════════════════════════════════════════════════════════

class _PenghuniItem {
  final String nama;
  final String tahunLahir;
  final String jenisKelamin;
  const _PenghuniItem({required this.nama, required this.tahunLahir, required this.jenisKelamin});
}

final List<_PenghuniItem> _penghuniData = List.generate(
  16,
  (i) => _PenghuniItem(
    nama: 'Sari Melatika',
    tahunLahir: '2014',
    jenisKelamin: i % 3 == 0 ? 'Laki-laki' : 'Perempuan',
  ),
);

class DaftarPenghuniScreen extends StatefulWidget {
  const DaftarPenghuniScreen({super.key});

  @override
  State<DaftarPenghuniScreen> createState() => _DaftarPenghuniScreenState();
}

class _DaftarPenghuniScreenState extends State<DaftarPenghuniScreen> {
  String? _filterValue;
  final List<String> _filterOptions = ['Semua', 'Laki-laki', 'Perempuan'];

  List<_PenghuniItem> get _filtered {
    if (_filterValue == null || _filterValue == 'Semua') return _penghuniData;
    return _penghuniData.where((e) => e.jenisKelamin == _filterValue).toList();
  }

  void _showTambahPenghuniDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.35),
      builder: (_) => const _TambahPenghuniDialog(),
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
        title: const Text(
          'Penghuni',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF1A1A1A)),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search + Filter row
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Row(
              children: [
                Expanded(child: _buildSearchBar()),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F2F2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _filterValue ?? 'Semua',
                      isDense: true,
                      icon: const Icon(Icons.tune_rounded, size: 18, color: Color(0xFF1A1A1A)),
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1A1A1A)),
                      items: _filterOptions.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                      onChanged: (v) => setState(() => _filterValue = v),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Divider
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          const SizedBox(height: 10),

          // Count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Jumlah: ${_filtered.length}',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1A1A1A)),
            ),
          ),
          const SizedBox(height: 10),

          // List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
              itemCount: _filtered.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, index) => _PenghuniCard(item: _filtered[index]),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showTambahPenghuniDialog,
        backgroundColor: Colors.white,
        elevation: 4,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Color(0xFFE5728A), size: 28),
      ),
    );
  }
}

class _PenghuniCard extends StatelessWidget {
  final _PenghuniItem item;
  const _PenghuniCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          barrierColor: Colors.black.withOpacity(0.35),
          builder: (_) => _EditPenghuniDialog(item: item),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: kCardPink,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _infoRow('Nama', item.nama),
            const SizedBox(height: 4),
            _infoRow('Tahun Lahir', item.tahunLahir),
            const SizedBox(height: 4),
            _infoRow('Jenis Kelamin', item.jenisKelamin),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      children: [
        SizedBox(
          width: 110,
          child: Text(label, style: const TextStyle(fontSize: 13, color: Color(0xFF555555))),
        ),
        const Text(': ', style: TextStyle(fontSize: 13, color: Color(0xFF555555))),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1A1A1A)),
          ),
        ),
      ],
    );
  }
}

// ─── Edit Penghuni Dialog ─────────────────────────────────────────────────────

class _EditPenghuniDialog extends StatefulWidget {
  final _PenghuniItem item;
  const _EditPenghuniDialog({required this.item});

  @override
  State<_EditPenghuniDialog> createState() => _EditPenghuniDialogState();
}

class _EditPenghuniDialogState extends State<_EditPenghuniDialog> {
  late final TextEditingController _namaController;
  late final TextEditingController _tahunLahirController;
  late String? _jenisKelamin;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.item.nama);
    _tahunLahirController = TextEditingController(text: widget.item.tahunLahir);
    _jenisKelamin = widget.item.jenisKelamin;
  }

  @override
  void dispose() {
    _namaController.dispose();
    _tahunLahirController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title with edit icon
            Row(
              children: const [
                Icon(Icons.edit_outlined, size: 20, color: Color(0xFF1A1A1A)),
                SizedBox(width: 8),
                Text(
                  'Edit Penghuni',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF1A1A1A)),
                ),
              ],
            ),
            const SizedBox(height: 18),

            _buildLabel('Nama Lengkap'),
            const SizedBox(height: 8),
            _buildInputField(controller: _namaController, hint: 'Nama Lengkap'),
            const SizedBox(height: 14),

            _buildLabel('Tahun Lahir'),
            const SizedBox(height: 8),
            _buildInputField(
              controller: _tahunLahirController,
              hint: 'Tahun Lahir',
              inputType: TextInputType.number,
            ),
            const SizedBox(height: 14),

            _buildLabel('Jenis Kelamin'),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFF2F2F2),
                borderRadius: BorderRadius.circular(30),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: _jenisKelamin,
                  icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF1A1A1A)),
                  style: const TextStyle(fontSize: 14, color: Color(0xFF1A1A1A)),
                  items: ['Laki-laki', 'Perempuan']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) => setState(() => _jenisKelamin = v),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Buttons row: Batal | Simpan | Delete icon
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF1A1A1A),
                      side: const BorderSide(color: Color(0xFFDDDDDD)),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    child: const Text('Batal', style: TextStyle(fontWeight: FontWeight.w600)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPink,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    child: const Text('Simpan', style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: kRed.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.delete_outline_rounded, color: kRed, size: 22),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TambahPenghuniDialog extends StatefulWidget {
  const _TambahPenghuniDialog();

  @override
  State<_TambahPenghuniDialog> createState() => _TambahPenghuniDialogState();
}

class _TambahPenghuniDialogState extends State<_TambahPenghuniDialog> {
  final _namaController = TextEditingController();
  final _tahunLahirController = TextEditingController();
  String? _jenisKelamin;

  @override
  void dispose() {
    _namaController.dispose();
    _tahunLahirController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel('Nama Lengkap'),
            const SizedBox(height: 8),
            _buildInputField(controller: _namaController, hint: 'Ketik Nama Penghuni'),
            const SizedBox(height: 14),

            _buildLabel('Tahun Lahir'),
            const SizedBox(height: 8),
            _buildInputField(
              controller: _tahunLahirController,
              hint: 'Ketik Tahun Lahir',
              inputType: TextInputType.number,
            ),
            const SizedBox(height: 14),

            _buildLabel('Jenis Kelamin'),
            const SizedBox(height: 8),
            // Dropdown instead of text field
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFF2F2F2),
                borderRadius: BorderRadius.circular(30),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  hint: const Text(
                    'Ketik Jenis Kelamin',
                    style: TextStyle(color: Color(0xFFAAAAAA), fontSize: 14),
                  ),
                  value: _jenisKelamin,
                  icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF1A1A1A)),
                  style: const TextStyle(fontSize: 14, color: Color(0xFF1A1A1A)),
                  items: ['Laki-laki', 'Perempuan']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) => setState(() => _jenisKelamin = v),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF1A1A1A),
                      side: const BorderSide(color: Color(0xFFDDDDDD)),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    child: const Text('Batal', style: TextStyle(fontWeight: FontWeight.w600)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPink,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    child: const Text('Unggah', style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}