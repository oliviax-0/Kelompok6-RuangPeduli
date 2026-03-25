import 'package:flutter/material.dart';
import 'package:ruangpeduliapp/data/inventory_api.dart';

const Color kPink = Color(0xFFF28C9F);
const Color kPinkLight = Color(0xFFFDE8EC);
const Color kRed = Color(0xFFE53935);

class InventarisNotifikasiScreen extends StatefulWidget {
  final int? pantiId;
  const InventarisNotifikasiScreen({super.key, this.pantiId});

  @override
  State<InventarisNotifikasiScreen> createState() => _InventarisNotifikasiScreenState();
}

class _InventarisNotifikasiScreenState extends State<InventarisNotifikasiScreen> {
  List<OutOfStockItemModel> _items = [];
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
      final items = await InventoryApi().fetchOutOfStockItems(widget.pantiId!);
      if (mounted) setState(() { _items = items; _loading = false; });
    } catch (e) {
      if (mounted) setState(() { _error = e.toString(); _loading = false; });
    }
  }

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
                          Text('Semua stok tersedia!', style: TextStyle(fontSize: 15, color: Colors.grey)),
                        ],
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
                          child: Row(
                            children: [
                              const Icon(Icons.warning_amber_rounded, color: kRed, size: 18),
                              const SizedBox(width: 6),
                              Text(
                                '${_items.length} produk habis',
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: kRed),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView.separated(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                            itemCount: _items.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 8),
                            itemBuilder: (_, index) => _NotifTile(item: _items[index]),
                          ),
                        ),
                      ],
                    ),
    );
  }
}

class _NotifTile extends StatelessWidget {
  final OutOfStockItemModel item;
  const _NotifTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 6, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: kRed.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.inventory_2_outlined, color: kRed, size: 20),
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
                Text(
                  item.categoryName,
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: kRed.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Habis',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: kRed),
            ),
          ),
        ],
      ),
    );
  }
}
