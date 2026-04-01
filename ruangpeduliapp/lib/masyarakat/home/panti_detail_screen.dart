import 'package:flutter/material.dart';
import 'package:ruangpeduliapp/masyarakat/home/kebutuhan_screen.dart';
import 'package:ruangpeduliapp/masyarakat/transaksi/konfirmasi_pembayaran_screen.dart';
import 'package:ruangpeduliapp/masyarakat/home/home_masyarakat_screen.dart';
import 'package:ruangpeduliapp/masyarakat/search/search_screen.dart';
import 'package:ruangpeduliapp/masyarakat/history/riwayat_donasi_screen.dart';
import 'package:ruangpeduliapp/masyarakat/profile/profile_screen.dart';

// ─────────────────────────────────────────────────────────────
//  PANTI DETAIL SCREEN  (foto ke-3)
//  Dipanggil dari: BeritaDetailScreen → tombol Donasi
// ─────────────────────────────────────────────────────────────
class PantiDetailScreen extends StatefulWidget {
  final String namaPanti;
  final String username;
  final String nomorPanti;
  final String alamatPanti;
  final String description;
  final String? profilePicture;
  final String terkumpul;
  final int? userId;

  // Media foto/video untuk carousel (bisa kosong)
  final List<String> mediaUrls;

  // Kebutuhan (item out-of-stock) untuk diteruskan ke KebutuhanScreen
  final List<Map<String, dynamic>> kebutuhanList;

  const PantiDetailScreen({
    super.key,
    required this.namaPanti,
    required this.username,
    required this.nomorPanti,
    required this.alamatPanti,
    required this.description,
    this.profilePicture,
    required this.terkumpul,
    this.userId,
    this.mediaUrls = const [],
    this.kebutuhanList = const [],
  });

  @override
  State<PantiDetailScreen> createState() => _PantiDetailScreenState();
}

class _PantiDetailScreenState extends State<PantiDetailScreen> {
  static const Color _navPink = Color(0xFFF47B8C);
  static const Color _btnPink = Color(0xFFF28695);

  void _onNavTap(int index) {
    if (index == 0) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => HomeMasyarakatScreen(userId: widget.userId)),
        (route) => false,
      );
    } else if (index == 1) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => SearchScreen(userId: widget.userId)),
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Center(
                child: Text(
                  'Profil',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Header: avatar + nama + username + nomor ──
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          // Avatar / logo panti
                          Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: const Color(0xFFF43D5E), width: 2),
                              color: Colors.grey.shade100,
                            ),
                            child: ClipOval(
                              child: widget.profilePicture != null
                                  ? Image.network(
                                      widget.profilePicture!,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) =>
                                          _avatarFallback(),
                                    )
                                  : _avatarFallback(),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.namaPanti,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF1A1A1A),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  widget.username,
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey.shade500),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  widget.nomorPanti,
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey.shade500),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ── Tombol Kebutuhan & Donasi ──
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          // Kebutuhan
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _btnPink,
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 13),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                elevation: 0,
                              ),
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => KebutuhanScreen(
                                    namaPanti: widget.namaPanti,
                                    username: widget.username,
                                    profilePicture: widget.profilePicture,
                                    kebutuhanList: widget.kebutuhanList,
                                    userId: widget.userId,
                                  ),
                                ),
                              ),
                              child: const Text('Kebutuhan',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600)),
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Donasi
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _btnPink,
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 13),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                elevation: 0,
                              ),
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => KonfirmasiPembayaranScreen(
                                    namaPanti: widget.namaPanti,
                                    terkumpul: widget.terkumpul,
                                    imagePath: widget.profilePicture ?? '',
                                  ),
                                ),
                              ),
                              child: const Text('Donasi',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    const Divider(height: 1, color: Color(0xFFEEEEEE)),
                    const SizedBox(height: 16),

                    // ── Alamat ──
                    _SectionLabel('Alamat'),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          widget.alamatPanti,
                          style: const TextStyle(
                              fontSize: 13, color: Color(0xFF1A1A1A),
                              height: 1.5),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ── Foto & Video ──
                    _SectionLabel('Foto & Video'),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 90,
                      child: widget.mediaUrls.isEmpty
                          ? _buildMediaPlaceholder()
                          : ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              itemCount: widget.mediaUrls.length,
                              itemBuilder: (context, i) {
                                return Container(
                                  width: 90,
                                  height: 90,
                                  margin: const EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: const Color(0xFFDDCDD0),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      widget.mediaUrls[i],
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Icon(
                                          Icons.image_rounded,
                                          color: Colors.grey.shade400),
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                    const SizedBox(height: 20),

                    // ── Deskripsi ──
                    _SectionLabel('Deskripsi'),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          widget.description.isEmpty
                              ? 'Belum ada deskripsi.'
                              : widget.description,
                          style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF1A1A1A),
                              height: 1.6),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ── Postingan (placeholder) ──
                    _SectionLabel('Postingan'),
                    const SizedBox(height: 10),
                    _buildPostinganPlaceholder(),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildNavBar(),
    );
  }

  // ── Helpers ──

  Widget _avatarFallback() => Container(
        color: Colors.grey.shade200,
        child: Icon(Icons.business_rounded,
            size: 36, color: Colors.grey.shade400),
      );

  Widget _buildMediaPlaceholder() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: 4,
      itemBuilder: (_, i) => Container(
        width: 90,
        height: 90,
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFDDCDD0),
          borderRadius: BorderRadius.circular(10),
        ),
        child:
            Icon(Icons.image_rounded, size: 28, color: Colors.grey.shade400),
      ),
    );
  }

  Widget _buildPostinganPlaceholder() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFDDCDD0),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(Icons.image_rounded,
            size: 48, color: Colors.grey.shade400),
      ),
    );
  }

  Widget _buildNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: _navPink,
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
                  selected: false,
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

// ── Section label ──
class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1A1A1A),
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