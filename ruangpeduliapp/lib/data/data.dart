import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';

// ─── GOOGLE SIGN-IN SERVICE ──────────────────────────────────────────────────
class GoogleSignInService {
  static final _googleSignIn = GoogleSignIn(
    clientId: '773421848878-1dagn4rc098tqg20e1r84vc3100uim9g.apps.googleusercontent.com',
    scopes: ['email', 'profile'],
  );

  /// Opens the Google account picker and returns the id_token string.
  /// Returns null if the user cancelled. Throws on error.
  static Future<String?> signIn() async {
    try {
      final account = await _googleSignIn.signIn();
      if (account == null) return null; // user cancelled
      final auth = await account.authentication;
      final token = auth.idToken;
      if (token == null) throw Exception('Gagal mendapatkan token dari Google');
      return token;
    } catch (e) {
      throw Exception('Google Sign-In gagal: $e');
    }
  }

  static Future<void> signOut() async {
    await _googleSignIn.signOut();
  }
}

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

  // ─── LOGIN ────────────────────────────────────────────────────────
  Future<Map<String, dynamic>> login(String email, String password, String role) async {
    final url = Uri.parse('$baseUrl/login/');
    print('📤 POST $url');

    try {
      final res = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'email': email, 'password': password, 'role': role}),
          )
          .timeout(
            const Duration(seconds: 15),
            onTimeout: () => throw Exception('Koneksi timeout'),
          );

      print('📥 Status: ${res.statusCode}');
      print('📥 Body: ${res.body}');

      if (res.statusCode != 200) {
        final body = jsonDecode(res.body);
        throw Exception(body['error'] ?? 'Login gagal');
      }

      return jsonDecode(res.body) as Map<String, dynamic>;
    } on SocketException catch (e) {
      print('❌ SocketException: $e');
      throw Exception('Tidak bisa konek ke server');
    }
  }

  // ─── FORGOT PASSWORD ──────────────────────────────────────────────
  Future<void> forgotPassword(String email) async {
    final url = Uri.parse('$baseUrl/forgot-password/');
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
        throw Exception(body['error'] ?? 'Gagal mengirim OTP');
      }
    } on SocketException catch (e) {
      print('❌ SocketException: $e');
      throw Exception('Tidak bisa konek ke server');
    }
  }

  // ─── RESET PASSWORD ───────────────────────────────────────────────
  Future<void> resetPassword(String email, String otp, String newPassword) async {
    final url = Uri.parse('$baseUrl/reset-password/');
    print('📤 POST $url');

    try {
      final res = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'email': email, 'otp': otp, 'new_password': newPassword}),
          )
          .timeout(
            const Duration(seconds: 15),
            onTimeout: () => throw Exception('Koneksi timeout'),
          );

      print('📥 Status: ${res.statusCode}');
      print('📥 Body: ${res.body}');

      if (res.statusCode != 200) {
        final body = jsonDecode(res.body);
        throw Exception(body['error'] ?? 'Gagal reset sandi');
      }
    } on SocketException catch (e) {
      print('❌ SocketException: $e');
      throw Exception('Tidak bisa konek ke server');
    }
  }

  // ─── GOOGLE AUTH ──────────────────────────────────────────────────
  /// Verify Google id_token with backend.
  /// Returns the full response map:
  ///   exists=true  → {exists, user_id, username, email, role}
  ///   exists=false → {exists, email, name}
  Future<Map<String, dynamic>> googleAuth(String idToken, String role) async {
    final url = Uri.parse('$baseUrl/google-auth/');
    print('📤 POST $url');

    try {
      final res = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'id_token': idToken, 'role': role}),
          )
          .timeout(
            const Duration(seconds: 20),
            onTimeout: () => throw Exception('Koneksi timeout'),
          );

      print('📥 Status: ${res.statusCode}');
      print('📥 Body: ${res.body}');

      if (res.statusCode != 200) {
        final body = jsonDecode(res.body);
        throw Exception(body['error'] ?? 'Google auth gagal');
      }

      return jsonDecode(res.body) as Map<String, dynamic>;
    } on SocketException {
      throw Exception('Tidak bisa konek ke server');
    }
  }

  // ─── GOOGLE REGISTER ──────────────────────────────────────────────
  Future<void> googleRegister({
    required String idToken,
    required String role,
    required String username,
    String? namaPengguna,
    String? alamat,
    String? namaPanti,
    String? alamatPanti,
    String? nomorPanti,
  }) async {
    final url = Uri.parse('$baseUrl/google-register/');
    print('📤 POST $url');

    final body = <String, dynamic>{
      'id_token': idToken,
      'role': role,
      'username': username,
      if (namaPengguna != null) 'nama_pengguna': namaPengguna,
      if (alamat != null) 'alamat': alamat,
      if (namaPanti != null) 'nama_panti': namaPanti,
      if (alamatPanti != null) 'alamat_panti': alamatPanti,
      if (nomorPanti != null) 'nomor_panti': nomorPanti,
    };

    try {
      final res = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(body),
          )
          .timeout(
            const Duration(seconds: 20),
            onTimeout: () => throw Exception('Koneksi timeout'),
          );

      print('📥 Status: ${res.statusCode}');
      print('📥 Body: ${res.body}');

      if (res.statusCode != 200 && res.statusCode != 201) {
        final decoded = jsonDecode(res.body);
        throw Exception(decoded['error'] ?? 'Registrasi Google gagal');
      }
    } on SocketException {
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