import 'package:flutter/material.dart';
import 'package:ruangpeduliapp/masyarakat/home_masyarakat_screen.dart';
import 'package:ruangpeduliapp/masyarakat/search_screen.dart';
import 'package:ruangpeduliapp/masyarakat/profile_screen.dart';

// ─────────────────────────────────────────────────────────────
//  RIWAYAT DONASI SCREEN
// ─────────────────────────────────────────────────────────────
class RiwayatDonasiScreen extends StatefulWidget {
  const RiwayatDonasiScreen({super.key});

  @override
  State<RiwayatDonasiScreen> createState() => _RiwayatDonasiScreenState();
}

class _RiwayatDonasiScreenState extends State<RiwayatDonasiScreen> {
  // ── Color palette dari Figma ──
  static const Color bgPink = Color(0xFFF1BFB4);
  static const Color cardPink = Color(0xFFF1BFB4);
  static const Color primaryPink = Color(0xFFF28695);
  static const Color navPink = Color(0xFFF47B8C);
  static const Color darkText = Color(0xFF1A1A1A);

  // ── Filter state ──
  DateTime? _filterDate; // null = tampil semua

  // ── 8 riwayat donasi dummy ──
  final List<Map<String, dynamic>> _allRiwayat = [
    {
      'nama': 'Griya Yatim Dhuafa',
      'tanggal': DateTime(2026, 12, 14),
      'tanggalLabel': '14 Desember 2026',
      'jenis': 'Sedekah',
      'nominal': 'Rp1.000.000',
      'image': 'assets/images/panti2.png',
    },
    {
      'nama': 'Yayasan Sayap Ibu',
      'tanggal': DateTime(2026, 11, 28),
      'tanggalLabel': '28 November 2026',
      'jenis': 'Sedekah',
      'nominal': 'Rp2.000.000',
      'image': 'assets/images/panti1.png',
    },
    {
      'nama': 'Panti Asuhan Kasih Sesama Umat',
      'tanggal': DateTime(2026, 10, 13),
      'tanggalLabel': '13 Oktober 2026',
      'jenis': 'Sedekah',
      'nominal': 'Rp740.000',
      'image': 'assets/images/panti4.png',
    },
    {
      'nama': 'Rumah Yatim Indonesia',
      'tanggal': DateTime(2026, 9, 5),
      'tanggalLabel': '5 September 2026',
      'jenis': 'Sedekah',
      'nominal': 'Rp500.000',
      'image': 'assets/images/panti5.png',
    },
    {
      'nama': 'Panti Asuhan Mekar Lestari',
      'tanggal': DateTime(2026, 8, 20),
      'tanggalLabel': '20 Agustus 2026',
      'jenis': 'Sedekah',
      'nominal': 'Rp1.500.000',
      'image': 'assets/images/panti3.png',
    },
    {
      'nama': 'Panti Asuhan Al-Ikhlas',
      'tanggal': DateTime(2026, 7, 3),
      'tanggalLabel': '3 Juli 2026',
      'jenis': 'Sedekah',
      'nominal': 'Rp300.000',
      'image': 'assets/images/panti6.png',
    },
    {
      'nama': 'Yayasan Peduli Anak',
      'tanggal': DateTime(2026, 5, 17),
      'tanggalLabel': '17 Mei 2026',
      'jenis': 'Sedekah',
      'nominal': 'Rp850.000',
      'image': 'assets/images/panti7.png',
    },
    {
      'nama': 'Panti Asuhan Bina Insani',
      'tanggal': DateTime(2026, 3, 9),
      'tanggalLabel': '9 Maret 2026',
      'jenis': 'Sedekah',
      'nominal': 'Rp450.000',
      'image': 'assets/images/panti8.png',
    },
  ];

  List<Map<String, dynamic>> get _filtered {
    if (_filterDate == null) return _allRiwayat;
    return _allRiwayat.where((r) {
      final d = r['tanggal'] as DateTime;
      return d.year == _filterDate!.year && d.month == _filterDate!.month;
    }).toList();
  }

