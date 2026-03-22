import 'package:flutter/material.dart';
import 'package:ruangpeduliapp/panti/profile_panti/edit_profile_panti.dart';
import 'package:ruangpeduliapp/panti/profile_panti/popup_panti.dart';
import 'package:ruangpeduliapp/data/profile_api.dart';
import 'package:ruangpeduliapp/data/content_api.dart';
import 'package:ruangpeduliapp/auth/role_selection_screen.dart';

// ─── Constants ───────────────────────────────────────────────────────────────

const Color kPink = Color(0xFFF28C9F);
const Color kPinkDark = Color(0xFFE5728A);
const Color kGrey = Color(0xFFF0F0F0);

// ─── Main Page ───────────────────────────────────────────────────────────────

class ProfilePanti extends StatefulWidget {
  final int? pantiId;
  final int? userId;
  const ProfilePanti({super.key, this.pantiId, this.userId});

  @override
  State<ProfilePanti> createState() => _ProfilePantiState();
}

class _ProfilePantiState extends State<ProfilePanti> {
  PantiProfileModel? _profile;
  List<PantiMediaModel> _media = [];
  List<BeritaModel> _beritas = [];

  @override
  void initState() {
    super.initState();
    if (widget.pantiId != null) {
      _loadAll(widget.pantiId!);
    }
  }

  Future<void> _loadAll(int pantiId) async {
    final api = ProfileApi();
    final profileFuture = api.fetchPantiProfile(pantiId).catchError((_) => PantiProfileModel(
      id: pantiId, username: '', email: '', namaPanti: '', alamatPanti: '', nomorPanti: '', description: '',
    ));
    final mediaFuture   = api.fetchPantiMedia(pantiId).catchError((_) => <PantiMediaModel>[]);
    final beritaFuture  = ContentApi().fetchBeritas(pantiId: pantiId).catchError((_) => <BeritaModel>[]);

    final results = await Future.wait([profileFuture, mediaFuture, beritaFuture]);
    if (!mounted) return;
    setState(() {
      _profile = results[0] as PantiProfileModel;
      _media   = results[1] as List<PantiMediaModel>;
      _beritas = results[2] as List<BeritaModel>;
    });
  }

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
                  color: Colors.grey[200],
                  image: _profile?.profilePicture != null
                      ? DecorationImage(
                          image: NetworkImage(_profile!.profilePicture!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: _profile?.profilePicture == null
                    ? const Icon(Icons.home_work_rounded, color: Colors.grey, size: 32)
                    : null,
              ),
              const SizedBox(width: 14),

              // Name + username + button
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _profile?.namaPanti ?? '...',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _profile != null ? '@${_profile!.username}' : '',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[500],
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _profile == null || widget.pantiId == null
                            ? null
                            : _openEditProfile,
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

  Future<void> _openEditProfile() async {
    final updated = await Navigator.push<PantiProfileModel>(
      context,
      MaterialPageRoute(
        builder: (_) => EditProfilePanti(
          pantiId: widget.pantiId!,
          userId: widget.userId ?? 0,
          initialProfile: _profile!,
        ),
      ),
    );
    if (updated != null && mounted) {
      setState(() => _profile = updated);
    }
  }

  // ─── Scrollable Body ──────────────────────────────────────────────────────

  Widget _buildScrollableBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Alamat
          _SectionHeader(
            title: 'Alamat',
            onAdd: widget.pantiId == null ? null : () => _editAlamat(),
          ),
          const SizedBox(height: 8),
          _GreyContainer(child: Text(_profile?.alamatPanti ?? '...', style: _bodyStyle())),

          const SizedBox(height: 20),

          // Foto & Video
          _SectionHeader(
            title: 'Foto & Video',
            onAdd: widget.pantiId == null ? null : () => _editMedia(),
          ),
          const SizedBox(height: 8),
          _buildMediaGallery(),

          const SizedBox(height: 20),

          // Deskripsi
          _SectionHeader(
            title: 'Deskripsi',
            onAdd: widget.pantiId == null ? null : () => _editDeskripsi(),
          ),
          const SizedBox(height: 8),
          _GreyContainer(child: Text(_profile?.description ?? '...', style: _bodyStyle())),

          const SizedBox(height: 20),

          // Postingan
          const _SectionHeader(title: 'Postingan', onAdd: null),
          const SizedBox(height: 12),
          _buildPostFeed(),

          const SizedBox(height: 32),

          // Logout
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _logout,
              icon: const Icon(Icons.logout_rounded, size: 18, color: Colors.red),
              label: const Text(
                'Keluar',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.red),
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: const BorderSide(color: Colors.red),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Keluar', style: TextStyle(fontWeight: FontWeight.w800)),
        content: const Text('Apakah kamu yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
                (route) => false,
              );
            },
            child: const Text('Keluar', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  Future<void> _editAlamat() async {
    final newValue = await showAlamatPopup(
      context,
      pantiId: widget.pantiId!,
      initialValue: _profile?.alamatPanti ?? '',
    );
    if (newValue != null && mounted) {
      setState(() => _profile = _profile?.copyWith(alamatPanti: newValue));
    }
  }

  Future<void> _editDeskripsi() async {
    final newValue = await showDeskripsiPopup(
      context,
      pantiId: widget.pantiId!,
      initialValue: _profile?.description ?? '',
    );
    if (newValue != null && mounted) {
      setState(() => _profile = _profile?.copyWith(description: newValue));
    }
  }

  Future<void> _editMedia() async {
    final updatedMedia = await showFotoVideoPopup(
      context,
      pantiId: widget.pantiId!,
      media: _media,
    );
    if (updatedMedia != null && mounted) {
      setState(() => _media = updatedMedia);
    }
  }

  // ─── Media Gallery ────────────────────────────────────────────────────────

  Widget _buildMediaGallery() {
    if (_media.isEmpty) {
      return _GreyContainer(
        child: Text('Belum ada foto & video.', style: _bodyStyle()),
      );
    }
    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _media.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final item = _media[index];
          final imageUrl = item.file;
          return ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Stack(
              children: [
                imageUrl != null
                    ? Image.network(
                        imageUrl,
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
                        errorBuilder: (_, __, ___) => Container(
                          width: 100, height: 100, color: Colors.grey[200],
                          child: const Icon(Icons.broken_image_outlined, color: Colors.grey),
                        ),
                      )
                    : Container(
                        width: 100, height: 100, color: Colors.grey[200],
                        child: const Icon(Icons.image_not_supported_outlined, color: Colors.grey),
                      ),
                if (item.isVideo)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.25),
                      child: const Icon(Icons.play_circle_fill_rounded, color: Colors.white, size: 32),
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
    if (_beritas.isEmpty) {
      return _GreyContainer(
        child: Text('Belum ada postingan.', style: _bodyStyle()),
      );
    }
    return Column(
      children: _beritas.map((berita) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _PostCard(berita: berita),
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
  final BeritaModel berita;
  const _PostCard({required this.berita});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
          AspectRatio(
            aspectRatio: 16 / 9,
            child: berita.thumbnail != null
                ? Image.network(
                    berita.thumbnail!,
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
                      child: const Icon(Icons.broken_image_outlined,
                          color: Colors.grey, size: 40),
                    ),
                  )
                : Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.image_not_supported_outlined,
                        color: Colors.grey, size: 40),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    berita.title,
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
                  berita.formattedDate,
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
