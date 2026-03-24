import 'package:flutter/material.dart';
import 'package:ruangpeduliapp/masyarakat/search_screen.dart';
import 'package:ruangpeduliapp/masyarakat/profile_screen.dart';
import 'package:ruangpeduliapp/masyarakat/notification_screen.dart';

// ─────────────────────────────────────────────
//  HOME MASYARAKAT SCREEN
// ─────────────────────────────────────────────
class HomeMasyarakatScreen extends StatefulWidget {
  const HomeMasyarakatScreen({super.key});

  @override
  State<HomeMasyarakatScreen> createState() => _HomeMasyarakatScreenState();
}

class _HomeMasyarakatScreenState extends State<HomeMasyarakatScreen> {
  int _selectedIndex = 0;

  // ── Dummy berita ──
  final List<Map<String, String>> _beritaList = [
    {'title': 'Sejarah Yayasan Sayap Ibu', 'date': '12 Februari 2026'},
    {'title': 'Sejarah Yayasan Sayap Ibu', 'date': '12 Februari 2026'},
    {'title': 'Sejarah Yayasan Sayap Ibu', 'date': '12 Februari 2026'},
    {'title': 'Sejarah Yayasan Sayap Ibu', 'date': '12 Februari 2026'},
  ];

  // ── Dummy video ──
  final List<String> _videoChannels = [
    'Yayasan Sayap Ibu',
    'Yayasan Sayap Ibu',
    'Yayasan Sayap Ibu',
  ];

  void _goTo(String title) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => _PlaceholderPage(title: title)),
    );
  }

  void _onNavTap(int index) {
    setState(() => _selectedIndex = index);
    if (index == 0) return;
    const titles = ['Home', 'Search', 'History', 'Profile'];
      if (index == 3) {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
        return;
      }
    if (index == 1) {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const SearchScreen()));
        return;
      }
      _goTo(titles[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  _buildTopBar(),
                  const SizedBox(height: 20),
                  _buildSectionHeader('Berita', onTap: () => _goTo('Berita')),
                  const SizedBox(height: 12),
                  _buildBeritaList(),
                  const SizedBox(height: 28),
                  _buildSectionHeader('Video Terbaru',
                      onTap: () => _goTo('Video Terbaru')),
                  const SizedBox(height: 12),
                  _buildVideoList(),
                  const SizedBox(height: 100),
                ],
              ),
            ),

            // ── Chatbot FAB ──
            Positioned(
              bottom: 16,
              right: 16,
              child: GestureDetector(
                onTap: () => _goTo('Chat AI'),
                child: Image.asset(
                  'assets/images/chatbot_ai.png',
                  width: 56,
                  height: 56,
                  errorBuilder: (_, __, ___) => Container(
                    width: 56,
                    height: 56,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF43D5E),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.chat_rounded,
                        color: Colors.white, size: 28),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildNavBar(),
    );
  }

  // ── Top bar ──
  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // Profile avatar
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            ),
            child: Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFF43D5E), width: 2),
                color: Colors.grey.shade200,
              ),
              child: ClipOval(
                child: Icon(Icons.person_rounded,
                    size: 28, color: Colors.grey.shade500),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Search bar
          Expanded(
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SearchScreen()),
              ),
              child: Container(
                height: 42,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F0F0),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/Mic.png',
                      width: 16,
                      height: 16,
                      color: Colors.grey.shade500,
                      errorBuilder: (_, __, ___) => Icon(
                        Icons.mic_rounded,
                        size: 18,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Search',
                      style: TextStyle(
                          fontSize: 14, color: Colors.grey.shade400),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Section header ──
  Widget _buildSectionHeader(String title, {required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A1A)),
            ),
            const SizedBox(width: 2),
            const Icon(Icons.chevron_right_rounded,
                size: 26, color: Color(0xFF1A1A1A)),
          ],
        ),
      ),
    );
  }

  // ── Berita list ──
  Widget _buildBeritaList() {
    return SizedBox(
      height: 235,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _beritaList.length,
        itemBuilder: (context, i) {
          final item = _beritaList[i];
          return GestureDetector(
            onTap: () => _goTo(item['title']!),
            child: Container(
              width: 215,
              margin: const EdgeInsets.only(right: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image placeholder
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    child: Container(
                      height: 150,
                      width: double.infinity,
                      color: const Color(0xFFCFBFC2),
                      child: Center(
                        child: Icon(Icons.image_rounded,
                            size: 44, color: Colors.grey.shade300),
                      ),
                    ),
                  ),
                  // Title + date
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['title']!,
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1A1A1A)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item['date']!,
                          style: TextStyle(
                              fontSize: 10, color: Colors.grey.shade500),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Video list ──
  Widget _buildVideoList() {
    return SizedBox(
      height: 215,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _videoChannels.length,
        itemBuilder: (context, i) {
          return GestureDetector(
            onTap: () => _goTo('Video Player'),
            child: Container(
              width: 178,
              margin: const EdgeInsets.only(right: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.07),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Thumbnail
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    child: Stack(
                      children: [
                        Container(
                          height: 145,
                          width: double.infinity,
                          color: const Color(0xFFBFB0B3),
                          child: Center(
                            child: Icon(Icons.image_rounded,
                                size: 44, color: Colors.grey.shade300),
                          ),
                        ),
                        // Play button overlay
                        Positioned.fill(
                          child: Center(
                            child: Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.85),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.play_arrow_rounded,
                                color: Color(0xFFF43D5E),
                                size: 30,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Channel info
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
                    child: Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF43D5E).withOpacity(0.12),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.play_circle_outline_rounded,
                            size: 15,
                            color: Color(0xFFF43D5E),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            _videoChannels[i],
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF1A1A1A)),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Bottom nav bar ──
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

// ─────────────────────────────────────────────
//  NAV ITEM WIDGET
// ─────────────────────────────────────────────
class _NavItem extends StatelessWidget {
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 28,
              color: selected
                  ? Colors.white
                  : Colors.white.withOpacity(0.60),
            ),
            if (selected)
              Container(
                margin: const EdgeInsets.only(top: 4),
                width: 5,
                height: 5,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  PLACEHOLDER PAGE
// ─────────────────────────────────────────────
class _PlaceholderPage extends StatelessWidget {
  final String title;
  const _PlaceholderPage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF47B8C),
        elevation: 0,
        title: Text(
          title,
          style: const TextStyle(
              fontWeight: FontWeight.w700, color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.construction_rounded,
                size: 60, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A1A)),
            ),
            const SizedBox(height: 8),
            Text(
              'Halaman dalam pengembangan',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
            ),
          ],
        ),
      ),
    );
  }
}