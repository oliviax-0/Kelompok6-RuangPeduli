import 'package:flutter/material.dart';
import 'package:ruangpeduliapp/panti/profile_panti/edit_profile_panti.dart';
import 'package:ruangpeduliapp/panti/profile_panti/popup_panti.dart';

// ─── Constants ───────────────────────────────────────────────────────────────

const Color kPink = Color(0xFFF28C9F);
const Color kPinkDark = Color(0xFFE5728A);
const Color kGrey = Color(0xFFF0F0F0);

// ─── Dummy Data ───────────────────────────────────────────────────────────────

const String kAddress =
    'Jalan Edu City Kavling Edu I No. 10, Jalan BSD Raya Barat Laut 1, Serpong, Pagedangan, Kabupaten Tangerang, Banten 15339';

const String kDescription =
    'Panti Asuhan Kasih Muliah hadir sejak tahun 1947. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum quis est porttitor erat gravida ultricies. Vivamus sit amet nulla ipsum. Aliquam ac euismod ex.';

class _MediaItem {
  final String url;
  final bool isVideo;
  const _MediaItem(this.url, {this.isVideo = false});
}

final List<_MediaItem> _mediaItems = [
  _MediaItem('https://images.unsplash.com/photo-1509062522246-3755977927d7?w=300&q=80'),
  _MediaItem('https://images.unsplash.com/photo-1488521787991-ed7bbaae773c?w=300&q=80', isVideo: true),
  _MediaItem('https://images.unsplash.com/photo-1503676260728-1c00da094a0b?w=300&q=80'),
  _MediaItem('https://images.unsplash.com/photo-1497633762265-9d179a990aa6?w=300&q=80', isVideo: true),
  _MediaItem('https://images.unsplash.com/photo-1529390079861-591de354faf5?w=300&q=80'),
];

class _PostItem {
  final String title;
  final String date;
  final String imageUrl;
  const _PostItem(this.title, this.date, this.imageUrl);
}

final List<_PostItem> _posts = [
  _PostItem('Mahasiswa dan Pemuda Gelar K...', '12 Februari 2026',
      'https://images.unsplash.com/photo-1488521787991-ed7bbaae773c?w=800&q=80'),
  _PostItem('Mahasiswa dan Pemuda Gelar K...', '12 Februari 2026',
      'https://images.unsplash.com/photo-1509062522246-3755977927d7?w=800&q=80'),
  _PostItem('Mahasiswa dan Pemuda Gelar K...', '12 Februari 2026',
      'https://images.unsplash.com/photo-1529390079861-591de354faf5?w=800&q=80'),
];

// ─── Main Page ───────────────────────────────────────────────────────────────

class ProfilePanti extends StatefulWidget {
  const ProfilePanti({super.key});

  @override
  State<ProfilePanti> createState() => _ProfilePantiState();
}

class _ProfilePantiState extends State<ProfilePanti> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ──────────────────────────────────────────────────────────────
        _buildFixedHeader(),
        const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),
        Expanded(
          child: _buildScrollableBody(),
        ),
      ],
    );
  }

  // ─── Fixed Header ─────────────────────────────────────────────────────────

  Widget _buildFixedHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Column(
        children: [
          // Title
          const Text(
            'Profil',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 16),

          // Profile row
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: kPink, width: 2.5),
                  image: const DecorationImage(
                    image: NetworkImage(
                      'https://images.unsplash.com/photo-1509062522246-3755977927d7?w=300&q=80',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 14),

              // Name + username + button
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Panti Kasih Mulya',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '@panti_kasihmulya',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[500],
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const EditProfilePanti(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPink,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'Edit Profil',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── Scrollable Body ──────────────────────────────────────────────────────

  Widget _buildScrollableBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Alamat
          _SectionHeader(title: 'Alamat', onAdd: () => showAlamatPopup(context, initialValue: kAddress)),
          const SizedBox(height: 8),
          _GreyContainer(child: Text(kAddress, style: _bodyStyle())),

          const SizedBox(height: 20),

          // Foto & Video
          _SectionHeader(title: 'Foto & Video', onAdd: () => showFotoVideoPopup(context)),
          const SizedBox(height: 8),
          _buildMediaGallery(),

          const SizedBox(height: 20),

          // Deskripsi
          _SectionHeader(title: 'Deskripsi', onAdd: () => showDeskripsiPopup(context, initialValue: kDescription)),
          const SizedBox(height: 8),
          _GreyContainer(child: Text(kDescription, style: _bodyStyle())),

          const SizedBox(height: 20),

          // Postingan
          _SectionHeader(title: 'Postingan', onAdd: null),
          const SizedBox(height: 12),
          _buildPostFeed(),
        ],
      ),
    );
  }

  // ─── Media Gallery ────────────────────────────────────────────────────────

  Widget _buildMediaGallery() {
    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _mediaItems.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final item = _mediaItems[index];
          return ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Stack(
              children: [
                Image.network(
                  item.url,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  loadingBuilder: (_, child, progress) => progress == null
                      ? child
                      : Container(
                          width: 100,
                          height: 100,
                          color: Colors.grey[200],
                          child: const Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(kPink),
                            ),
                          ),
                        ),
                ),
                if (item.isVideo)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withOpacity(0.25),
                      child: const Icon(
                        Icons.play_circle_fill_rounded,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ─── Post Feed ────────────────────────────────────────────────────────────

  Widget _buildPostFeed() {
    return Column(
      children: _posts.map((post) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _PostCard(post: post),
        );
      }).toList(),
    );
  }
}

// ─── Helpers ─────────────────────────────────────────────────────────────────

TextStyle _bodyStyle() => const TextStyle(
      fontSize: 13.5,
      color: Color(0xFF444444),
      height: 1.55,
    );

// ─── Section Header ───────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onAdd;

  const _SectionHeader({required this.title, this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A1A),
          ),
        ),
        if (onAdd != null) ...[
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onAdd,
            child: const Icon(Icons.add_circle_outline_rounded, size: 20, color: Color(0xFF1A1A1A)),
          ),
        ],
      ],
    );
  }
}

// ─── Grey Container ───────────────────────────────────────────────────────────

class _GreyContainer extends StatelessWidget {
  final Widget child;
  const _GreyContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }
}

// ─── Post Card ────────────────────────────────────────────────────────────────

class _PostCard extends StatelessWidget {
  final _PostItem post;
  const _PostCard({required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.network(
              post.imageUrl,
              fit: BoxFit.cover,
              loadingBuilder: (_, child, progress) => progress == null
                  ? child
                  : Container(
                      color: Colors.grey[200],
                      child: const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(kPink),
                        ),
                      ),
                    ),
              errorBuilder: (_, __, ___) => Container(
                color: Colors.grey[200],
                child: const Icon(Icons.broken_image_outlined, color: Colors.grey, size: 40),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    post.title,
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
                  post.date,
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}