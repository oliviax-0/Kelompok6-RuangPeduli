import 'package:flutter/material.dart';
import 'package:ruangpeduliapp/panti/keuangan_panti.dart';
import 'package:ruangpeduliapp/panti/inventory_panti.dart';
import 'package:ruangpeduliapp/panti/profile_panti/profile_panti.dart';
import 'package:ruangpeduliapp/panti/home_panti/home_berita_panti.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Panti App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFF28C9F)),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      ),
      home: const HomePanti(),
    );
  }
}

// ─── Constants ───────────────────────────────────────────────────────────────

const Color kPink = Color(0xFFF28C9F);
const Color kPinkDark = Color(0xFFE5728A);
const Color kCardBg = Colors.white;
const double kRadius = 20.0;

// ─── Data Model ──────────────────────────────────────────────────────────────

class NewsItem {
  final String title;
  final String date;
  final String imageUrl;
  final String authorName;
  final String pantiName;
  final String body;

  const NewsItem({
    required this.title,
    required this.date,
    required this.imageUrl,
    required this.authorName,
    required this.pantiName,
    required this.body,
  });
}

final List<NewsItem> _dummyNews = [
  NewsItem(
    title: 'Mahasiswa dan Pemuda Gelar Kerja Bakti di Panti Asuhan Kasih Mulia',
    date: '12 Februari 2026',
    imageUrl: 'https://images.unsplash.com/photo-1488521787991-ed7bbaae773c?w=800&q=80',
    authorName: 'Mawar Lestari',
    pantiName: 'Panti Kasih Mulia',
    body: 'Sejumlah mahasiswa dari Universitas , bersama komunitas pemuda lokal menggelar kegiatan kerja bakti di Panti Asuhan Kasih Mulia, Tangerang. Acara ini bertujuan untuk menciptakan lingkungan yang bersih, nyaman, serta menumbuhkan semangat kepedulian sosial di kalangan generasi muda.\n\nRangkaian Kegiatan:\nKerja bakti dimulai sejak pukul 07.00 pagi. Para peserta dibagi ke dalam beberapa kelompok dengan tugas berbeda, seperti:\nMembersihkan lingkungan: halaman, taman, dan area bermain anak-anak.\nPerbaikan fasilitas: mengecat dinding ruang belajar, memperbaiki meja dan kursi, serta merapikan kamar tidur.\nDekorasi kreatif: membuat mural edukatif di dinding ruang belajar untuk menambah semangat anak-anak saat belajar.\nInteraksi sosial: mengadakan permainan edukatif, sesi membaca bersama, dan berbagi cerita motivasi.\n\nSelain itu, mahasiswa juga mengadakan mini-workshop tentang kebersihan diri dan pentingnya menjaga lingkungan. Anak-anak panti terlihat antusias mengikuti setiap kegiatan, bahkan beberapa di antaranya ikut membantu para mahasiswa dalam menyelesaikan tugas-tugas ringan.',
  ),
  NewsItem(
    title: 'Kegiatan Sosial Bersama Anak-Anak Panti',
    date: '10 Februari 2026',
    imageUrl: 'https://images.unsplash.com/photo-1509062522246-3755977927d7?w=800&q=80',
    authorName: 'Budi Santoso',
    pantiName: 'Panti Kasih Mulia',
    body: 'Program kegiatan sosial memberikan kesempatan kepada anak-anak panti untuk mengasah keterampilan mereka melalui berbagai aktivitas menarik dan edukatif. Kegiatan ini dirancang untuk meningkatkan kepercayaan diri dan kemampuan sosial anak-anak.',
  ),
  NewsItem(
    title: 'Donasi Buku untuk Perpustakaan Panti',
    date: '8 Februari 2026',
    imageUrl: 'https://images.unsplash.com/photo-1497633762265-9d179a990aa6?w=800&q=80',
    authorName: 'Siti Nurhaliza',
    pantiName: 'Panti Kasih Mulia',
    body: 'Sebuah gerakan donasi buku berhasil mengumpulkan ratusan buku untuk perpustakaan panti asuhan di wilayah Tangerang. Koleksi buku mencakup berbagai genre mulai dari cerita anak, dongeng, hingga buku pengetahuan umum yang bermanfaat untuk pengembangan literasi anak-anak panti.',
  ),
  NewsItem(
    title: 'Pelatihan Keterampilan untuk Anak Panti',
    date: '5 Februari 2026',
    imageUrl: 'https://images.unsplash.com/photo-1503676260728-1c00da094a0b?w=800&q=80',
    authorName: 'Ahmad Rifai',
    pantiName: 'Panti Kasih Mulia',
    body: 'Program pelatihan keterampilan memberikan kesempatan kepada anak-anak panti untuk belajar berbagai macam keterampilan praktis yang dapat membuka peluang kerja di masa depan. Pelatihan mencakup bidang kerajinan tangan, teknologi dasar, dan keterampilan hidup sehari-hari.',
  ),
];

