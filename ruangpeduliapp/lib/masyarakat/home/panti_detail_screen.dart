import 'package:flutter/material.dart';
import 'package:ruangpeduliapp/data/content_api.dart';
import 'package:ruangpeduliapp/data/profile_api.dart';
import 'package:ruangpeduliapp/masyarakat/home/berita_detail_screen.dart';
import 'package:ruangpeduliapp/masyarakat/home/video_player_screen.dart';
import 'package:ruangpeduliapp/masyarakat/home/kebutuhan_screen.dart';
import 'package:ruangpeduliapp/masyarakat/transaksi/konfirmasi_pembayaran_screen.dart';

// ─────────────────────────────────────────────────────────────
//  PANTI DETAIL SCREEN  (foto ke-3)
//  Dipanggil dari: BeritaDetailScreen → tombol Donasi
// ─────────────────────────────────────────────────────────────
class PantiDetailScreen extends StatefulWidget {
  final int? pantiId;
  final String namaPanti;
  final String username;
  final String nomorPanti;
  final String alamatPanti;
  final String description;
  final String? profilePicture;
  final String terkumpul;
  final int? userId;
  final bool showNavBar;

  // Media foto/video untuk carousel (bisa kosong)
  final List<String> mediaUrls;

  const PantiDetailScreen({
    super.key,
    this.pantiId,
    required this.namaPanti,
    required this.username,
    required this.nomorPanti,
    required this.alamatPanti,
    required this.description,
    this.profilePicture,
    required this.terkumpul,
    this.userId,
    this.showNavBar = true,
    this.mediaUrls = const [],
  });

  @override
  State<PantiDetailScreen> createState() => _PantiDetailScreenState();
}

class _PantiDetailScreenState extends State<PantiDetailScreen> {
  static const Color _btnPink = Color(0xFFF28695);

  List<BeritaModel> _beritas = [];
  bool _loadingBeritas = true;
  List<VideoModel> _videos = [];
  bool _loadingVideos = true;
  List<PantiMediaModel> _media = [];
  late String _terkumpul;

  @override
  void initState() {
    super.initState();
    _terkumpul = widget.terkumpul;
    _fetchContent();
  }

  Future<void> _fetchContent() async {
    if (widget.pantiId == null) {
      setState(() {
        _loadingBeritas = false;
        _loadingVideos = false;
      });
      return;
    }
    final contentApi = ContentApi();
    final profileApi = ProfileApi();
    final results = await Future.wait([
      contentApi.fetchBeritas(pantiId: widget.pantiId).catchError((_) => <BeritaModel>[]),
      contentApi.fetchVideos(pantiId: widget.pantiId).catchError((_) => <VideoModel>[]),
      profileApi.fetchPantiMedia(widget.pantiId!).catchError((_) => <PantiMediaModel>[]),
    ]);
    if (!mounted) return;
    setState(() {
      _beritas = results[0] as List<BeritaModel>;
      _videos = results[1] as List<VideoModel>;
      _media = results[2] as List<PantiMediaModel>;
      _loadingBeritas = false;
      _loadingVideos = false;
    });
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
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Text(
                    'Profil',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back,
                          color: Color(0xFF1A1A1A)),
                    ),
                  ),
                ],
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
                                    pantiId: widget.pantiId,
                                    namaPanti: widget.namaPanti,
                                    username: widget.username,
                                    profilePicture: widget.profilePicture,
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
                              onPressed: () async {
                                final result = await Navigator.push<bool>(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => KonfirmasiPembayaranScreen(
                                      namaPanti: widget.namaPanti,
                                      terkumpul: _terkumpul,
                                      imagePath: widget.profilePicture ?? '',
                                      pantiId: widget.pantiId,
                                      userId: widget.userId,
                                    ),
                                  ),
                                );
                                if (result == true && mounted) {
                                  if (widget.pantiId != null) {
                                    try {
                                      final updated = await ProfileApi().fetchPantiProfile(widget.pantiId!);
                                      if (mounted) setState(() => _terkumpul = updated.formattedTotalTerkumpul);
                                    } catch (_) {}
                                  }
                                  _fetchContent();
                                }
                              },
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

                    // ── Foto ──
                    _SectionLabel('Foto'),
                    const SizedBox(height: 10),
                    _buildFoto(),
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

                    // ── Postingan ──
                    _SectionLabel('Postingan'),
                    const SizedBox(height: 10),
                    _buildPostingan(),
                    const SizedBox(height: 20),

                    // ── Video ──
                    _SectionLabel('Video'),
                    const SizedBox(height: 10),
                    _buildVideos(),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Helpers ──

  Widget _avatarFallback() => Container(
        color: Colors.grey.shade200,
        child: Icon(Icons.business_rounded,
            size: 36, color: Colors.grey.shade400),
      );


  Widget _buildFoto() {
    if (_media.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          height: 60,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text('Belum ada foto.',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
          ),
        ),
      );
    }
    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _media.length,
        itemBuilder: (context, i) {
          final m = _media[i];
          return GestureDetector(
            onTap: m.isVideo && m.videoUrl.isNotEmpty
                ? () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => VideoPlayerScreen(
                          video: VideoModel(
                            id: m.id,
                            title: '',
                            description: '',
                            videoUrl: m.videoUrl,
                            pantiName: '',
                            authorName: '',
                            createdAt: '',
                          ),
                        ),
                      ),
                    )
                : null,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 90,
                  height: 90,
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xFFDDCDD0),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: m.file != null && m.file!.isNotEmpty
                        ? Image.network(
                            m.file!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Icon(
                                m.isVideo ? Icons.videocam_rounded : Icons.image_rounded,
                                color: Colors.grey.shade400),
                          )
                        : Icon(
                            m.isVideo ? Icons.videocam_rounded : Icons.image_rounded,
                            color: Colors.grey.shade400),
                  ),
                ),
                if (m.isVideo)
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.play_arrow_rounded,
                        color: Colors.white, size: 18),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPostingan() {
    if (_loadingBeritas) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }
    if (_beritas.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          height: 80,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text('Belum ada postingan.',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
          ),
        ),
      );
    }
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: _beritas.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, i) {
        final b = _beritas[i];
        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BeritaDetailScreen(
                berita: b,
                userId: widget.userId,
              ),
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(12)),
                  child: b.thumbnail != null && b.thumbnail!.isNotEmpty
                      ? Image.network(
                          b.thumbnail!,
                          width: 90,
                          height: 90,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _thumbnailFallback(),
                        )
                      : _thumbnailFallback(),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          b.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          b.formattedDate,
                          style: TextStyle(
                              fontSize: 11, color: Colors.grey.shade500),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildVideos() {
    if (_loadingVideos) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }
    if (_videos.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          height: 80,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text('Belum ada video.',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
          ),
        ),
      );
    }
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: _videos.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, i) {
        final v = _videos[i];
        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => VideoPlayerScreen(video: v)),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.horizontal(
                          left: Radius.circular(12)),
                      child: v.thumbnail != null && v.thumbnail!.isNotEmpty
                          ? Image.network(
                              v.thumbnail!,
                              width: 90,
                              height: 90,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => _thumbnailFallback(),
                            )
                          : _thumbnailFallback(),
                    ),
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.play_arrow_rounded,
                          color: Colors.white, size: 20),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          v.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                        if (v.description.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            v.description,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 11, color: Colors.grey.shade500),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _thumbnailFallback() {
    return Container(
      width: 90,
      height: 90,
      color: const Color(0xFFDDCDD0),
      child: Icon(Icons.newspaper_rounded,
          size: 28, color: Colors.grey.shade400),
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
