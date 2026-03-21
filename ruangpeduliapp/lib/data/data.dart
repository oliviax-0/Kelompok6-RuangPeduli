import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class RegisterData {
  final String username;
  final String email;
  final String password;
  final String role;
  final String? namaPengguna;
  final String? alamat;
  final String? namaPanti;
  final String? alamatPanti;
  final String? nomorPanti;

  RegisterData({
    required this.username,
    required this.email,
    required this.password,
    required this.role,
    this.namaPengguna,
    this.alamat,
    this.namaPanti,
    this.alamatPanti,
    this.nomorPanti,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'password': password,
      'role': role,
      'nama_pengguna': namaPengguna,
      'alamat': alamat,
      'nama_panti': namaPanti,
      'alamat_panti': alamatPanti,
      'nomor_panti': nomorPanti,
    }..removeWhere((k, v) => v == null);
  }
}

class AppConfig {
  // ✏️ Kalau testing di iPhone FISIK, isi URL localhost.run kamu di sini
  // Kalau pakai Simulator, biarkan kosong
  static const String localhostRunUrl = ''; // contoh: 'https://abcd1234.lhr.life'

  // ✏️ IP laptop kamu
  static const String devIp = '192.168.18.138';

  static String get baseUrl {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8000/api';
    }
    if (localhostRunUrl.isNotEmpty) {
      return '$localhostRunUrl/api';
    }
    return 'http://localhost:8000/api'; // iOS Simulator
  }
}

class AuthApi {
  final String baseUrl = AppConfig.baseUrl;

  // ─── REGISTER START ───────────────────────────────────────────────
  Future<String> startRegister(RegisterData data) async {
    final url = Uri.parse('$baseUrl/pending/');
    print('📤 POST $url');
    print('📦 Body: ${jsonEncode(data.toJson())}');

    try {
      final res = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(data.toJson()),
          )
          .timeout(
            const Duration(seconds: 15),
            onTimeout: () => throw Exception('Koneksi timeout, cek jaringan'),
          );

      print('📥 Status: ${res.statusCode}');
      print('📥 Body: ${res.body}');

      if (res.statusCode != 200 && res.statusCode != 201) {
        // ✅ Ambil pesan error spesifik dari backend
        final error = jsonDecode(res.body);
        throw Exception(error['error'] ?? 'Registrasi gagal');
      }

      final json = jsonDecode(res.body);
      return json['pending_id'].toString();
    } on SocketException catch (e) {
      print('❌ SocketException: $e');
      throw Exception('Tidak bisa konek ke server');
    }
  }

  // ─── VERIFY OTP ───────────────────────────────────────────────────
  Future<void> verifyOtp(String pendingId, String otp) async {
    final url = Uri.parse('$baseUrl/verify/');
    print('📤 POST $url');
    print('📦 Body: pending_id=$pendingId, otp=$otp');

    try {
      final res = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'pending_id': pendingId, 'otp': otp}),
          )
          .timeout(
            const Duration(seconds: 15),
            onTimeout: () => throw Exception('Koneksi timeout'),
          );

      print('📥 Status: ${res.statusCode}');
      print('📥 Body: ${res.body}');

      if (res.statusCode != 200 && res.statusCode != 201) {
        final body = jsonDecode(res.body);
        throw Exception(body['error'] ?? 'Verifikasi gagal');
      }
    } on SocketException catch (e) {
      print('❌ SocketException: $e');
      throw Exception('Tidak bisa konek ke server');
    }
  }

  // ─── RESEND OTP ───────────────────────────────────────────────────
  Future<void> resendOtp(String email) async {
    final url = Uri.parse('$baseUrl/resend-otp/');
    print('📤 POST $url');

    try {
      final res = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'email': email}),
          )
          .timeout(
            const Duration(seconds: 15),
            onTimeout: () => throw Exception('Koneksi timeout'),
          );

      print('📥 Status: ${res.statusCode}');
      print('📥 Body: ${res.body}');

      if (res.statusCode != 200) {
        final body = jsonDecode(res.body);
        throw Exception(body['error'] ?? 'Gagal kirim ulang OTP');
      }
    } on SocketException catch (e) {
      print('❌ SocketException: $e');
      throw Exception('Tidak bisa konek ke server');
    }
  }
}