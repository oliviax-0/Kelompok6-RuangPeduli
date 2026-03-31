import 'package:flutter/material.dart';
import 'package:ruangpeduliapp/masyarakat/home/home_masyarakat_screen.dart';
import 'package:ruangpeduliapp/masyarakat/search/search_screen.dart';
import 'package:ruangpeduliapp/masyarakat/history/riwayat_donasi_screen.dart';
import 'package:ruangpeduliapp/masyarakat/profile/profile_screen.dart';

// ─────────────────────────────────────────────────────────────
//  KEBUTUHAN SCREEN  (foto ke-4)
//  Dipanggil dari: PantiDetailScreen → tombol Kebutuhan
// ─────────────────────────────────────────────────────────────
class KebutuhanScreen extends StatelessWidget {
  final String namaPanti;
  final String username;
  final String? profilePicture;
  final int? userId;

  /// List kebutuhan: setiap item = {'name': 'Susu', 'quantity': 2, 'unit': 'Liter'}
  final List<Map<String, dynamic>> kebutuhanList;

  const KebutuhanScreen({
    super.key,
    required this.namaPanti,
    required this.username,
    this.profilePicture,
    this.userId,
    this.kebutuhanList = const [],
  });

  // ── Dummy data jika list kosong ──
  static const List<Map<String, dynamic>> _dummyList = [
    {'name': 'Susu', 'quantity': 2, 'unit': 'Liter', 'icon': 'susu'},
    {'name': 'Telur', 'quantity': 1, 'unit': 'Kg', 'icon': 'telur'},
    {'name': 'Beras', 'quantity': 5, 'unit': 'Kg', 'icon': 'beras'},
    {'name': 'Minyak Goreng', 'quantity': 2, 'unit': 'Liter', 'icon': 'minyak'},
  ];

  List<Map<String, dynamic>> get _items =>
      kebutuhanList.isEmpty ? _dummyList : kebutuhanList;

  void _onNavTap(BuildContext context, int index) {
    if (index == 0) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => HomeMasyarakatScreen(userId: userId)),
        (route) => false,
      );
    } else if (index == 1) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => SearchScreen(userId: userId)),
      );
    } else if (index == 2) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => RiwayatDonasiScreen(userId: userId)),
      );
    } else if (index == 3) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => ProfileScreen(userId: userId)),
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(Icons.arrow_back_rounded,
                        size: 24, color: Color(0xFF1A1A1A)),
                  ),
                  const Expanded(
                    child: Text(
                      'Kebutuhan',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                ],
              ),
            ),

            // ── Header panti ──
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: Row(
                children: [
                  // Avatar
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: const Color(0xFFF43D5E), width: 1.5),
                      color: Colors.grey.shade100,
                    ),
                    child: ClipOval(
                      child: profilePicture != null
                          ? Image.network(
                              profilePicture!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => _avatarFallback(),
                            )
                          : _avatarFallback(),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        namaPanti,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        username,
                        style: TextStyle(
                            fontSize: 13, color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),
            const Divider(height: 1, color: Color(0xFFEEEEEE)),
            const SizedBox(height: 16),

            // ── Grid kebutuhan ──
            Expanded(
              child: _items.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.inventory_2_outlined,
                              size: 56, color: Colors.grey.shade300),
                          const SizedBox(height: 12),
                          Text(
                            'Belum ada kebutuhan terdaftar',
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade400),
                          ),
                        ],
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 4),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 16,
                        childAspectRatio: 0.85,
                      ),
                      itemCount: _items.length,
                      itemBuilder: (context, i) {
                        final item = _items[i];
                        return _KebutuhanCard(
                          name: item['name'] as String,
                          quantity: item['quantity'] is int
                              ? item['quantity'] as int
                              : int.tryParse(
                                      item['quantity'].toString()) ??
                                  0,
                          unit: item['unit'] as String? ?? '',
                          iconKey: item['icon'] as String? ?? '',
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildNavBar(context),
    );
  }

  Widget _avatarFallback() => Container(
        color: Colors.grey.shade200,
        child: Icon(Icons.business_rounded,
            size: 28, color: Colors.grey.shade400),
      );

  Widget _buildNavBar(BuildContext context) {
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
                  selected: false,
                  onTap: () => _onNavTap(context, 0)),
              _NavItem(
                  icon: Icons.search_rounded,
                  selected: false,
                  onTap: () => _onNavTap(context, 1)),
              _NavItem(
                  icon: Icons.history_rounded,
                  selected: false,
                  onTap: () => _onNavTap(context, 2)),
              _NavItem(
                  icon: Icons.person_rounded,
                  selected: false,
                  onTap: () => _onNavTap(context, 3)),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  KEBUTUHAN CARD  —  card pink bulat dengan ikon + nama + qty
// ─────────────────────────────────────────────────────────────
class _KebutuhanCard extends StatelessWidget {
  final String name;
  final int quantity;
  final String unit;
  final String iconKey;

  const _KebutuhanCard({
    required this.name,
    required this.quantity,
    required this.unit,
    required this.iconKey,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Card pink dengan ikon
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF1BFB4).withOpacity(0.45),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: _buildIcon(iconKey, name),
          ),
        ),
        const SizedBox(height: 10),

        // Nama item
        Text(
          name,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 4),

        // Jumlah + satuan
        Text(
          '$quantity  $unit',
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF1A1A1A),
          ),
        ),
      ],
    );
  }

  /// Ikon custom SVG-like menggunakan CustomPainter agar sesuai foto
  Widget _buildIcon(String key, String fallbackName) {
    final Map<String, Widget> iconMap = {
      'susu': const _SusuIcon(),
      'telur': const _TelurIcon(),
      'beras': const _BerasIcon(),
      'minyak': const _MinyakIcon(),
    };

    return iconMap[key.toLowerCase()] ??
        // Fallback: inisial nama item
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: const Color(0xFFF1BFB4),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              fallbackName.isNotEmpty
                  ? fallbackName[0].toUpperCase()
                  : '?',
              style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A1A)),
            ),
          ),
        );
  }
}

