import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ruangpeduliapp/data/profile_api.dart';

// ─── Constants ───────────────────────────────────────────────────────────────

const Color kPink = Color(0xFFF28C9F);

// ─── Public helpers ───────────────────────────────────────────────────────────

/// Returns the saved alamat string, or null if cancelled.
Future<String?> showAlamatPopup(
  BuildContext context, {
  required int pantiId,
  String initialValue = '',
}) {
  return showDialog<String>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.4),
    builder: (_) => _AlamatDialog(pantiId: pantiId, initialValue: initialValue),
  );
}

/// Returns the saved deskripsi string, or null if cancelled.
Future<String?> showDeskripsiPopup(
  BuildContext context, {
  required int pantiId,
  String initialValue = '',
}) {
  return showDialog<String>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.4),
    builder: (_) =>
        _DeskripsiDialog(pantiId: pantiId, initialValue: initialValue),
  );
}

/// Returns the updated media list, or null if cancelled.
Future<List<PantiMediaModel>?> showFotoVideoPopup(
  BuildContext context, {
  required int pantiId,
  required List<PantiMediaModel> media,
}) {
  return showDialog<List<PantiMediaModel>>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.4),
    builder: (_) => _FotoVideoDialog(pantiId: pantiId, initialMedia: media),
  );
}

// ─── Shared Widgets ───────────────────────────────────────────────────────────

class _PopupShell extends StatelessWidget {
  final String title;
  final Widget content;
  final VoidCallback onSave;
  final bool isSaving;

  const _PopupShell({
    required this.title,
    required this.content,
    required this.onSave,
    this.isSaving = false,
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
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 16),
            content,
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isSaving ? null : onSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPink,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: kPink.withValues(alpha: 0.5),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: isSaving
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        'Simpan',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w700),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
        hintStyle:
            const TextStyle(color: Color(0xFFAAAAAA), fontSize: 13.5),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.all(14),
      ),
    ),
  );
}

// ─── Alamat Dialog ────────────────────────────────────────────────────────────

class _AlamatDialog extends StatefulWidget {
  final int pantiId;
  final String initialValue;
  const _AlamatDialog({required this.pantiId, this.initialValue = ''});

  @override
  State<_AlamatDialog> createState() => _AlamatDialogState();
}

class _AlamatDialogState extends State<_AlamatDialog> {
  late final TextEditingController _controller;
  bool _isSaving = false;

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

  Future<void> _save() async {
    final value = _controller.text.trim();
    setState(() => _isSaving = true);
    try {
      await ProfileApi().updatePantiProfile(
        widget.pantiId,
        alamatPanti: value,
      );
      if (!mounted) return;
      Navigator.pop(context, value);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _PopupShell(
      title: 'Alamat',
      isSaving: _isSaving,
      content: _buildMultilineField(
        controller: _controller,
        hint: 'Masukkan alamat panti...',
        maxLines: 6,
      ),
      onSave: _save,
    );
  }
}

// ─── Deskripsi Dialog ─────────────────────────────────────────────────────────

class _DeskripsiDialog extends StatefulWidget {
  final int pantiId;
  final String initialValue;
  const _DeskripsiDialog({required this.pantiId, this.initialValue = ''});

  @override
  State<_DeskripsiDialog> createState() => _DeskripsiDialogState();
}

class _DeskripsiDialogState extends State<_DeskripsiDialog> {
  late final TextEditingController _controller;
  bool _isSaving = false;

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

  Future<void> _save() async {
    final value = _controller.text.trim();
    setState(() => _isSaving = true);
    try {
      await ProfileApi().updatePantiProfile(
        widget.pantiId,
        description: value,
      );
      if (!mounted) return;
      Navigator.pop(context, value);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _PopupShell(
      title: 'Deskripsi',
      isSaving: _isSaving,
      content: _buildMultilineField(
        controller: _controller,
        hint: 'Tulis deskripsi panti...',
        maxLines: 7,
      ),
      onSave: _save,
    );
  }
}

// ─── Foto & Video Dialog ──────────────────────────────────────────────────────

class _FotoVideoDialog extends StatefulWidget {
  final int pantiId;
  final List<PantiMediaModel> initialMedia;
  const _FotoVideoDialog(
      {required this.pantiId, required this.initialMedia});

