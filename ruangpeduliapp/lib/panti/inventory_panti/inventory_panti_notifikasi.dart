import 'package:flutter/material.dart';

const Color kPink = Color(0xFFF28C9F);
const Color kPinkLight = Color(0xFFFDE8EC);
const Color kRed = Color(0xFFE53935);

class InventarisNotifikasiScreen extends StatelessWidget {
  const InventarisNotifikasiScreen({super.key});

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
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1A1A1A),
          ),
        ),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'Belum ada notifikasi.',
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
      ),
    );
  }
}