  // ── Buka bottom sheet Filter ──
  void _showFilter() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _FilterSheet(
        initialDate: _filterDate,
        onSimpan: (date) {
          setState(() => _filterDate = date);
          Navigator.pop(context);
        },
      ),
    );
  }

  String _filterLabel() {
    if (_filterDate == null) return '';
    const bulan = [
      '', 'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return '${bulan[_filterDate!.month]} ${_filterDate!.year}';
  }

  void _onNavTap(int index) {
    if (index == 2) return; // already here
    if (index == 0) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeMasyarakatScreen()),
      );
    } else if (index == 1) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const SearchScreen()),
      );
    } else if (index == 3) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const ProfileScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = _filtered;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // ── Header pink ──
          Container(
            width: double.infinity,
            color: bgPink,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                child: const Text(
                  'Riwayat Donasi',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: darkText,
                  ),
                ),
              ),
            ),
          ),

          // ── Body ──
          Expanded(
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  // ── Filter row ──
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (_filterDate != null)
                          GestureDetector(
                            onTap: () => setState(() => _filterDate = null),
                            child: Container(
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: primaryPink.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    _filterLabel(),
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: darkText,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(Icons.close_rounded,
                                      size: 14, color: darkText),
                                ],
                              ),
                            ),
                          ),
                        GestureDetector(
                          onTap: _showFilter,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: const Color(0xFFDDDDDD)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.06),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Text('Filter',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: darkText)),
                                SizedBox(width: 6),
                                Icon(Icons.filter_list_rounded,
                                    size: 18, color: darkText),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // ── List ──
                  Expanded(
                    child: items.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.history_rounded,
                                    size: 60,
                                    color: Colors.grey.shade300),
                                const SizedBox(height: 12),
                                Text(
                                  'Tidak ada riwayat di bulan ini',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade400),
                                ),
                                const SizedBox(height: 8),
                                GestureDetector(
                                  onTap: () =>
                                      setState(() => _filterDate = null),
                                  child: const Text(
                                    'Lihat semua riwayat',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: primaryPink,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 4),
                            itemCount: items.length,
                            itemBuilder: (context, i) =>
                                _RiwayatCard(data: items[i]),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildNavBar(),
    );
  }

  Widget _buildNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: navPink,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                  icon: Icons.home_rounded,
                  selected: false,
                  onTap: () => _onNavTap(0)),
              _NavItem(
                  icon: Icons.search_rounded,
                  selected: false,
                  onTap: () => _onNavTap(1)),
              _NavItem(
                  icon: Icons.history_rounded,
                  selected: true,
                  onTap: () => _onNavTap(2)),
              _NavItem(
                  icon: Icons.person_rounded,
                  selected: false,
                  onTap: () => _onNavTap(3)),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  RIWAYAT CARD
// ─────────────────────────────────────────────────────────────
class _RiwayatCard extends StatelessWidget {
  final Map<String, dynamic> data;
  const _RiwayatCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF1BFB4),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Foto panti bulat
          ClipOval(
            child: Image.asset(
              data['image'] as String,
              width: 64,
              height: 64,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 64,
                height: 64,
                color: const Color(0xFFDDCDD0),
                child: Icon(Icons.image_rounded,
                    size: 28, color: Colors.grey.shade400),
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['nama'] as String,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  data['tanggalLabel'] as String,
                  style: const TextStyle(
                      fontSize: 12, color: Color(0xFF5A5A5A)),
                ),
                const SizedBox(height: 6),
                // Badge jenis
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF28695),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    data['jenis'] as String,
                    style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                ),
              ],
            ),
          ),

          // Nominal (kanan bawah)
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              data['nominal'] as String,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1A1A1A),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  FILTER BOTTOM SHEET
// ─────────────────────────────────────────────────────────────
class _FilterSheet extends StatefulWidget {
  final DateTime? initialDate;
  final void Function(DateTime?) onSimpan;

