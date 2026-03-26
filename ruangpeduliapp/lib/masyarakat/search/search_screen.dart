import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ruangpeduliapp/data/profile_api.dart';
import 'package:ruangpeduliapp/masyarakat/notification/notification_screen.dart';
import 'package:ruangpeduliapp/masyarakat/transaksi/lokasi_screen.dart';
import 'package:ruangpeduliapp/masyarakat/home/home_masyarakat_screen.dart';
import 'package:ruangpeduliapp/masyarakat/history/riwayat_donasi_screen.dart';
import 'package:ruangpeduliapp/masyarakat/profile/profile_screen.dart';

class SearchScreen extends StatefulWidget {
  final int? userId;
  const SearchScreen({super.key, this.userId});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  int _selectedIndex = 1;

  Position? _userPosition;
  bool _loadingLocation = true;

  List<PantiProfileModel> _pantiList = [];
  bool _loadingPanti = true;
  String? _errorPanti;
  String? _selectedProvinsi;

  double _distanceTo(PantiProfileModel panti) {
    if (_userPosition == null || panti.lat == null || panti.lng == null) {
      return double.infinity;
    }
    return Geolocator.distanceBetween(
      _userPosition!.latitude,
      _userPosition!.longitude,
      panti.lat!,
      panti.lng!,
    );
  }

  String _formatDistance(double meters) {
    if (meters.isInfinite) return '';
    if (meters < 1000) return '${meters.round()} m';
    return '${(meters / 1000).toStringAsFixed(1)} km';
  }

  List<String> get _availableProvinsi {
    final set = _pantiList
        .map((p) => p.provinsi)
        .where((p) => p.isNotEmpty)
        .toSet()
        .toList();
    set.sort();
    return set;
  }

  List<PantiProfileModel> get _filtered {
    final q = _searchController.text.toLowerCase();
    var list = _pantiList.where((p) {
      final matchQuery = q.isEmpty ||
          p.namaPanti.toLowerCase().contains(q) ||
          p.alamatPanti.toLowerCase().contains(q);
      final matchProvinsi =
          _selectedProvinsi == null || p.provinsi == _selectedProvinsi;
      return matchQuery && matchProvinsi;
    }).toList();
    list.sort((a, b) => _distanceTo(a).compareTo(_distanceTo(b)));
    return list;
  }

