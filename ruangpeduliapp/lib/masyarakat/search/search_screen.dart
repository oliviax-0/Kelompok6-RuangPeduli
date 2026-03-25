import 'package:flutter/material.dart';
import 'package:ruangpeduliapp/masyarakat/notification/notification_screen.dart';
import 'package:ruangpeduliapp/masyarakat/transaksi/lokasi_screen.dart';
import 'package:ruangpeduliapp/masyarakat/home/home_masyarakat_screen.dart';

class SearchScreen extends StatefulWidget {
  final int? userId;
  const SearchScreen({super.key, this.userId});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  int _selectedIndex = 1; // Search tab active

  // ── Data panti dummy ──
  final List<Map<String, String>> _pantiList = [
    {
      'nama': 'Panti Asuhan Mekar Lestari',
      'alamat':
          'Jalan Komersial III, Sektor 1.5, Jl. Lavionda Blok B1 No.1, Lengkong Gudang Timur, Serpong, Kota Tangerang Selatan, Banten 15310, Indonesia',
      'telepon': '+622153153088 (hubungi untuk jam kunjungan)',
    },
    {
      'nama': 'Panti Asuhan Kasih Sesama',
      'alamat':
          'Jl. Benda Raya / Benda Barat VI, Pamulang, Kota Tangerang Selatan, Banten 15416, Indonesia',
      'telepon': '+62 21 7405720 (hubungi untuk jam kunjungan)',
    },
    {
      'nama': 'Yayasan Sayap Ibu Cabang Banten',
      'alamat':
          'Jl. Raya Graha Utama No. 33B, Kel. Pondok Kacang Barat, Tangerang Selatan, Banten 15226, Indonesia',
      'telepon': '(021) 733-1004 (hubungi untuk jam kunjungan)',
    },
  ];

  List<Map<String, String>> get _filtered {
    final q = _searchController.text.toLowerCase();
    if (q.isEmpty) return _pantiList;
    return _pantiList
        .where((p) =>
            p['nama']!.toLowerCase().contains(q) ||
            p['alamat']!.toLowerCase().contains(q))
        .toList();
  }

  void _onNavTap(int index) {
    if (index == _selectedIndex) return;
    if (index == 0) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => HomeMasyarakatScreen(userId: widget.userId)),
      );
    }
    setState(() => _selectedIndex = index);
  }

  @override
  void initState() {
    super.initState();
    // Auto-focus search bar when page opens
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _focusNode.requestFocus();
    });
    _searchController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── App Bar ──
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  // Back button
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(Icons.arrow_back_rounded,
                        size: 24, color: Color(0xFF1A1A1A)),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Search',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const Spacer(),
                  // Notification bell
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => NotificationScreen(userId: widget.userId)),
                    ),
                    child: Image.asset(
                      'assets/images/bell_notification.png',
                      width: 26,
                      height: 26,
                      color: const Color(0xFF1A1A1A),
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.notifications_none_rounded,
                        size: 26, color: Color(0xFF1A1A1A)),
                    ),
                  ),
                ],
              ),
            ),

            // ── Search bar ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F0F0),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 14),
                    Icon(Icons.mic_rounded,
                        size: 18, color: Colors.grey.shade500),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        focusNode: _focusNode,
                        decoration: InputDecoration(
                          hintText: 'Search',
                          hintStyle: TextStyle(
                              fontSize: 14, color: Colors.grey.shade400),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 10),
                        ),
                        style: const TextStyle(
                            fontSize: 14, color: Color(0xFF1A1A1A)),
                      ),
                    ),
                    if (_searchController.text.isNotEmpty)
                      GestureDetector(
                        onTap: () => _searchController.clear(),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: Icon(Icons.close_rounded,
                              size: 18, color: Colors.grey.shade500),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ── Results list ──
            Expanded(
              child: _filtered.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off_rounded,
                              size: 56, color: Colors.grey.shade300),
                          const SizedBox(height: 12),
                          Text(
                            'Tidak ada hasil',
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey.shade400),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      itemCount: _filtered.length,
                      itemBuilder: (context, i) {
                        final item = _filtered[i];
                        return _PantiCard(
                          nama: item['nama']!,
                          alamat: item['alamat']!,
                          telepon: item['telepon']!,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => LokasiScreen(
                                namaPanti: item['nama']!,
                                alamat: item['alamat']!,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildNavBar(),
    );
  }

  Widget _buildNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF47B8C),
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
                selected: _selectedIndex == 0,
                onTap: () => _onNavTap(0),
              ),
              _NavItem(
                icon: Icons.search_rounded,
                selected: _selectedIndex == 1,
                onTap: () => _onNavTap(1),
              ),
              _NavItem(
                icon: Icons.history_rounded,
                selected: _selectedIndex == 2,
                onTap: () => _onNavTap(2),
              ),
              _NavItem(
                icon: Icons.person_rounded,
                selected: _selectedIndex == 3,
                onTap: () => _onNavTap(3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Panti Card ──
class _PantiCard extends StatelessWidget {
  final String nama;
  final String alamat;
  final String telepon;
  final VoidCallback onTap;

  const _PantiCard({
    required this.nama,
    required this.alamat,
    required this.telepon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF0F2),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nama panti
            Text(
              nama,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 8),

            // Alamat
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.location_on_rounded,
                    size: 14, color: Color(0xFFF43D5E)),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    alamat,
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        height: 1.5),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),

            // Telepon
            Row(
              children: [
                const Icon(Icons.phone_rounded,
                    size: 14, color: Color(0xFFF43D5E)),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    telepon,
                    style: TextStyle(
                        fontSize: 12, color: Colors.grey.shade600),
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

// ── Nav Item ──
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