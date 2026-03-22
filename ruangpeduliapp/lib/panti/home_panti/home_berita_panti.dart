import 'package:flutter/material.dart';

// ─── Constants ───────────────────────────────────────────────────────────────

const Color kPink = Color(0xFFF28C9F);
const Color kSalmon = Color(0xFFEBB9B1);

// ─── Main Screen ──────────────────────────────────────────────────────────────

class BeritaDetailPanti extends StatefulWidget {
  final String title;
  final String imageUrl;
  final String date;
  final String authorName;
  final String pantiName;
  final String body;

  const BeritaDetailPanti({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.date,
    required this.authorName,
    required this.pantiName,
    required this.body,
  });

  @override
  State<BeritaDetailPanti> createState() => _BeritaDetailPantiState();
}

class _BeritaDetailPantiState extends State<BeritaDetailPanti> {
  int _upvotes = 25;
  int _downvotes = 0;
  bool _hasUpvoted = false;
  bool _hasDownvoted = false;

  void _onUpvote() {
    setState(() {
      if (_hasUpvoted) {
        _upvotes--;
        _hasUpvoted = false;
      } else {
        _upvotes++;
        _hasUpvoted = true;
        if (_hasDownvoted) {
          _downvotes--;
          _hasDownvoted = false;
        }
      }
    });
  }

  void _onDownvote() {
    setState(() {
      if (_hasDownvoted) {
        _downvotes--;
        _hasDownvoted = false;
      } else {
        _downvotes++;
        _hasDownvoted = true;
        if (_hasUpvoted) {
          _upvotes--;
          _hasUpvoted = false;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1A1A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Berita',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1A1A1A),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Article Title ────────────────────────────────────────────
            Text(
              widget.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1A1A1A),
                height: 1.35,
              ),
            ),
            const SizedBox(height: 16),

            // ── Featured Image ───────────────────────────────────────────
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: AspectRatio(
                aspectRatio: 16 / 10,
                child: Image.network(
                  widget.imageUrl,
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
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ── Body Text ────────────────────────────────────────────────
            Text(
              widget.body,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF333333),
                height: 1.65,
              ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 20),

            // ── Author Card + Voting ──────────────────────────────────────
            _buildAuthorVoting(),
            const SizedBox(height: 28),
          ],
        ),
      ),
    );
  }

  // ─── Author Card + Voting ─────────────────────────────────────────────────

  Widget _buildAuthorVoting() {
    return Column(
      children: [
        // Author card
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: kSalmon,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              // Avatar
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  image: const DecorationImage(
                    image: NetworkImage(
                      'https://images.unsplash.com/photo-1509062522246-3755977927d7?w=200&q=80',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Text info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.pantiName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.authorName,
                      style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
              // Date
              Text(
                widget.date,
                style: TextStyle(fontSize: 12, color: Colors.grey[700]),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),

        // Voting row
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Downvote
            _VoteButton(
              icon: _hasDownvoted ? Icons.arrow_downward_rounded : Icons.arrow_downward_outlined,
              count: _downvotes,
              active: _hasDownvoted,
              activeColor: kPink,
              onTap: _onDownvote,
            ),
            const SizedBox(width: 16),
            // Upvote
            _VoteButton(
              icon: _hasUpvoted ? Icons.arrow_upward_rounded : Icons.arrow_upward_outlined,
              count: _upvotes,
              active: _hasUpvoted,
              activeColor: kPink,
              onTap: _onUpvote,
            ),
          ],
        ),
      ],
    );
  }
}

// ─── Vote Button ──────────────────────────────────────────────────────────────

class _VoteButton extends StatelessWidget {
  final IconData icon;
  final int count;
  final bool active;
  final Color activeColor;
  final VoidCallback onTap;

  const _VoteButton({
    required this.icon,
    required this.count,
    required this.active,
    required this.activeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = active ? activeColor : const Color(0xFF888888);
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            transitionBuilder: (child, animation) =>
                ScaleTransition(scale: animation, child: child),
            child: Icon(icon, key: ValueKey(active), color: color, size: 22),
          ),
          const SizedBox(width: 4),
          Text(
            '$count',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Recommendation Card ──────────────────────────────────────────────────────

// Note: Recommendation section removed for simplicity. Can be re-added later if needed.