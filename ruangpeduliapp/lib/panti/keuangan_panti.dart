import 'package:flutter/material.dart';

// ─── Constants ───────────────────────────────────────────────────────────────

const Color kPink = Color(0xFFF28C9F);
const Color kPinkDark = Color(0xFFE5728A);
const Color kSalmon = Color(0xFFF2C4BC);
const Color kGreen = Color(0xFF2DB34A);
const Color kRed = Color(0xFFE53935);

// ─── Data Model ──────────────────────────────────────────────────────────────

enum TransactionType { income, expense }

class TransactionItem {
  final String category;
  final String subLabel;
  final String amount;
  final TransactionType type;

  const TransactionItem({
    required this.category,
    required this.subLabel,
    required this.amount,
    required this.type,
  });
}

final List<TransactionItem> _transactions = [
  TransactionItem(category: 'Donasi', subLabel: 'Donasi A', amount: 'Rp 15.000', type: TransactionType.income),
  TransactionItem(category: 'Furnitur', subLabel: 'Jendela Lobby', amount: 'Rp 10.000', type: TransactionType.expense),
  TransactionItem(category: 'Donasi', subLabel: 'Donasi B', amount: 'Rp 15.000', type: TransactionType.income),
  TransactionItem(category: 'Bahan Pokok', subLabel: 'Beras', amount: 'Rp 10.000', type: TransactionType.expense),
  TransactionItem(category: 'Penjualan', subLabel: 'Kerajinan tangan', amount: 'Rp 15.000', type: TransactionType.income),
  TransactionItem(category: 'Bahan Pokok', subLabel: 'Tahu', amount: '-3kg', type: TransactionType.expense),
  TransactionItem(category: 'Donasi', subLabel: 'Donasi A', amount: 'Rp 15.000', type: TransactionType.income),
  TransactionItem(category: 'Bahan Pokok', subLabel: 'Minyak Goreng', amount: 'Rp 10.000', type: TransactionType.expense),
  TransactionItem(category: 'Donasi', subLabel: 'Donasi C', amount: 'Rp 15.000', type: TransactionType.income),
  TransactionItem(category: 'Obat-obatan', subLabel: 'Obat Pilek', amount: 'Rp 10.000', type: TransactionType.expense),
  TransactionItem(category: 'Donasi', subLabel: 'Donasi D', amount: 'Rp 15.000', type: TransactionType.income),
  TransactionItem(category: 'Bahan Pokok', subLabel: 'Beras', amount: 'Rp 8.000', type: TransactionType.expense),
];

// ─── Main Page ───────────────────────────────────────────────────────────────

class KeuanganPanti extends StatefulWidget {
  const KeuanganPanti({super.key});

  @override
  State<KeuanganPanti> createState() => _KeuanganPantiState();
}

class _KeuanganPantiState extends State<KeuanganPanti> {
  bool _balanceVisible = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _buildDashboardCard(),
        ),
        const SizedBox(height: 20),
        Expanded(child: _buildTransactionSection()),
      ],
    );
  }

  // ─── Header ──────────────────────────────────────────────────────────────

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          // Wallet icon
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: kPink.withOpacity(0.15),
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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kSalmon,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: kPink.withOpacity(0.25),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: Dasbor + eye icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Dasbor',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF7A4040),
                ),
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

          // Middle: Pemasukan | Pengeluaran
          IntrinsicHeight(
            child: Row(
              children: [
                // Pemasukan
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Pemasukan',
                        style: TextStyle(fontSize: 12, color: Color(0xFF7A4040)),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _balanceVisible ? 'Rp 1.000.000' : 'Rp ••••••',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                    ],
                  ),
                ),

                // Vertical divider
                Container(
                  width: 1,
                  color: const Color(0xFFD49090),
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                ),

                // Pengeluaran
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Pengeluaran',
                        style: TextStyle(fontSize: 12, color: Color(0xFF7A4040)),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _balanceVisible ? 'Rp 750.000' : 'Rp ••••••',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Bottom: Saldo white card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Saldo',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  _balanceVisible ? 'Rp 5.750.200' : 'Rp ••••••••',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1A1A),
                  ),
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
    // Calculate how far down the sheet starts (just below the dashboard card)
    // ~topPadding + header(60) + gap(16) + dashboardCard(~190) + gap(20)
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
              // Drag handle
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 6),
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              // List
              Expanded(
                child: ListView.separated(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                  itemCount: _transactions.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    return _TransactionTile(item: _transactions[index]);
                  },
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
  final TransactionItem item;

  const _TransactionTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final isIncome = item.type == TransactionType.income;
    final typeColor = isIncome ? kGreen : kRed;
    final typeIcon = isIncome ? Icons.add : Icons.remove;
    final arrowIcon = isIncome ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // +/- icon
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: typeColor.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(typeIcon, color: typeColor, size: 18),
          ),
          const SizedBox(width: 10),

          // Vertical divider
          Container(width: 1.5, height: 36, color: Colors.grey[200]),
          const SizedBox(width: 12),

          // Category + sub-label
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.category,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.subLabel,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),

          // Amount + arrow
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                item.amount,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: Color(0xFF1A1A1A),
                ),
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