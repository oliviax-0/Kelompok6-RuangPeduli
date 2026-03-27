import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:ruangpeduliapp/data/content_api.dart';
import 'package:ruangpeduliapp/masyarakat/home/berita_detail_screen.dart';
import 'package:ruangpeduliapp/masyarakat/home/video_player_screen.dart';
import 'package:ruangpeduliapp/masyarakat/search/search_screen.dart';
import 'package:ruangpeduliapp/masyarakat/profile/profile_screen.dart';
import 'package:ruangpeduliapp/masyarakat/history/riwayat_donasi_screen.dart';
import 'package:ruangpeduliapp/masyarakat/chatbot/chatbot_masyarakat_screen.dart';

// ─────────────────────────────────────────────
//  HOME MASYARAKAT SCREEN
// ─────────────────────────────────────────────
class HomeMasyarakatScreen extends StatefulWidget {
  final int? userId;
  const HomeMasyarakatScreen({super.key, this.userId});

  @override
  State<HomeMasyarakatScreen> createState() => _HomeMasyarakatScreenState();
}

class _HomeMasyarakatScreenState extends State<HomeMasyarakatScreen> {
  int _selectedIndex = 0;

  List<BeritaModel> _beritas = [];
  List<VideoModel> _videos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final api = ContentApi();
    final results = await Future.wait([
      api.fetchBeritas(),
      api.fetchVideos(),
    ]);
    if (mounted) {
      setState(() {
        _beritas = results[0] as List<BeritaModel>;
        _videos = results[1] as List<VideoModel>;
        _isLoading = false;
      });
    }
  }

  void _onNavTap(int index) {
    setState(() => _selectedIndex = index);
    if (index == 0) return;
    if (index == 1) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => SearchScreen(userId: widget.userId)));
      return;
    }
    if (index == 2) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => RiwayatDonasiScreen(userId: widget.userId)));
      return;
    }
    if (index == 3) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileScreen(userId: widget.userId)));
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            RefreshIndicator(
              color: const Color(0xFFF43D5E),
              onRefresh: _loadData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    _buildTopBar(),
                    const SizedBox(height: 20),
                    _buildSectionHeader('Berita', onTap: () {}),
                    const SizedBox(height: 12),
                    _buildBeritaList(),
                    const SizedBox(height: 28),
                    _buildSectionHeader('Video Terbaru', onTap: () {}),
                    const SizedBox(height: 12),
                    _buildVideoList(),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),

            // ── Chatbot FAB ──
            Positioned(
              bottom: 16,
              right: 16,
              child: GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChatbotMasyarakatScreen(userId: widget.userId),
                  ),
                ),
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
                    child: const Icon(Icons.chat_rounded, color: Colors.white, size: 28),
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
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ProfileScreen(userId: widget.userId)),
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
                child: Icon(Icons.person_rounded, size: 28, color: Colors.grey.shade500),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => SearchScreen(userId: widget.userId)),
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
                      errorBuilder: (_, __, ___) =>
                          Icon(Icons.mic_rounded, size: 18, color: Colors.grey.shade500),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Search',
                      style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
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
                  fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF1A1A1A)),
            ),
            const SizedBox(width: 2),
            const Icon(Icons.chevron_right_rounded, size: 26, color: Color(0xFF1A1A1A)),
          ],
        ),
      ),
    );
  }

  // ── Berita list ──
  Widget _buildBeritaList() {
    if (_isLoading) {
      return const SizedBox(
        height: 235,
        child: Center(child: CircularProgressIndicator(color: Color(0xFFF43D5E))),
      );
    }
    if (_beritas.isEmpty) {
      return SizedBox(
        height: 235,
        child: Center(
          child: Text('Belum ada berita', style: TextStyle(color: Colors.grey.shade400)),
        ),
      );
    }

    return SizedBox(
      height: 235,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _beritas.length,
        itemBuilder: (context, i) {
          final item = _beritas[i];
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => BeritaDetailScreen(berita: item)),
            ),
            child: Container(
              width: 215,
              margin: const EdgeInsets.only(right: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
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
                    child: item.thumbnail != null && item.thumbnail!.isNotEmpty
                        ? Image.network(
                            item.thumbnail!,
                            height: 150,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _imagePlaceholder(150),
                          )
                        : _imagePlaceholder(150),
                  ),
                  // Title + date
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1A1A1A)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.formattedDate,
                          style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
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
    if (_isLoading) {
      return const SizedBox(
        height: 215,
        child: Center(child: CircularProgressIndicator(color: Color(0xFFF43D5E))),
      );
    }
    if (_videos.isEmpty) {
      return SizedBox(
        height: 215,
        child: Center(
          child: Text('Belum ada video', style: TextStyle(color: Colors.grey.shade400)),
        ),
      );
    }

    return SizedBox(
      height: 215,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _videos.length,
        itemBuilder: (context, i) {
          final video = _videos[i];
          final videoId = YoutubePlayer.convertUrlToId(video.videoUrl);
          final ytThumb = videoId != null
              ? 'https://img.youtube.com/vi/$videoId/mqdefault.jpg'
              : null;

          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => VideoPlayerScreen(video: video)),
            ),
            child: Container(
              width: 178,
              margin: const EdgeInsets.only(right: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.07),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    child: Stack(
                      children: [
                        // Thumbnail: custom → YouTube auto → placeholder
                        _videoThumbnail(video.thumbnail, ytThumb),
                        // Play button overlay
                        Positioned.fill(
                          child: Center(
                            child: Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.85),
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
                            color: const Color(0xFFF43D5E).withValues(alpha: 0.12),
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
                            video.pantiName,
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

  Widget _videoThumbnail(String? customThumb, String? ytThumb) {
    if (customThumb != null && customThumb.isNotEmpty) {
      return Image.network(
        customThumb,
        height: 145,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _videoThumbnail(null, ytThumb),
      );
    }
    if (ytThumb != null) {
      return Image.network(
        ytThumb,
        height: 145,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _imagePlaceholder(145, color: const Color(0xFFBFB0B3)),
      );
    }
    return _imagePlaceholder(145, color: const Color(0xFFBFB0B3));
  }

  Widget _imagePlaceholder(double height, {Color color = const Color(0xFFCFBFC2)}) {
    return Container(
      height: height,
      width: double.infinity,
      color: color,
      child: Center(
        child: Icon(Icons.image_rounded, size: 44, color: Colors.grey.shade300),
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

// ─────────────────────────────────────────────
//  NAV ITEM WIDGET
// ─────────────────────────────────────────────
class _NavItem extends StatelessWidget {
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({required this.icon, required this.selected, required this.onTap});

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
              color: selected ? Colors.white : Colors.white.withValues(alpha: 0.60),
            ),
            if (selected)
              Container(
                margin: const EdgeInsets.only(top: 4),
                width: 5,
                height: 5,
                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              ),
          ],
        ),
      ),
    );
  }
}

