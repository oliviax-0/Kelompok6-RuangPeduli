import 'package:flutter/material.dart';

// ─── Constants ───────────────────────────────────────────────────────────────

const Color kPink = Color(0xFFF28C9F);

// ─── Public helpers — call these from profile_panti.dart ─────────────────────

void showAlamatPopup(BuildContext context, {String initialValue = ''}) {
  showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.4),
    builder: (_) => _AlamatDialog(initialValue: initialValue),
  );
}

void showDeskripsiPopup(BuildContext context, {String initialValue = ''}) {
  showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.4),
    builder: (_) => _DeskripsiDialog(initialValue: initialValue),
  );
}

void showFotoVideoPopup(BuildContext context) {
  showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.4),
    builder: (_) => const _FotoVideoDialog(),
  );
}

// ─── Shared Widgets ───────────────────────────────────────────────────────────

/// Base popup shell — white card, rounded, with title + child + Simpan button
class _PopupShell extends StatelessWidget {
  final String title;
  final Widget content;
  final VoidCallback onSave;

  const _PopupShell({
    required this.title,
    required this.content,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 16),

            // Content
            content,
            const SizedBox(height: 20),

            // Simpan button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPink,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Simpan',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shared multi-line text field used by Alamat and Deskripsi
Widget _buildMultilineField({
  required TextEditingController controller,
  required String hint,
  int maxLines = 7,
}) {
  return Container(
    decoration: BoxDecoration(
      color: const Color(0xFFF2F2F2),
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: const Color(0xFFDDDDDD)),
    ),
    child: TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(fontSize: 13.5, color: Color(0xFF1A1A1A)),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFFAAAAAA), fontSize: 13.5),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.all(14),
      ),
    ),
  );
}

// ─── Alamat Dialog ────────────────────────────────────────────────────────────

class _AlamatDialog extends StatefulWidget {
  final String initialValue;
  const _AlamatDialog({this.initialValue = ''});

  @override
  State<_AlamatDialog> createState() => _AlamatDialogState();
}

class _AlamatDialogState extends State<_AlamatDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _PopupShell(
      title: 'Alamat',
      content: _buildMultilineField(
        controller: _controller,
        hint:
            'Jalan Edu City Kavling Edu I No. 10, Jalan BSD Raya Barat Laut 1, Serpong, Pagedangan, Kabupaten Tangerang, Banten 15339',
        maxLines: 6,
      ),
      onSave: () => Navigator.pop(context),
    );
  }
}

// ─── Deskripsi Dialog ─────────────────────────────────────────────────────────

class _DeskripsiDialog extends StatefulWidget {
  final String initialValue;
  const _DeskripsiDialog({this.initialValue = ''});

  @override
  State<_DeskripsiDialog> createState() => _DeskripsiDialogState();
}

class _DeskripsiDialogState extends State<_DeskripsiDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _PopupShell(
      title: 'Deskripsi',
      content: _buildMultilineField(
        controller: _controller,
        hint:
            'Panti Asuhan Kasih Muliah hadir sejak tahun 1947. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum quis est porttitor erat gravida ultricies. Vivamus sit amet nulla ipsum. Aliquam ac euismod ex.',
        maxLines: 7,
      ),
      onSave: () => Navigator.pop(context),
    );
  }
}

// ─── Foto & Video Dialog ──────────────────────────────────────────────────────

class _MediaItem {
  final String url;
  final bool isVideo;
  const _MediaItem(this.url, {this.isVideo = false});
}

const List<_MediaItem> _sampleMedia = [
  _MediaItem('https://images.unsplash.com/photo-1509062522246-3755977927d7?w=400&q=80'),
  _MediaItem('https://images.unsplash.com/photo-1488521787991-ed7bbaae773c?w=400&q=80'),
  _MediaItem('https://images.unsplash.com/photo-1503676260728-1c00da094a0b?w=400&q=80', isVideo: true),
  _MediaItem('https://images.unsplash.com/photo-1529390079861-591de354faf5?w=400&q=80'),
];

class _FotoVideoDialog extends StatelessWidget {
  const _FotoVideoDialog();

  @override
  Widget build(BuildContext context) {
    return _PopupShell(
      title: 'Foto & Video',
      content: Column(
        children: [
          // Upload button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: kPink.withOpacity(0.18),
                foregroundColor: const Color(0xFFD0607A),
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Unggah Foto atau Video',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Media grid
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            children: _sampleMedia.map((item) => _MediaTile(item: item)).toList(),
          ),
        ],
      ),
      onSave: () => Navigator.pop(context),
    );
  }
}

class _MediaTile extends StatelessWidget {
  final _MediaItem item;
  const _MediaTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            item.url,
            fit: BoxFit.cover,
            loadingBuilder: (_, child, progress) => progress == null
                ? child
                : Container(
                    color: const Color(0xFFE0E0E0),
                    child: const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(kPink),
                      ),
                    ),
                  ),
            errorBuilder: (_, __, ___) => Container(
              color: const Color(0xFFE0E0E0),
              child: const Icon(Icons.broken_image_outlined, color: Colors.grey),
            ),
          ),
          if (item.isVideo)
            Container(
              color: Colors.black.withOpacity(0.22),
              child: const Center(
                child: CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.play_arrow_rounded, color: Color(0xFF1A1A1A), size: 26),
                ),
              ),
            ),
        ],
      ),
    );
  }
}