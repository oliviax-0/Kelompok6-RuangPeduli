import 'package:flutter/material.dart';
import 'package:ruangpeduliapp/masyarakat/home/home_masyarakat_screen.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  final List<Map<String, String>> _notifList = const [
    {'pesan': 'Selamat bergabung! Terima kasih sudah peduli sesama 💛', 'waktu': '1 hari yang lalu'},
    {'pesan': 'Selamat bergabung! Terima kasih sudah peduli sesama 💛', 'waktu': '1 hari yang lalu'},
    {'pesan': 'Selamat bergabung! Terima kasih sudah peduli sesama 💛', 'waktu': '1 hari yang lalu'},
    {'pesan': 'Selamat bergabung! Terima kasih sudah peduli sesama 💛', 'waktu': '1 hari yang lalu'},
    {'pesan': 'Selamat bergabung! Terima kasih sudah peduli sesama 💛', 'waktu': '1 hari yang lalu'},
    {'pesan': 'Selamat bergabung! Terima kasih sudah peduli sesama 💛', 'waktu': '1 hari yang lalu'},
    {'pesan': 'Selamat bergabung! Terima kasih sudah peduli sesama 💛', 'waktu': '1 hari yang lalu'},
    {'pesan': 'Selamat bergabung! Terima kasih sudah peduli sesama 💛', 'waktu': '1 hari yang lalu'},
  ];

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
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(Icons.arrow_back_rounded,
                        size: 24, color: Color(0xFF1A1A1A)),
                  ),
                  const Expanded(
                    child: Text(
                      'Notifikasi',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                  ),
                  // Placeholder to center title
                  const SizedBox(width: 24),
                ],
              ),
            ),

            // ── Notification list ──
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                itemCount: _notifList.length,
                itemBuilder: (context, i) {
                  final item = _notifList[i];
                  return _NotifCard(
                    pesan: item['pesan']!,
                    waktu: item['waktu']!,
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
                onTap: () => Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (_) => const HomeMasyarakatScreen()),
                  (route) => false,
                ),
              ),
              _NavItem(
                  icon: Icons.search_rounded, selected: false, onTap: () {}),
              _NavItem(
                  icon: Icons.history_rounded, selected: false, onTap: () {}),
              _NavItem(
                  icon: Icons.person_rounded, selected: false, onTap: () {}),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotifCard extends StatelessWidget {
  final String pesan;
  final String waktu;

  const _NotifCard({required this.pesan, required this.waktu});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF0F2),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Waktu
          Text(
            waktu,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
          ),
          const SizedBox(height: 6),
          // Pesan
          Text(
            pesan,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1A1A1A),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

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