import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:ruangpeduliapp/data/profile_api.dart';

// ─── Constants ────────────────────────────────────────────────────────────────

const Color _kPink = Color(0xFFF47B8C);
const Color _kPinkLight = Color(0xFFFDE8EC);
const String _groqUrl = 'https://api.groq.com/openai/v1/chat/completions';
const String _model = 'llama-3.3-70b-versatile';

// ─── Model ────────────────────────────────────────────────────────────────────

class _ChatMsg {
  final String text;
  final bool isUser;
  const _ChatMsg({required this.text, required this.isUser});
}

// ─── Screen ───────────────────────────────────────────────────────────────────

class ChatbotMasyarakatScreen extends StatefulWidget {
  final int? userId;
  const ChatbotMasyarakatScreen({super.key, this.userId});

  @override
  State<ChatbotMasyarakatScreen> createState() =>
      _ChatbotMasyarakatScreenState();
}

class _ChatbotMasyarakatScreenState extends State<ChatbotMasyarakatScreen> {
  final _inputCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  bool _isLoading = false;
  bool _loadingContext = true;

  final List<Map<String, String>> _history = [];

  final _picker = ImagePicker();
  final _stt = SpeechToText();
  bool _sttReady = false;
  bool _listening = false;

  final List<_ChatMsg> _messages = [
    const _ChatMsg(
      text: 'Halo 👋\n'
          'Terima kasih atas niat baik Anda untuk membantu.\n'
          'Saya dapat membantu menunjukkan kebutuhan paling mendesak dari panti yang membutuhkan saat ini.\n'
          'Apakah Anda ingin mengetahui kebutuhan prioritas sekarang?',
      isUser: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initContext();
    _stt.initialize(
      onStatus: (s) {
        if ((s == 'done' || s == 'notListening') && mounted) {
          setState(() => _listening = false);
        }
      },
      onError: (_) { if (mounted) setState(() => _listening = false); },
    ).then((ok) { if (mounted) setState(() => _sttReady = ok); });
  }

  Future<void> _initContext() async {
    final buffer = StringBuffer();
    buffer.writeln(
      'Kamu adalah asisten AI untuk aplikasi RuangPeduli, platform donasi panti asuhan di Indonesia. '
      'Tugasmu adalah membantu donatur (masyarakat umum) mengetahui kebutuhan paling mendesak di panti asuhan '
      'agar bantuan dapat disalurkan secara tepat sasaran. '
      'Jawab dalam Bahasa Indonesia yang ramah, hangat, dan informatif. '
      'Jangan gunakan tabel kecuali diminta. Fokus pada kebutuhan prioritas penghuni.',
    );

    try {
      final pantiList = await ProfileApi().fetchAllPanti();
      if (pantiList.isNotEmpty) {
        buffer.writeln('\n=== DATA PANTI ASUHAN YANG TERDAFTAR ===');
        for (final p in pantiList) {
          buffer.writeln('- ${p.namaPanti} | Lokasi: ${p.alamatPanti} | Telp: ${p.nomorPanti} | Dana terkumpul: ${p.formattedTotalTerkumpul}');
        }
      }
    } catch (_) {}

    _history.add({'role': 'system', 'content': buffer.toString()});
    if (mounted) setState(() => _loadingContext = false);
  }

  Future<void> _pickImage() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2)),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const CircleAvatar(
                    backgroundColor: _kPinkLight,
                    child: Icon(Icons.camera_alt_rounded, color: _kPink)),
                title: const Text('Ambil Foto',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
              ListTile(
                leading: const CircleAvatar(
                    backgroundColor: _kPinkLight,
                    child: Icon(Icons.photo_library_rounded, color: _kPink)),
                title: const Text('Pilih dari Album',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
            ],
          ),
        ),
      ),
    );
    if (source == null || !mounted) return;
    final picked = await _picker.pickImage(source: source, imageQuality: 80);
    if (picked == null || !mounted) return;
    _history.add({'role': 'user', 'content': '[Pengguna mengirim gambar]'});
    _scrollToBottom();
  }

  Future<void> _toggleMic() async {
    if (!_sttReady) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mikrofon tidak tersedia')),
      );
      return;
    }
    if (_listening) {
      await _stt.stop();
      setState(() => _listening = false);
      return;
    }
    final locales = await _stt.locales();
    String? localeId;
    for (final l in locales) {
      if (l.localeId.startsWith('id')) { localeId = l.localeId; break; }
    }
    setState(() { _listening = true; _inputCtrl.clear(); });
    await _stt.listen(
      onResult: (result) {
        if (!mounted) return;
        setState(() => _inputCtrl.text = result.recognizedWords);
        if (result.finalResult) setState(() => _listening = false);
      },
      listenFor: const Duration(seconds: 10),
      pauseFor: const Duration(seconds: 3),
      localeId: localeId,
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    final text = _inputCtrl.text.trim();
    if (text.isEmpty || _isLoading || _loadingContext) return;

    setState(() {
      _messages.add(_ChatMsg(text: text, isUser: true));
      _isLoading = true;
    });
    _inputCtrl.clear();
    _history.add({'role': 'user', 'content': text});
    _scrollToBottom();

    try {
      final apiKey = dotenv.env['GROQ_API_KEY'] ?? '';
      if (apiKey.isEmpty || apiKey == 'your_groq_api_key_here') {
        throw Exception('GROQ_API_KEY belum diisi di file .env');
      }

      final res = await http.post(
        Uri.parse(_groqUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': _model,
          'messages': _history,
          'temperature': 0.7,
          'max_tokens': 1024,
        }),
      ).timeout(const Duration(seconds: 30));

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final reply = data['choices'][0]['message']['content'] as String;
        _history.add({'role': 'assistant', 'content': reply});
        if (!mounted) return;
        setState(() => _messages.add(_ChatMsg(text: reply, isUser: false)));
      } else {
        final err = jsonDecode(res.body);
        throw Exception(err['error']?['message'] ?? 'Status ${res.statusCode}');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _messages.add(_ChatMsg(text: 'Error: $e', isUser: false)));
    } finally {
      if (mounted) setState(() => _isLoading = false);
      _scrollToBottom();
    }
  }

  void _copyMessage(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Pesan disalin'),
        duration: Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    _inputCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kPinkLight,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildInfoBanner(),
            Expanded(
              child: SelectionArea(
                child: ListView.builder(
                  controller: _scrollCtrl,
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                  itemCount: _messages.length + (_isLoading ? 1 : 0),
                  itemBuilder: (_, i) {
                    if (i == _messages.length) return _buildTypingIndicator();
                    return _buildBubble(_messages[i]);
                  },
                ),
              ),
            ),
            _buildInputBar(),
          ],
        ),
      ),
    );
  }

  // ── Header ─────────────────────────────────────────────────────────────────

  Widget _buildHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'AI Chat Bot',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1A1A1A),
              ),
            ),
          ),
          if (_loadingContext)
            const Padding(
              padding: EdgeInsets.only(right: 12),
              child: SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: _kPink),
              ),
            ),
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: const Icon(Icons.close_rounded,
                size: 24, color: Color(0xFF1A1A1A)),
          ),
        ],
      ),
    );
  }

  // ── Info banner ────────────────────────────────────────────────────────────

  Widget _buildInfoBanner() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE8EC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _kPink.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _loadingContext
                  ? 'Memuat data panti asuhan...'
                  : 'AI ini adalah asisten informasi yang membantu donatur mengetahui kebutuhan paling mendesak di panti secara cepat dan akurat. Melalui percakapan singkat, AI akan memberikan informasi terkini mengenai kebutuhan prioritas penghuni, sehingga bantuan dapat disalurkan secara tepat sasaran.',
              style: TextStyle(
                  fontSize: 11.5, color: Colors.grey[700], height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  // ── Typing indicator ───────────────────────────────────────────────────────

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _BotAvatar(),
          const SizedBox(width: 8),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
                bottomRight: Radius.circular(18),
                bottomLeft: Radius.circular(4),
              ),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 6,
                    offset: const Offset(0, 2))
              ],
            ),
            child: const SizedBox(
                width: 40, height: 16, child: _TypingDots()),
          ),
        ],
      ),
    );
  }

  // ── Message bubble ─────────────────────────────────────────────────────────

  Widget _buildBubble(_ChatMsg msg) {
    final isUser = msg.isUser;
    final copyBtn = GestureDetector(
      onTap: () => _copyMessage(msg.text),
      child: Padding(
        padding: EdgeInsets.only(
            left: isUser ? 0 : 4, right: isUser ? 4 : 0, bottom: 2),
        child: Icon(Icons.copy_rounded, size: 15, color: Colors.grey[400]),
      ),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[_BotAvatar(), const SizedBox(width: 8)],
          if (isUser) copyBtn,
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isUser ? _kPink : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(isUser ? 18 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 18),
                ),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 6,
                      offset: const Offset(0, 2))
                ],
              ),
              child: isUser
                  ? Text(msg.text,
                      style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          height: 1.5))
                  : MarkdownBody(
                      data: msg.text,
                      styleSheet: MarkdownStyleSheet(
                        p: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF1A1A1A),
                            height: 1.5),
                        strong: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF1A1A1A),
                            fontWeight: FontWeight.w700),
                        listBullet: const TextStyle(
                            fontSize: 14, color: Color(0xFF1A1A1A)),
                      ),
                    ),
            ),
          ),
          if (!isUser) copyBtn,
          if (isUser) ...[
            const SizedBox(width: 8),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Colors.grey[300]),
              child: const Icon(Icons.person_rounded,
                  color: Colors.white, size: 20),
            ),
          ],
        ],
      ),
    );
  }

  // ── Input bar ──────────────────────────────────────────────────────────────

  Widget _buildInputBar() {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Text field + send button
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2F2F2),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextField(
                      controller: _inputCtrl,
                      onSubmitted: (_) => _sendMessage(),
                      enabled: !_isLoading && !_loadingContext,
                      maxLines: null,
                      style: const TextStyle(
                          fontSize: 14, color: Color(0xFF1A1A1A)),
                      decoration: InputDecoration(
                        hintText: _loadingContext
                            ? 'Memuat data...'
                            : 'Apa yang bisa bantu?',
                        hintStyle: const TextStyle(
                            color: Color(0xFFAAAAAA), fontSize: 14),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: (_isLoading || _loadingContext) ? null : _sendMessage,
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: (_isLoading || _loadingContext)
                          ? _kPink.withValues(alpha: 0.5)
                          : _kPink,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_upward_rounded,
                        color: Colors.white, size: 22),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Action icons row
            Row(
              children: [
                _ActionIcon(
                  icon: Icons.image_outlined,
                  onTap: _pickImage,
                ),
                const SizedBox(width: 16),
                _ActionIcon(
                  icon: Icons.code_rounded,
                  onTap: () {},
                ),
                const SizedBox(width: 16),
                _ActionIcon(
                  icon: _listening
                      ? Icons.mic_rounded
                      : Icons.mic_none_rounded,
                  color: _listening ? _kPink : const Color(0xFF555555),
                  onTap: _toggleMic,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Bot Avatar ───────────────────────────────────────────────────────────────

class _BotAvatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Image.asset(
        'assets/images/chatbot_ai.png',
        width: 36,
        height: 36,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          width: 36,
          height: 36,
          decoration:
              const BoxDecoration(shape: BoxShape.circle, color: _kPink),
          child: const Icon(Icons.auto_awesome_rounded,
              color: Colors.white, size: 18),
        ),
      ),
    );
  }
}

// ─── Action Icon ──────────────────────────────────────────────────────────────

class _ActionIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionIcon({
    required this.icon,
    this.color = const Color(0xFF555555),
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(icon, color: color, size: 22),
    );
  }
}

// ─── Typing Dots ──────────────────────────────────────────────────────────────

class _TypingDots extends StatefulWidget {
  const _TypingDots();

  @override
  State<_TypingDots> createState() => _TypingDotsState();
}

class _TypingDotsState extends State<_TypingDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900))
      ..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) {
        final t = _ctrl.value;
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (i) {
            final opacity = ((t * 3 - i) % 1.0).clamp(0.0, 1.0);
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _kPink.withValues(alpha: 0.3 + opacity * 0.7),
              ),
            );
          }),
        );
      },
    );
  }
}
