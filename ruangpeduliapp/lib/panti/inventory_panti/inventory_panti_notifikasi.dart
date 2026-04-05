import 'package:flutter/material.dart';
import 'package:ruangpeduliapp/data/inventory_api.dart';

const Color kPink     = Color(0xFFF28C9F);
const Color kPinkLight = Color(0xFFFDE8EC);
const Color kRed      = Color(0xFFE53935);
const Color kOrange   = Color(0xFFFF8C00);

class InventarisNotifikasiScreen extends StatefulWidget {
  final int? pantiId;
  const InventarisNotifikasiScreen({super.key, this.pantiId});

  @override
  State<InventarisNotifikasiScreen> createState() => _InventarisNotifikasiScreenState();
}

class _InventarisNotifikasiScreenState extends State<InventarisNotifikasiScreen> {
  List<LowStockItemModel> _items = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    if (widget.pantiId == null) {
      if (mounted) setState(() => _loading = false);
      return;
    }
    if (mounted) setState(() { _loading = true; _error = null; });
    try {
      final items = await InventoryApi().fetchLowStockItems(widget.pantiId!);
      if (mounted) setState(() { _items = items; _loading = false; });
    } catch (e) {
      if (mounted) setState(() { _error = e.toString(); _loading = false; });
    }
  }

  List<LowStockItemModel> get _outOfStock   => _items.where((i) => i.isOutOfStock).toList();
  List<LowStockItemModel> get _almostEmpty  => _items.where((i) => !i.isOutOfStock).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1A1A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Notifikasi Inventaris',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF1A1A1A)),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _fetch,
            icon: const Icon(Icons.refresh_rounded, color: Color(0xFF1A1A1A)),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: kPink))
          : _error != null
              ? Center(child: Text(_error!, style: const TextStyle(color: Colors.grey), textAlign: TextAlign.center))
              : _items.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_circle_outline_rounded, color: kPink, size: 48),
                          SizedBox(height: 12),
                          Text('Semua stok aman!', style: TextStyle(fontSize: 15, color: Colors.grey)),
                          SizedBox(height: 4),
                          Text(
                            'Tidak ada produk yang perlu di-restock.',
                            style: TextStyle(fontSize: 13, color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                      children: [
                        // ── Summary banner ──────────────────────────────────
                        _SummaryBanner(
                          outOfStockCount: _outOfStock.length,
                          almostEmptyCount: _almostEmpty.length,
                        ),
                        const SizedBox(height: 16),

                        // ── Habis section ───────────────────────────────────
                        if (_outOfStock.isNotEmpty) ...[
                          _SectionHeader(
                            icon: Icons.cancel_rounded,
                            label: 'Habis (${_outOfStock.length})',
                            color: kRed,
                          ),
                          const SizedBox(height: 8),
                          ..._outOfStock.map((item) => Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: _NotifTile(item: item),
                              )),
                          const SizedBox(height: 12),
                        ],

                        // ── Segera Habis section ────────────────────────────
                        if (_almostEmpty.isNotEmpty) ...[
                          _SectionHeader(
                            icon: Icons.warning_amber_rounded,
                            label: 'Segera Habis (${_almostEmpty.length})',
                            color: kOrange,
                          ),
                          const SizedBox(height: 8),
                          ..._almostEmpty.map((item) => Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: _NotifTile(item: item),
                              )),
                        ],
                      ],
                    ),
    );
  }
}

// ─── Summary Banner ───────────────────────────────────────────────────────────

class _SummaryBanner extends StatelessWidget {
  final int outOfStockCount;
  final int almostEmptyCount;
  const _SummaryBanner({required this.outOfStockCount, required this.almostEmptyCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Expanded(child: _StatChip(count: outOfStockCount, label: 'Habis', color: kRed)),
          Container(width: 1, height: 36, color: const Color(0xFFEEEEEE), margin: const EdgeInsets.symmetric(horizontal: 12)),
          Expanded(child: _StatChip(count: almostEmptyCount, label: 'Segera Habis', color: kOrange)),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final int count;
  final String label;
  final Color color;
  const _StatChip({required this.count, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('$count', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: color)),
        Text(label, style: TextStyle(fontSize: 12, color: color)),
      ],
    );
  }
}

// ─── Section Header ───────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _SectionHeader({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 6),
        Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: color)),
      ],
    );
  }
}

// ─── Notification Tile ────────────────────────────────────────────────────────

class _NotifTile extends StatelessWidget {
  final LowStockItemModel item;
  const _NotifTile({required this.item});

  Color get _color => item.isOutOfStock ? kRed : kOrange;

  String get _badge {
    if (item.isOutOfStock) return 'Habis';
    final d = item.daysUntilEmpty;
    if (d != null) return '~${d.toStringAsFixed(1)} hari';
    return 'Segera Habis';
  }

  String get _subtitle {
    final parts = <String>[];
    parts.add(item.categoryName);
    if (item.dailyUsage != null && item.dailyUsage! > 0) {
      parts.add('PHRR: ${item.dailyUsage} ${item.unit}/hari');
    }
    if (!item.isOutOfStock) {
      parts.add('Sisa: ${item.quantity} ${item.unit}');
    }
    return parts.join(' · ');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: _color.withValues(alpha: 0.1), shape: BoxShape.circle),
            child: Icon(
              item.isOutOfStock ? Icons.inventory_2_outlined : Icons.hourglass_bottom_rounded,
              color: _color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF1A1A1A)),
                ),
                const SizedBox(height: 2),
                Text(_subtitle, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: _color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
            child: Text(_badge, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _color)),
          ),
        ],
      ),
    );
  }
}