  Future<void> _fetchLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) setState(() => _loadingLocation = false);
        return;
      }
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        if (mounted) setState(() => _loadingLocation = false);
        return;
      }
      final pos = await Geolocator.getCurrentPosition(
        locationSettings:
            const LocationSettings(accuracy: LocationAccuracy.medium),
      );
      if (mounted) setState(() { _userPosition = pos; _loadingLocation = false; });
    } catch (_) {
      if (mounted) setState(() => _loadingLocation = false);
    }
  }

  Future<void> _fetchPanti() async {
    try {
      final list = await ProfileApi().fetchAllPanti();
      if (mounted) setState(() { _pantiList = list; _loadingPanti = false; });
    } catch (e) {
      if (mounted) setState(() { _errorPanti = e.toString(); _loadingPanti = false; });
    }
  }

  void _onNavTap(int index) {
    if (index == _selectedIndex) return;
    if (index == 0) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => HomeMasyarakatScreen(userId: widget.userId)),
      );
    } else if (index == 2) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => RiwayatDonasiScreen(userId: widget.userId)),
      );
    } else if (index == 3) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => ProfileScreen(userId: widget.userId)),
      );
    }
    setState(() => _selectedIndex = index);
  }

  @override
  void initState() {
    super.initState();
    _fetchLocation();
    _fetchPanti();
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(Icons.arrow_back_rounded,
                        size: 24, color: Color(0xFF1A1A1A)),
                  ),
                  const SizedBox(width: 12),
                  const Text('Search',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1A1A))),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              NotificationScreen(userId: widget.userId)),
                    ),
                    child: Image.asset(
                      'assets/images/bell_notification.png',
                      width: 26,
                      height: 26,
                      color: const Color(0xFF1A1A1A),
                      errorBuilder: (_, __, ___) => const Icon(
                          Icons.notifications_none_rounded,
                          size: 26,
                          color: Color(0xFF1A1A1A)),
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
                    Icon(Icons.search_rounded,
                        size: 18, color: Colors.grey.shade500),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        focusNode: _focusNode,
                        decoration: InputDecoration(
                          hintText: 'Cari nama panti...',
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
            const SizedBox(height: 6),

            // ── Location status row ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: [
                  if (_loadingLocation) ...[
                    SizedBox(
                      width: 12,
                      height: 12,
                      child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: const Color(0xFFF47B8C)),
                    ),
                    const SizedBox(width: 6),
                    Text('Mendeteksi lokasi Anda...',
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade500)),
                  ] else if (_userPosition != null) ...[
                    const Icon(Icons.my_location_rounded,
                        size: 13, color: Color(0xFFF43D5E)),
                    const SizedBox(width: 6),
                    Text('Diurutkan dari yang terdekat',
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade500)),
                  ] else ...[
                    Icon(Icons.location_off_rounded,
                        size: 13, color: Colors.grey.shade400),
                    const SizedBox(width: 6),
                    Text('Lokasi tidak tersedia',
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade400)),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 4),

            // ── Province filter chips ──
            if (_availableProvinsi.isNotEmpty)
              SizedBox(
                height: 36,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    // "Semua" chip
                    _FilterChip(
                      label: 'Semua',
                      selected: _selectedProvinsi == null,
                      onTap: () => setState(() => _selectedProvinsi = null),
                    ),
                    const SizedBox(width: 8),
                    ..._availableProvinsi.map((p) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: _FilterChip(
                            label: p,
                            selected: _selectedProvinsi == p,
                            onTap: () => setState(() =>
                                _selectedProvinsi =
                                    _selectedProvinsi == p ? null : p),
                          ),
                        )),
                  ],
                ),
              ),
            const SizedBox(height: 8),

            // ── Results list ──
            Expanded(child: _buildBody()),
          ],
        ),
      ),
      bottomNavigationBar: _buildNavBar(),
    );
  }

  Widget _buildBody() {
    if (_loadingPanti) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFFF47B8C)),
      );
    }
    if (_errorPanti != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off_rounded, size: 48, color: Colors.grey.shade300),
            const SizedBox(height: 12),
            Text('Gagal memuat data',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade500)),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                setState(() { _loadingPanti = true; _errorPanti = null; });
                _fetchPanti();
              },
              child: const Text('Coba lagi',
                  style: TextStyle(color: Color(0xFFF43D5E))),
            ),
          ],
        ),
      );
    }

    final items = _filtered;
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off_rounded,
                size: 56, color: Colors.grey.shade300),
            const SizedBox(height: 12),
            Text('Tidak ada hasil',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade400)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      itemCount: items.length,
      itemBuilder: (context, i) {
        final panti = items[i];
        final distM = _distanceTo(panti);
        return _PantiCard(
          panti: panti,
          distanceLabel: _formatDistance(distM),
          isNearest: i == 0 && _userPosition != null && distM.isFinite,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => LokasiScreen(
                namaPanti: panti.namaPanti,
                alamat: panti.alamatPanti,
                lat: panti.lat ?? 0,
                lng: panti.lng ?? 0,
                distanceMeters: distM.isFinite ? distM : null,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF47B8C),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
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
              _NavItem(icon: Icons.home_rounded, selected: _selectedIndex == 0, onTap: () => _onNavTap(0)),
              _NavItem(icon: Icons.search_rounded, selected: _selectedIndex == 1, onTap: () => _onNavTap(1)),
              _NavItem(icon: Icons.history_rounded, selected: _selectedIndex == 2, onTap: () => _onNavTap(2)),
              _NavItem(icon: Icons.person_rounded, selected: _selectedIndex == 3, onTap: () => _onNavTap(3)),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Panti Card ──
class _PantiCard extends StatelessWidget {
  final PantiProfileModel panti;
  final String distanceLabel;
  final bool isNearest;
  final VoidCallback onTap;

  const _PantiCard({
    required this.panti,
    required this.distanceLabel,
    required this.isNearest,
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
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header: nama + badge + jarak ──
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    panti.namaPanti,
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A1A)),
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (isNearest)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF43D5E),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text('Terdekat',
                            style: TextStyle(
                                fontSize: 10,
                                color: Colors.white,
                                fontWeight: FontWeight.w600)),
                      ),
                    if (distanceLabel.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.near_me_rounded,
                              size: 12, color: Color(0xFFF47B8C)),
                          const SizedBox(width: 3),
                          Text(distanceLabel,
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFFF47B8C),
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ],
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),

            // ── Alamat ──
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.location_on_rounded,
                    size: 14, color: Color(0xFFF43D5E)),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    panti.fullAddress.isNotEmpty
                        ? panti.fullAddress
                        : panti.alamatPanti,
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        height: 1.5)),
                ),
              ],
            ),
            const SizedBox(height: 6),

            // ── Telepon ──
            Row(
              children: [
                const Icon(Icons.phone_rounded,
                    size: 14, color: Color(0xFFF43D5E)),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(panti.nomorPanti,
                      style: TextStyle(
                          fontSize: 12, color: Colors.grey.shade600)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Filter Chip ──
class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFF43D5E) : const Color(0xFFF0F0F0),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : Colors.grey.shade600,
          ),
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
                    : Colors.white.withValues(alpha: 0.60)),
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