// ─────────────────────────────────────────────────────────────
//  CUSTOM ICON PAINTERS
// ─────────────────────────────────────────────────────────────

class _SusuIcon extends StatelessWidget {
  const _SusuIcon();
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(64, 80),
      painter: _SusuPainter(),
    );
  }
}

class _SusuPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1A1A1A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final w = size.width;
    final h = size.height;

    // Badan kotak susu
    final body = RRect.fromLTRBR(
        w * 0.15, h * 0.25, w * 0.85, h * 0.92, const Radius.circular(4));
    canvas.drawRRect(body, paint);

    // Atap trapesoid
    final roofPath = Path()
      ..moveTo(w * 0.15, h * 0.25)
      ..lineTo(w * 0.22, h * 0.06)
      ..lineTo(w * 0.78, h * 0.06)
      ..lineTo(w * 0.85, h * 0.25);
    canvas.drawPath(roofPath, paint);

    // Garis tutup atas
    canvas.drawLine(
        Offset(w * 0.22, h * 0.06), Offset(w * 0.78, h * 0.06), paint);

    // Huruf M di tengah badan
    final mPaint = Paint()
      ..color = const Color(0xFF1A1A1A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final mPath = Path()
      ..moveTo(w * 0.30, h * 0.70)
      ..lineTo(w * 0.30, h * 0.48)
      ..lineTo(w * 0.50, h * 0.60)
      ..lineTo(w * 0.70, h * 0.48)
      ..lineTo(w * 0.70, h * 0.70);
    canvas.drawPath(mPath, mPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}

class _TelurIcon extends StatelessWidget {
  const _TelurIcon();
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(72, 64),
      painter: _TelurPainter(),
    );
  }
}

class _TelurPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1A1A1A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;

    final w = size.width;
    final h = size.height;

    // Telur kiri (belakang)
    final egg1 = Path();
    egg1.addOval(Rect.fromCenter(
        center: Offset(w * 0.38, h * 0.52),
        width: w * 0.42,
        height: h * 0.72));
    canvas.drawPath(egg1, paint);

    // Telur kanan (depan, sedikit overlap)
    final egg2 = Path();
    egg2.addOval(Rect.fromCenter(
        center: Offset(w * 0.62, h * 0.52),
        width: w * 0.42,
        height: h * 0.72));
    // gambar dengan fill putih dulu biar menutupi telur kiri
    final fillPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawPath(egg2, fillPaint);
    canvas.drawPath(egg2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}

class _BerasIcon extends StatelessWidget {
  const _BerasIcon();
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(64, 76),
      painter: _BerasPainter(),
    );
  }
}

class _BerasPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1A1A1A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final w = size.width;
    final h = size.height;

    // Karung beras — bentuk bag rounded
    final bag = Path()
      ..moveTo(w * 0.30, h * 0.20)
      ..quadraticBezierTo(w * 0.15, h * 0.20, w * 0.10, h * 0.45)
      ..quadraticBezierTo(w * 0.08, h * 0.75, w * 0.50, h * 0.92)
      ..quadraticBezierTo(w * 0.92, h * 0.75, w * 0.90, h * 0.45)
      ..quadraticBezierTo(w * 0.85, h * 0.20, w * 0.70, h * 0.20)
      ..quadraticBezierTo(w * 0.60, h * 0.10, w * 0.50, h * 0.12)
      ..quadraticBezierTo(w * 0.40, h * 0.10, w * 0.30, h * 0.20)
      ..close();
    canvas.drawPath(bag, paint);

    // Tali atas
    final tiePath = Path()
      ..moveTo(w * 0.30, h * 0.20)
      ..quadraticBezierTo(w * 0.50, h * 0.28, w * 0.70, h * 0.20);
    canvas.drawPath(tiePath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}

class _MinyakIcon extends StatelessWidget {
  const _MinyakIcon();
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(54, 80),
      painter: _MinyakPainter(),
    );
  }
}

class _MinyakPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1A1A1A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final w = size.width;
    final h = size.height;

    // Botol minyak goreng — silinder dengan leher
    final bottle = Path()
      // Bagian bawah botol bulat
      ..moveTo(w * 0.20, h * 0.92)
      ..quadraticBezierTo(w * 0.05, h * 0.92, w * 0.05, h * 0.60)
      ..lineTo(w * 0.05, h * 0.45)
      ..quadraticBezierTo(w * 0.05, h * 0.35, w * 0.25, h * 0.30)
      ..lineTo(w * 0.30, h * 0.18)
      // leher botol
      ..lineTo(w * 0.38, h * 0.12)
      ..lineTo(w * 0.62, h * 0.12)
      ..lineTo(w * 0.70, h * 0.18)
      ..lineTo(w * 0.75, h * 0.30)
      ..quadraticBezierTo(w * 0.95, h * 0.35, w * 0.95, h * 0.45)
      ..lineTo(w * 0.95, h * 0.60)
      ..quadraticBezierTo(w * 0.95, h * 0.92, w * 0.80, h * 0.92)
      ..close();
    canvas.drawPath(bottle, paint);

    // Tutup botol
    final capPath = Path()
      ..moveTo(w * 0.38, h * 0.12)
      ..lineTo(w * 0.38, h * 0.05)
      ..lineTo(w * 0.62, h * 0.05)
      ..lineTo(w * 0.62, h * 0.12);
    canvas.drawPath(capPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
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