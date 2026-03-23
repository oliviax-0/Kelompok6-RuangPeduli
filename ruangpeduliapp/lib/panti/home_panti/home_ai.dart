import 'package:flutter/material.dart';

// ─── Constants ───────────────────────────────────────────────────────────────

const Color kPink = Color(0xFFF28C9F);
const Color kPinkLight = Color(0xFFFDE8EC);

// ─── Data Model ──────────────────────────────────────────────────────────────

class ChatMessage {
  final String text;
  final bool isUser;
  const ChatMessage({required this.text, required this.isUser});
}

// ─── Screen ───────────────────────────────────────────────────────────────────

class HomeAIPanti extends StatefulWidget {
  const HomeAIPanti({super.key});

  @override
  State<HomeAIPanti> createState() => _HomeAIPantiState();
}

class _HomeAIPantiState extends State<HomeAIPanti> {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<ChatMessage> _messages = [
    const ChatMessage(text: 'Halo! Saya Bobi. Ada yang bisa saya bantu?', isUser: false),
  ];

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() {
    final text = _inputController.text.trim();
    if (text.isEmpty) return;

    setState(() => _messages.add(ChatMessage(text: text, isUser: true)));
    _inputController.clear();
    _scrollToBottom();

    // Simulate AI reply
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      setState(() => _messages.add(const ChatMessage(
        text: 'Terima kasih pertanyaannya! Saya sedang memproses jawaban untuk Anda.',
        isUser: false,
      )));
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPinkLight,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1A1A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'AI Chat Bot',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF1A1A1A)),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Color(0xFF1A1A1A)),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Info Banner ───────────────────────────────────────────────
          _buildInfoBanner(),

          // ── Chat Messages ─────────────────────────────────────────────
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              itemCount: _messages.length,
              itemBuilder: (_, index) => _buildMessageBubble(_messages[index]),
            ),
          ),

          // ── Input Bar ─────────────────────────────────────────────────
          _buildInputBar(),
        ],
      ),
    );
  }

  // ─── Info Banner ──────────────────────────────────────────────────────────

  Widget _buildInfoBanner() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE8EC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kPink.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'AI chatbot adalah program perangkat lunak berbasis kecerdasan buatan (AI) yang mensimulasikan percakapan manusia melalui teks atau suara. Menggunakan Natural Language Processing (NLP), asisten ini memahami konteks, menjawab pertanyaan, dan menyelesaikan tugas otomatis secara real-time.',
              style: TextStyle(fontSize: 11.5, color: Colors.grey[700], height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Message Bubble ───────────────────────────────────────────────────────

  Widget _buildMessageBubble(ChatMessage message) {
    final isUser = message.isUser;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // AI avatar
          if (!isUser)
            Container(
              width: 36,
              height: 36,
              margin: const EdgeInsets.only(right: 8),
              decoration: const BoxDecoration(shape: BoxShape.circle, color: kPink),
              child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 18),
            ),

          // Bubble
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isUser ? kPink : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(isUser ? 18 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 18),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  fontSize: 14,
                  color: isUser ? Colors.white : const Color(0xFF1A1A1A),
                  height: 1.5,
                ),
              ),
            ),
          ),

          // User avatar
          if (isUser)
            Container(
              width: 36,
              height: 36,
              margin: const EdgeInsets.only(left: 8),
              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey[300]),
              child: const Icon(Icons.person_rounded, color: Colors.white, size: 20),
            ),
        ],
      ),
    );
  }

  // ─── Input Bar ────────────────────────────────────────────────────────────

  Widget _buildInputBar() {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Text input + send button
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2F2F2),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextField(
                      controller: _inputController,
                      onSubmitted: (_) => _sendMessage(),
                      style: const TextStyle(fontSize: 14, color: Color(0xFF1A1A1A)),
                      decoration: const InputDecoration(
                        hintText: 'Apa yang bisa bantu?',
                        hintStyle: TextStyle(color: Color(0xFFAAAAAA), fontSize: 14),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: _sendMessage,
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: const BoxDecoration(color: kPink, shape: BoxShape.circle),
                    child: const Icon(Icons.arrow_upward_rounded, color: Colors.white, size: 22),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Bottom icons — image + mic only, NO code/bracket icon
            Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.image_outlined, color: Color(0xFF555555), size: 22),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 16),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.mic_none_rounded, color: Color(0xFF555555), size: 22),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}