  @override
  State<_FotoVideoDialog> createState() => _FotoVideoDialogState();
}

class _FotoVideoDialogState extends State<_FotoVideoDialog> {
  late List<PantiMediaModel> _media;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _media = List.from(widget.initialMedia);
  }

  static const _videoExtensions = {
    'mp4', 'mov', 'avi', 'mkv', 'webm', 'flv', '3gp', 'm4v',
  };

  Future<void> _pickAndUpload() async {
    final picker = ImagePicker();
    final XFile? picked = await picker.pickMedia();
    if (picked == null) return;
    final ext = picked.path.split('.').last.toLowerCase();
    final mediaType = _videoExtensions.contains(ext) ? 'video' : 'photo';
    await _doUpload(File(picked.path), mediaType);
  }

  Future<void> _doUpload(File file, String mediaType) async {
    setState(() => _isUploading = true);
    try {
      final newMedia = await ProfileApi().uploadPantiMedia(
        widget.pantiId,
        file: file,
        mediaType: mediaType,
        order: _media.length,
      );
      setState(() => _media.add(newMedia));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  Future<void> _delete(PantiMediaModel item) async {
    try {
      await ProfileApi().deletePantiMedia(widget.pantiId, item.id);
      setState(() => _media.removeWhere((m) => m.id == item.id));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return _PopupShell(
      title: 'Foto & Video',
      content: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _isUploading ? null : _pickAndUpload,
              icon: const Icon(Icons.perm_media_rounded, size: 18),
              label: const Text(
                'Unggah Foto / Video',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: kPink.withValues(alpha: 0.18),
                foregroundColor: const Color(0xFFD0607A),
                disabledBackgroundColor: kPink.withValues(alpha: 0.08),
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
          if (_isUploading) ...[
            const SizedBox(height: 10),
            const LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(kPink),
              backgroundColor: Color(0xFFFFE0E6),
            ),
          ],
          const SizedBox(height: 14),
          if (_media.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                'Belum ada foto & video.',
                style: TextStyle(
                    fontSize: 13.5, color: Colors.grey[500]),
              ),
            )
          else
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              children: _media
                  .map((item) => _MediaTile(
                        item: item,
                        onDelete: () => _delete(item),
                      ))
                  .toList(),
            ),
        ],
      ),
      onSave: () => Navigator.pop(context, _media),
    );
  }
}

class _MediaTile extends StatelessWidget {
  final PantiMediaModel item;
  final VoidCallback onDelete;
  const _MediaTile({required this.item, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background: video placeholder OR photo
          if (item.isVideo)
            Container(
              color: const Color(0xFF1A1A2E),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.videocam_rounded, color: Colors.white54, size: 36),
                  SizedBox(height: 4),
                  Text(
                    'Video',
                    style: TextStyle(color: Colors.white54, fontSize: 11),
                  ),
                ],
              ),
            )
          else if (item.file != null)
            Image.network(
              item.file!,
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
                child: const Icon(Icons.broken_image_outlined,
                    color: Colors.grey),
              ),
            )
          else
            Container(
              color: const Color(0xFFE0E0E0),
              child: const Icon(Icons.image_not_supported_outlined,
                  color: Colors.grey),
            ),
          // Play overlay for video
          if (item.isVideo)
            const Center(
              child: CircleAvatar(
                radius: 22,
                backgroundColor: Colors.white24,
                child: Icon(Icons.play_arrow_rounded,
                    color: Colors.white, size: 26),
              ),
            ),
          // Delete button
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: onDelete,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.55),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close_rounded,
                    color: Colors.white, size: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