  const _FilterSheet({required this.initialDate, required this.onSimpan});

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  late DateTime _selectedDate;
  bool _showCalendar = false;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate ?? DateTime.now();
  }

  String _formatBulanTahun(DateTime d) {
    const bulan = [
      '', 'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return '${bulan[d.month]} ${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      duration: const Duration(milliseconds: 200),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
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

            const Text(
              'Waktu',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A1A)),
            ),
            const SizedBox(height: 16),

            // Input field bulan-tahun
            GestureDetector(
              onTap: () => setState(() => _showCalendar = !_showCalendar),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Color(0xFFCCCCCC), width: 1.2),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _formatBulanTahun(_selectedDate),
                        style: const TextStyle(
                            fontSize: 15, color: Color(0xFF1A1A1A)),
                      ),
                    ),
                    const Icon(Icons.calendar_month_outlined,
                        size: 22, color: Color(0xFF1A1A1A)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Kalender inline
            if (_showCalendar) ...[
              _InlineCalendar(
                selectedDate: _selectedDate,
                onDateSelected: (d) {
                  setState(() {
                    _selectedDate = d;
                    _showCalendar = false;
                  });
                },
              ),
              const SizedBox(height: 12),
            ],

            const SizedBox(height: 8),

            // Tombol Simpan
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF28695),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  elevation: 0,
                ),
                onPressed: () => widget.onSimpan(_selectedDate),
                child: const Text('Simpan',
                    style: TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  INLINE CALENDAR WIDGET
// ─────────────────────────────────────────────────────────────
class _InlineCalendar extends StatefulWidget {
  final DateTime selectedDate;
  final void Function(DateTime) onDateSelected;

  const _InlineCalendar({
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  State<_InlineCalendar> createState() => _InlineCalendarState();
}

class _InlineCalendarState extends State<_InlineCalendar> {
  late int _viewMonth;
  late int _viewYear;
  late int _selectedDay;

  final List<String> _monthNames = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];

  bool _showMonthPicker = false;
  bool _showYearPicker = false;

  @override
  void initState() {
    super.initState();
    _viewMonth = widget.selectedDate.month;
    _viewYear = widget.selectedDate.year;
    _selectedDay = widget.selectedDate.day;
  }

  int get _daysInMonth => DateTime(_viewYear, _viewMonth + 1, 0).day;
  int get _firstWeekday => DateTime(_viewYear, _viewMonth, 1).weekday % 7; // 0=Sun

  void _prevMonth() {
    setState(() {
      if (_viewMonth == 1) {
        _viewMonth = 12;
        _viewYear--;
      } else {
        _viewMonth--;
      }
      _selectedDay = 1;
    });
  }

  void _nextMonth() {
    setState(() {
      if (_viewMonth == 12) {
        _viewMonth = 1;
        _viewYear++;
      } else {
        _viewMonth++;
      }
      _selectedDay = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEEEEEE)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // ── Header row ──
          Row(
            children: [
              GestureDetector(
                onTap: _prevMonth,
                child: const Icon(Icons.chevron_left_rounded,
                    size: 26, color: Color(0xFF1A1A1A)),
              ),
              const Spacer(),

              // Month dropdown
              GestureDetector(
                onTap: () => setState(() {
                  _showMonthPicker = !_showMonthPicker;
                  _showYearPicker = false;
                }),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F0F0),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _monthNames[_viewMonth - 1],
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1A1A1A)),
                      ),
                      const Icon(Icons.keyboard_arrow_down_rounded,
                          size: 18, color: Color(0xFF1A1A1A)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Year dropdown
              GestureDetector(
                onTap: () => setState(() {
                  _showYearPicker = !_showYearPicker;
                  _showMonthPicker = false;
                }),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F0F0),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$_viewYear',
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1A1A1A)),
                      ),
                      const Icon(Icons.keyboard_arrow_down_rounded,
                          size: 18, color: Color(0xFF1A1A1A)),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: _nextMonth,
                child: const Icon(Icons.chevron_right_rounded,
                    size: 26, color: Color(0xFF1A1A1A)),
              ),
            ],
          ),

          // ── Month picker ──
          if (_showMonthPicker) ...[
            const SizedBox(height: 10),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 4,
              childAspectRatio: 2.2,
              mainAxisSpacing: 6,
              crossAxisSpacing: 6,
              physics: const NeverScrollableScrollPhysics(),
              children: List.generate(12, (i) {
                final isSelected = (i + 1) == _viewMonth;
                return GestureDetector(
                  onTap: () => setState(() {
                    _viewMonth = i + 1;
                    _selectedDay = 1;
                    _showMonthPicker = false;
                  }),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF1A1A1A)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _monthNames[i],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isSelected ? Colors.white : const Color(0xFF1A1A1A),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],

          // ── Year picker ──
          if (_showYearPicker) ...[
            const SizedBox(height: 10),
            SizedBox(
              height: 120,
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 4,
                childAspectRatio: 2.0,
                mainAxisSpacing: 6,
                crossAxisSpacing: 6,
                children: List.generate(12, (i) {
                  final year = DateTime.now().year - 2 + i;
                  final isSelected = year == _viewYear;
                  return GestureDetector(
                    onTap: () => setState(() {
                      _viewYear = year;
                      _selectedDay = 1;
                      _showYearPicker = false;
                    }),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF1A1A1A)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '$year',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF1A1A1A),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],

          if (!_showMonthPicker && !_showYearPicker) ...[
            const SizedBox(height: 12),

            // ── Day headers ──
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa']
                  .map((d) => SizedBox(
                        width: 36,
                        child: Text(
                          d,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade500),
                        ),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 8),

            // ── Days grid ──
            _buildDaysGrid(),
          ],
        ],
      ),
    );
  }

  Widget _buildDaysGrid() {
    final totalCells = _firstWeekday + _daysInMonth;
    final rows = (totalCells / 7).ceil();

    return Column(
      children: List.generate(rows, (row) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(7, (col) {
            final cellIndex = row * 7 + col;
            final day = cellIndex - _firstWeekday + 1;

            if (day < 1 || day > _daysInMonth) {
              // Hari dari bulan lain — tampil abu
              final prevOrNext = day < 1
                  ? DateTime(_viewYear, _viewMonth, 0).day + day
                  : day - _daysInMonth;
              return SizedBox(
                width: 36,
                height: 36,
                child: Center(
                  child: Text(
                    '$prevOrNext',
                    style: TextStyle(
                        fontSize: 13, color: Colors.grey.shade300),
                  ),
                ),
              );
            }

            final isSelected = day == _selectedDay;

            return GestureDetector(
              onTap: () {
                setState(() => _selectedDay = day);
                widget.onDateSelected(DateTime(_viewYear, _viewMonth, day));
              },
              child: Container(
                width: 36,
                height: 36,
                margin: const EdgeInsets.symmetric(vertical: 2),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF1A1A1A)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    '$day',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w400,
                      color: isSelected
                          ? Colors.white
                          : const Color(0xFF1A1A1A),
                    ),
                  ),
                ),
              ),
            );
          }),
        );
      }),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  NAV ITEM WIDGET
// ─────────────────────────────────────────────────────────────
class _NavItem extends StatelessWidget {
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem(
      {required this.icon, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                size: 28,
                color: selected
                    ? Colors.white
                    : Colors.white.withOpacity(0.60)),
            if (selected)
              Container(
                margin: const EdgeInsets.only(top: 4),
                width: 5,
                height: 5,
                decoration: const BoxDecoration(
                    color: Colors.white, shape: BoxShape.circle),
              ),
          ],
        ),
      ),
    );
  }
}