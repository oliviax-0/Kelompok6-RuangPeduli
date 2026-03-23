import 'dart:convert';
import 'package:http/http.dart' as http;
import 'data.dart';

// ─── Models ──────────────────────────────────────────────────────────────────

class FinanceDashboard {
  final double totalPemasukan;
  final double totalPengeluaran;
  final double saldo;

  const FinanceDashboard({
    required this.totalPemasukan,
    required this.totalPengeluaran,
    required this.saldo,
  });

  factory FinanceDashboard.fromJson(Map<String, dynamic> json) => FinanceDashboard(
        totalPemasukan: double.parse(json['total_pemasukan'].toString()),
        totalPengeluaran: double.parse(json['total_pengeluaran'].toString()),
        saldo: double.parse(json['saldo'].toString()),
      );
}

class TransactionModel {
  final int id;
  final String category;
  final String subLabel;
  final double jumlah;
  final bool isIncome;
  final String tanggal;

  const TransactionModel({
    required this.id,
    required this.category,
    required this.subLabel,
    required this.jumlah,
    required this.isIncome,
    required this.tanggal,
  });

  String get formattedAmount {
    final formatted = jumlah.toInt().toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]}.',
        );
    return 'Rp $formatted';
  }
}

// ─── API ─────────────────────────────────────────────────────────────────────

class FinanceApi {
  final String _base = AppConfig.baseUrl;

  Future<FinanceDashboard> fetchDashboard(int userId) async {
    final uri = Uri.parse('$_base/finance/dashboard/').replace(
      queryParameters: {'user_id': userId.toString()},
    );
    final res = await http.get(uri).timeout(const Duration(seconds: 15));
    if (res.statusCode == 200) return FinanceDashboard.fromJson(jsonDecode(res.body));
    throw Exception('Gagal memuat dashboard keuangan');
  }

  Future<List<TransactionModel>> fetchTransactions(int userId) async {
    final params = {'user_id': userId.toString()};
    final uriPemasukan   = Uri.parse('$_base/finance/pemasukan/').replace(queryParameters: params);
    final uriPengeluaran = Uri.parse('$_base/finance/pengeluaran/').replace(queryParameters: params);

    final results = await Future.wait([
      http.get(uriPemasukan).timeout(const Duration(seconds: 15)),
      http.get(uriPengeluaran).timeout(const Duration(seconds: 15)),
    ]);

    if (results[0].statusCode != 200 || results[1].statusCode != 200) {
      throw Exception('Gagal memuat transaksi');
    }

    final incomes = (jsonDecode(results[0].body) as List).map((e) => TransactionModel(
          id: e['id'],
          category: e['jenis_nama'] ?? 'Pemasukan',
          subLabel: e['catatan'] ?? '',
          jumlah: double.parse(e['jumlah'].toString()),
          isIncome: true,
          tanggal: e['tanggal'],
        ));

    final expenses = (jsonDecode(results[1].body) as List).map((e) => TransactionModel(
          id: e['id'],
          category: e['kategori_nama'] ?? 'Pengeluaran',
          subLabel: e['catatan'] ?? '',
          jumlah: double.parse(e['jumlah'].toString()),
          isIncome: false,
          tanggal: e['tanggal'],
        ));

    final all = [...incomes, ...expenses];
    all.sort((a, b) => b.tanggal.compareTo(a.tanggal));
    return all;
  }
}
