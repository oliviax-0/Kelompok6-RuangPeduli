import 'package:flutter/material.dart';

// ─── Constants ───────────────────────────────────────────────────────────────

const Color kPink = Color(0xFFF28C9F);
const Color kPinkLight = Color(0xFFFDE8EC);
const Color kSalmon = Color(0xFFF2C4BC);
const Color kGreen = Color(0xFF2DB34A);
const Color kRed = Color(0xFFE53935);

// ─── Main Page ───────────────────────────────────────────────────────────────

class InventarisPanti extends StatefulWidget {
  const InventarisPanti({super.key});

  @override
  State<InventarisPanti> createState() => _InventarisPantiState();
}

class _InventarisPantiState extends State<InventarisPanti> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      child: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          _buildStokSection(),
          const SizedBox(height: 16),
          _buildAnggotaSection(),
        ],
      ),
    );
  }

  // ─── Header ──────────────────────────────────────────────────────────────

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
      child: Row(
        children: [
          // 3D box icon
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: kPink.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: Icon(Icons.inventory_2_rounded, color: kPink, size: 22),
            ),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'Inventaris',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1A1A1A),
                letterSpacing: -0.5,
              ),
            ),
          ),
          // Bell with red badge
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(Icons.notifications_rounded, color: Color(0xFF1A1A1A), size: 20),
              ),
              Positioned(
                top: 2,
                right: 2,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: kRed,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── Stok Section ────────────────────────────────────────────────────────

  Widget _buildStokSection() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      decoration: BoxDecoration(
        color: kPinkLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF1A1A1A), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: kPink.withOpacity(0.12),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Stok',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _SquareCard(
                  label: 'Stok Masuk',
                  icon: _BoxArrowIcon(arrowColor: kGreen, arrowUp: true),
                  onTap: () {},
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _SquareCard(
                  label: 'Stok Keluar',
                  icon: _BoxArrowIcon(arrowColor: kRed, arrowUp: false),
                  onTap: () {},
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // + button bottom right
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {},
              child: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Color(0xFF1A1A1A),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 22),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Anggota Section ─────────────────────────────────────────────────────

  Widget _buildAnggotaSection() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      decoration: BoxDecoration(
        color: kPinkLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF1A1A1A), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: kPink.withOpacity(0.12),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Anggota',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 14),

          // Summary row
          Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            decoration: BoxDecoration(
              color: kSalmon,
              borderRadius: BorderRadius.circular(14),
            ),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  // Pegawai count
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Pegawai ',
                          style: TextStyle(fontSize: 14, color: Color(0xFF5A2828)),
                        ),
                        const Text(
                          '8',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Divider
                  Container(
                    width: 1.5,
                    color: const Color(0xFFD49090),
                  ),
                  // Penghuni count
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Penghuni ',
                          style: TextStyle(fontSize: 14, color: Color(0xFF5A2828)),
                        ),
                        const Text(
                          '16',
                          style: TextStyle(
                            fontSize: 20,
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
          ),
          const SizedBox(height: 14),

          // Grid cards
          Row(
            children: [
              Expanded(
                child: _SquareCard(
                  label: 'Pegawai',
                  icon: const Icon(Icons.work_rounded, size: 42, color: Color(0xFF1A1A1A)),
                  onTap: () {},
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _SquareCard(
                  label: 'Penghuni',
                  icon: const Icon(Icons.groups_rounded, size: 42, color: Color(0xFF1A1A1A)),
                  onTap: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Square Card ─────────────────────────────────────────────────────────────

class _SquareCard extends StatelessWidget {
  final String label;
  final Widget icon;
  final VoidCallback onTap;

  const _SquareCard({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(height: 12),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1A1A1A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Box + Arrow Icon (custom painted) ───────────────────────────────────────

class _BoxArrowIcon extends StatelessWidget {
  final Color arrowColor;
  final bool arrowUp;

  const _BoxArrowIcon({required this.arrowColor, required this.arrowUp});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 52,
      height: 52,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Box icon
          Icon(
            Icons.inventory_2_outlined,
            size: 48,
            color: const Color(0xFF1A1A1A),
          ),
          // Arrow overlay (top center of the box)
          Positioned(
            top: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                arrowUp ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                size: 20,
                color: arrowColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}