import 'package:flutter/material.dart';
import 'package:ruangpeduliapp/data/finance_api.dart';

// ─── Constants ───────────────────────────────────────────────────────────────

const Color kPink = Color(0xFFF28C9F);
const Color kPinkDark = Color(0xFFE5728A);
const Color kSalmon = Color(0xFFF2C4BC);
const Color kGreen = Color(0xFF2DB34A);
const Color kRed = Color(0xFFE53935);

// ─── Main Page ───────────────────────────────────────────────────────────────

class KeuanganPanti extends StatefulWidget {
  final int? userId;
  const KeuanganPanti({super.key, this.userId});

  @override
  State<KeuanganPanti> createState() => _KeuanganPantiState();
}

class _KeuanganPantiState extends State<KeuanganPanti> {
  bool _balanceVisible = true;

  FinanceDashboard? _dashboard;
  List<TransactionModel> _transactions = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    if (widget.userId == null) return;
    setState(() { _loading = true; _error = null; });
    try {
      final results = await Future.wait([
        FinanceApi().fetchDashboard(widget.userId!),
        FinanceApi().fetchTransactions(widget.userId!),
      ]);
      if (mounted) {
        setState(() {
          _dashboard = results[0] as FinanceDashboard;
          _transactions = results[1] as List<TransactionModel>;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() { _error = e.toString(); _loading = false; });
    }
  }

  String _formatRp(double amount) {
    final formatted = amount.toInt().toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]}.',
        );
    return 'Rp $formatted';
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildDashboardCard(),
            ),
          ],
        ),
        _buildTransactionSection(),
      ],
    );
  }

  // ─── Header ──────────────────────────────────────────────────────────────

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: kPink.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: Icon(Icons.account_balance_wallet_outlined, color: kPink, size: 22),
            ),
          ),
          const SizedBox(width: 10),
          const Text(
            'Keuangan',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1A1A),
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Dashboard Card ───────────────────────────────────────────────────────

  Widget _buildDashboardCard() {
    final pemasukan  = _dashboard != null ? _formatRp(_dashboard!.totalPemasukan)  : 'Rp ——';
    final pengeluaran = _dashboard != null ? _formatRp(_dashboard!.totalPengeluaran) : 'Rp ——';
    final saldo       = _dashboard != null ? _formatRp(_dashboard!.saldo)             : 'Rp ——';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kSalmon,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: kPink.withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Dasbor',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF7A4040)),
              ),
              GestureDetector(
                onTap: () => setState(() => _balanceVisible = !_balanceVisible),
                child: Icon(
                  _balanceVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  color: const Color(0xFF7A4040),
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Pemasukan', style: TextStyle(fontSize: 12, color: Color(0xFF7A4040))),
                      const SizedBox(height: 4),
                      Text(
                        _balanceVisible ? pemasukan : 'Rp ••••••',
                        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: Color(0xFF1A1A1A)),
                      ),
                    ],
                  ),
                ),
                Container(width: 1, color: const Color(0xFFD49090), margin: const EdgeInsets.symmetric(horizontal: 12)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Pengeluaran', style: TextStyle(fontSize: 12, color: Color(0xFF7A4040))),
                      const SizedBox(height: 4),
                      Text(
                        _balanceVisible ? pengeluaran : 'Rp ••••••',
                        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: Color(0xFF1A1A1A)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Saldo', style: TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 4),
                Text(
                  _balanceVisible ? saldo : 'Rp ••••••••',
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF1A1A1A)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Transaction Section ─────────────────────────────────────────────────

  Widget _buildTransactionSection() {
    return DraggableScrollableSheet(
      initialChildSize: 0.42,
      minChildSize: 0.35,
      maxChildSize: 1.0,
      snap: true,
      snapSizes: const [1.0],
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: kPink,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 6),
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Expanded(
                child: _loading
                    ? const Center(child: CircularProgressIndicator(color: Colors.white))
                    : _error != null
                        ? Center(child: Text(_error!, style: const TextStyle(color: Colors.white70), textAlign: TextAlign.center))
                        : _transactions.isEmpty
                            ? const Center(child: Text('Belum ada transaksi.', style: TextStyle(color: Colors.white70)))
                            : ListView.separated(
                                controller: scrollController,
                                padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                                itemCount: _transactions.length,
                                separatorBuilder: (_, __) => const SizedBox(height: 10),
                                itemBuilder: (context, index) =>
                                    _TransactionTile(item: _transactions[index]),
                              ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─── Transaction Tile ─────────────────────────────────────────────────────────

class _TransactionTile extends StatelessWidget {
  final TransactionModel item;
  const _TransactionTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final isIncome  = item.isIncome;
    final typeColor = isIncome ? kGreen : kRed;
    final typeIcon  = isIncome ? Icons.add : Icons.remove;
    final arrowIcon = isIncome ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: typeColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(typeIcon, color: typeColor, size: 18),
          ),
          const SizedBox(width: 10),
          Container(width: 1.5, height: 36, color: Colors.grey[200]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.category,
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Color(0xFF1A1A1A)),
                ),
                const SizedBox(height: 2),
                Text(
                  item.subLabel,
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                item.formattedAmount,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Color(0xFF1A1A1A)),
              ),
              const SizedBox(height: 2),
              Icon(arrowIcon, color: typeColor, size: 16),
            ],
          ),
        ],
      ),
    );
  }
}
