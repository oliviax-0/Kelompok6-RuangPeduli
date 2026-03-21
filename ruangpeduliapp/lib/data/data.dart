import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class RegisterData {
  final String username;
  final String email;
  final String password;
  final String role;
  // masyarakat
  final String? namaPengguna;
  final String? alamat;
  // panti
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

class AuthApi {
  late final String baseUrl;

  AuthApi() {
    if (Platform.isAndroid) {
      baseUrl = 'http://10.0.2.2:8000/api';
    } else {
      // Ganti dengan IP laptop kamu (misal: 192.168.x.x atau 172.x.x.x)
      baseUrl = 'http://192.168.18.35:8000/api';
    }
  }

  Future<String> startRegister(RegisterData data) async {
    final url = Uri.parse('$baseUrl/pending/');
    print('📤 POST $url');
    print('📦 Body: ${jsonEncode(data.toJson())}');

    final res = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data.toJson()),
    );

    print('📥 Response Status: ${res.statusCode}');
    print('📥 Response Body: ${res.body}');

    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception('Register start failed: ${res.body}');
    }

    final json = jsonDecode(res.body);
    return json['id'].toString(); // <-- return UUID dari PendingRegistration
  }

  Future<void> verifyOtp(String pendingId, String otp) async {
    final url = Uri.parse('$baseUrl/verify/');
    print('📤 POST $url');
    print('📦 Body: pending_id=$pendingId, otp=$otp');

    final res = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'pending_id': pendingId, 'otp': otp}),
    );

    print('📥 Response Status: ${res.statusCode}');
    print('📥 Response Body: ${res.body}');

    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception('Verify failed: ${res.body}');
    }
  }
}