// ─── Main Page ───────────────────────────────────────────────────────────────

class HomePanti extends StatefulWidget {
  const HomePanti({super.key});

  @override
  State<HomePanti> createState() => _HomePantiState();
}

class _HomePantiState extends State<HomePanti> {
  int _selectedIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ── App Bar (only for home) ──────────────────────────────────────
            if (_selectedIndex == 0) _buildAppBar(),
            // ── Content based on selected tab ────────────────────────────────
            Expanded(
              child: _buildContent(),
            ),
          ],
        ),
      ),

      // ── FAB ──────────────────────────────────────────────────────────────
      floatingActionButton: _buildFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      // ── Bottom Nav ───────────────────────────────────────────────────────
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ─── Content Builder based on selected index ─────────────────────────────

  Widget _buildContent() {
    switch (_selectedIndex) {
      case 0:
        return _buildNewsFeed();
      case 1:
        return const KeuanganPanti();
      case 2:
        return const InventarisPanti();
      case 3:
        return const ProfilePanti();
      default:
        return _buildNewsFeed();
    }
  }

  // ─── App Bar ─────────────────────────────────────────────────────────────

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          // Profile avatar
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: kPink, width: 2),
              image: const DecorationImage(
                image: NetworkImage(
                  'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=200&q=80',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Search bar
          Expanded(
            child: Container(
              height: 46,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 15,
                  ),
                  prefixIcon: Icon(
                    Icons.mic_none_rounded,
                    color: Colors.grey[400],
                    size: 22,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 13),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── News Feed ───────────────────────────────────────────────────────────

  Widget _buildNewsFeed() {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      itemCount: _dummyNews.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return _NewsCard(item: _dummyNews[index]);
      },
    );
  }

  // ─── FAB ─────────────────────────────────────────────────────────────────

  Widget _buildFAB() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // AI secondary button (placeholder — full impl later)
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: kPink,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: kPink.withOpacity(0.4),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Center(
            child: Icon(
              Icons.auto_awesome_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Main + FAB
        FloatingActionButton(
          onPressed: () {},
          backgroundColor: Colors.white,
          elevation: 4,
          shape: const CircleBorder(),
          child: const Icon(Icons.add, color: kPinkDark, size: 28),
        ),
      ],
    );
  }

  // ─── Bottom Navigation Bar ───────────────────────────────────────────────

  Widget _buildBottomNav() {
    const icons = [
      Icons.home_rounded,
      Icons.account_balance_wallet_outlined,
      Icons.inventory_2_outlined,
      Icons.person_outline_rounded,
    ];

    return Container(
      decoration: const BoxDecoration(
        color: kPink,
        boxShadow: [
          BoxShadow(
            color: Color(0x30F28C9F),
            blurRadius: 20,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(icons.length, (index) {
              final selected = index == _selectedIndex;
              return GestureDetector(
                onTap: () => setState(() => _selectedIndex = index),
                behavior: HitTestBehavior.opaque,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Icon(
                        icons[index],
                        color: selected ? Colors.black : Colors.white.withOpacity(0.65),
                        size: 26,
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 3,
                      width: selected ? 24 : 0,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

// ─── News Card ────────────────────────────────────────────────────────────────

class _NewsCard extends StatelessWidget {
  final NewsItem item;

  const _NewsCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => BeritaDetailPanti(
              title: item.title,
              imageUrl: item.imageUrl,
              date: item.date,
              authorName: item.authorName,
              pantiName: item.pantiName,
              body: item.body,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: kCardBg,
          borderRadius: BorderRadius.circular(kRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
          // ── Card Image ──────────────────────────────────────────────────
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.network(
              item.imageUrl,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return Container(
                  color: Colors.grey[200],
                  child: const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(kPink),
                      strokeWidth: 2,
                    ),
                  ),
                );
              },
              errorBuilder: (_, __, ___) => Container(
                color: Colors.grey[200],
                child: const Icon(Icons.broken_image_outlined, color: Colors.grey, size: 40),
              ),
            ),
          ),

          // ── Card Text Area ──────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    item.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14.5,
                      color: Color(0xFF1A1A1A),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  item.date,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),      ),    );
  }
}