import 'package:flutter/material.dart';
import 'package:ruangpeduliapp/panti/keuangan_panti.dart';
import 'package:ruangpeduliapp/panti/inventory_panti.dart';
import 'package:ruangpeduliapp/panti/profile_panti/profile_panti.dart';
import 'package:ruangpeduliapp/panti/home_panti/home_berita_panti.dart';
import 'package:ruangpeduliapp/data/content_api.dart';
import 'package:ruangpeduliapp/data/profile_api.dart';

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
      home: const HomePanti(userId: null, pantiId: null),
    );
  }
}

// ─── Constants ───────────────────────────────────────────────────────────────

const Color kPink = Color(0xFFF28C9F);
const Color kPinkDark = Color(0xFFE5728A);
const Color kCardBg = Colors.white;
const double kRadius = 20.0;


// ─── Main Page ───────────────────────────────────────────────────────────────

class HomePanti extends StatefulWidget {
  final int? userId;
  final int? pantiId;

  const HomePanti({super.key, required this.userId, required this.pantiId});

  @override
  State<HomePanti> createState() => _HomePantiState();
}

class _HomePantiState extends State<HomePanti> {
  int _selectedIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  late Future<List<BeritaModel>> _beritaFuture;
  String? _profilePictureUrl;

  @override
  void initState() {
    super.initState();
    _beritaFuture = ContentApi().fetchBeritas();
    if (widget.pantiId != null) {
      ProfileApi().fetchPantiProfile(widget.pantiId!).then((profile) {
        if (mounted) setState(() => _profilePictureUrl = profile.profilePicture);
      }).catchError((_) {});
    }
  }

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
        return ProfilePanti(pantiId: widget.pantiId, userId: widget.userId);
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
              color: Colors.grey[200],
              image: _profilePictureUrl != null
                  ? DecorationImage(
                      image: NetworkImage(_profilePictureUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: _profilePictureUrl == null
                ? const Icon(Icons.home_work_rounded, color: Colors.grey, size: 24)
                : null,
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
    return FutureBuilder<List<BeritaModel>>(
      future: _beritaFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(kPink),
            ),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text(
              snapshot.error.toString(),
              style: const TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          );
        }
        final beritas = snapshot.data ?? [];
        if (beritas.isEmpty) {
          return const Center(
            child: Text('Belum ada berita.', style: TextStyle(color: Colors.grey)),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
          itemCount: beritas.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (context, index) =>
              _NewsCard(item: beritas[index], userId: widget.userId),
        );
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
  final BeritaModel item;
  final int? userId;

  const _NewsCard({required this.item, required this.userId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => BeritaDetailPanti(
              beritaId: item.id,
              userId: userId,
              title: item.title,
              thumbnail: item.thumbnail,
              pantiProfilePicture: item.pantiProfilePicture,
              date: item.formattedDate,
              authorName: item.authorName,
              pantiName: item.pantiName,
              body: item.content,
              upvoteCount: item.upvoteCount,
              downvoteCount: item.downvoteCount,
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
              color: Colors.black.withValues(alpha: 0.07),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Card Image ────────────────────────────────────────────────
            AspectRatio(
              aspectRatio: 16 / 9,
              child: item.thumbnail != null
                  ? Image.network(
                      item.thumbnail!,
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
                        child: const Icon(Icons.broken_image_outlined,
                            color: Colors.grey, size: 40),
                      ),
                    )
                  : Container(
                      color: Colors.grey[200],
                      child: const Icon(Icons.newspaper_rounded,
                          color: Colors.grey, size: 40),
                    ),
            ),

            // ── Card Text Area ────────────────────────────────────────────
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
                    item.formattedDate,
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
        ),
      ),
    );
  }
}