import 'package:flutter/material.dart';
import 'package:ruangpeduliapp/data/content_api.dart';
import 'package:ruangpeduliapp/masyarakat/transaksi/konfirmasi_pembayaran_screen.dart';

class BeritaDetailScreen extends StatelessWidget {
  final BeritaModel berita;

  const BeritaDetailScreen({super.key, required this.berita});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF1A1A1A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Berita',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A1A),
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Thumbnail ──
            _buildThumbnail(),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Title ──
                  Text(
                    berita.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // ── Panti row ──
                  Row(
                    children: [
                      _pantiAvatar(),
                      const SizedBox(width: 10),
                      Text(
                        berita.pantiName,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // ── Content ──
                  Text(
                    berita.content,
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF333333),
                      height: 1.7,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // ── Donasi button ──
                  Center(
                    child: SizedBox(
                      width: 200,
                      height: 46,
                      child: ElevatedButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => KonfirmasiPembayaranScreen(
                              namaPanti: berita.pantiName,
                              terkumpul: '',
                              imagePath: berita.pantiProfilePicture ?? '',
                            ),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE8848A),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        child: const Text(
                          'Donasi',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnail() {
    if (berita.thumbnail != null && berita.thumbnail!.isNotEmpty) {
      return Image.network(
        berita.thumbnail!,
        width: double.infinity,
        height: 220,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _placeholderThumbnail(),
      );
    }
    return _placeholderThumbnail();
  }

  Widget _placeholderThumbnail() {
    return Container(
      width: double.infinity,
      height: 220,
      color: const Color(0xFFCFBFC2),
      child: const Center(
        child: Icon(Icons.image_rounded, size: 56, color: Colors.white54),
      ),
    );
  }

  Widget _pantiAvatar() {
    if (berita.pantiProfilePicture != null &&
        berita.pantiProfilePicture!.isNotEmpty) {
      return ClipOval(
        child: Image.network(
          berita.pantiProfilePicture!,
          width: 36,
          height: 36,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _defaultPantiIcon(),
        ),
      );
    }
    return _defaultPantiIcon();
  }

  Widget _defaultPantiIcon() {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: const Color(0xFFF43D5E).withValues(alpha: 0.12),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.home_work_rounded,
        size: 20,
        color: Color(0xFFF43D5E),
      ),
    );
  }
}
