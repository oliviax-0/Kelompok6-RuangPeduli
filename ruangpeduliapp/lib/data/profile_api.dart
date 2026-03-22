import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:ruangpeduliapp/data/data.dart';

// ─── MODELS ──────────────────────────────────────────────────────────────────

class PantiProfileModel {
  final int id;
  final String username;
  final String email;
  final String namaPanti;
  final String alamatPanti;
  final String nomorPanti;
  final String? profilePicture;
  final String description;

  PantiProfileModel({
    required this.id,
    required this.username,
    required this.email,
    required this.namaPanti,
    required this.alamatPanti,
    required this.nomorPanti,
    this.profilePicture,
    required this.description,
  });

  factory PantiProfileModel.fromJson(Map<String, dynamic> json) {
    return PantiProfileModel(
      id: json['id'],
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      namaPanti: json['nama_panti'] ?? '',
      alamatPanti: json['alamat_panti'] ?? '',
      nomorPanti: json['nomor_panti'] ?? '',
      profilePicture: json['profile_picture'],
      description: json['description'] ?? '',
    );
  }

  PantiProfileModel copyWith({
    String? username,
    String? email,
    String? namaPanti,
    String? alamatPanti,
    String? nomorPanti,
    String? profilePicture,
    bool clearProfilePicture = false,
    String? description,
  }) {
    return PantiProfileModel(
      id: id,
      username: username ?? this.username,
      email: email ?? this.email,
      namaPanti: namaPanti ?? this.namaPanti,
      alamatPanti: alamatPanti ?? this.alamatPanti,
      nomorPanti: nomorPanti ?? this.nomorPanti,
      profilePicture: clearProfilePicture ? null : (profilePicture ?? this.profilePicture),
      description: description ?? this.description,
    );
  }
}

class PantiMediaModel {
  final int id;
  final String mediaType; // 'photo' | 'video'
  final String? file;
  final String videoUrl;
  final int order;

  PantiMediaModel({
    required this.id,
    required this.mediaType,
    this.file,
    required this.videoUrl,
    required this.order,
  });

  bool get isVideo => mediaType == 'video';

  factory PantiMediaModel.fromJson(Map<String, dynamic> json) {
    return PantiMediaModel(
      id: json['id'],
      mediaType: json['media_type'] ?? 'photo',
      file: json['file'],
      videoUrl: json['video_url'] ?? '',
      order: json['order'] ?? 0,
    );
  }
}

// ─── API ─────────────────────────────────────────────────────────────────────

class ProfileApi {
  String get _base => AppConfig.baseUrl;

  Future<PantiProfileModel> fetchPantiProfile(int pantiId) async {
    final uri = Uri.parse('$_base/profiles/panti/$pantiId/');
    try {
      final res = await http.get(uri).timeout(
        const Duration(seconds: 15),
        onTimeout: () => throw Exception('Koneksi timeout'),
      );
      if (res.statusCode != 200) throw Exception('Gagal memuat profil panti');
      return PantiProfileModel.fromJson(
          jsonDecode(res.body) as Map<String, dynamic>);
    } on SocketException {
      throw Exception('Tidak bisa konek ke server');
    }
  }

  Future<PantiProfileModel> updatePantiProfile(
    int pantiId, {
    String? namaPanti,
    String? alamatPanti,
    String? nomorPanti,
    String? description,
    String? username,
    String? email,
    String? password,
    File? profilePicture,
  }) async {
    final uri = Uri.parse('$_base/profiles/panti/$pantiId/');
    try {
      final req = http.MultipartRequest('PATCH', uri);

      if (namaPanti != null) req.fields['nama_panti'] = namaPanti;
      if (alamatPanti != null) req.fields['alamat_panti'] = alamatPanti;
      if (nomorPanti != null) req.fields['nomor_panti'] = nomorPanti;
      if (description != null) req.fields['description'] = description;
      if (username != null) req.fields['username'] = username;
      if (email != null) req.fields['email'] = email;
      if (password != null && password.isNotEmpty) {
        req.fields['password'] = password;
      }
      if (profilePicture != null) {
        req.files.add(await http.MultipartFile.fromPath(
            'profile_picture', profilePicture.path));
      }

      final streamed = await req.send().timeout(const Duration(seconds: 30));
      final res = await http.Response.fromStream(streamed);
      if (res.statusCode != 200) throw Exception('Gagal memperbarui profil');
      return PantiProfileModel.fromJson(
          jsonDecode(res.body) as Map<String, dynamic>);
    } on SocketException {
      throw Exception('Tidak bisa konek ke server');
    }
  }

  Future<List<PantiMediaModel>> fetchPantiMedia(int pantiId) async {
    final uri = Uri.parse('$_base/profiles/panti/$pantiId/media/');
    try {
      final res = await http.get(uri).timeout(
        const Duration(seconds: 15),
        onTimeout: () => throw Exception('Koneksi timeout'),
      );
      if (res.statusCode != 200) throw Exception('Gagal memuat media');
      final List data = jsonDecode(res.body);
      return data
          .map((e) => PantiMediaModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on SocketException {
      throw Exception('Tidak bisa konek ke server');
    }
  }

  Future<PantiMediaModel> uploadPantiMedia(
    int pantiId, {
    required File file,
    String mediaType = 'photo',
    int order = 0,
  }) async {
    final uri = Uri.parse('$_base/profiles/panti/$pantiId/media/');
    try {
      final req = http.MultipartRequest('POST', uri);
      req.fields['media_type'] = mediaType;
      req.fields['order'] = order.toString();
      req.files
          .add(await http.MultipartFile.fromPath('file', file.path));

      final streamed = await req.send().timeout(const Duration(seconds: 30));
      final res = await http.Response.fromStream(streamed);
      if (res.statusCode != 201) throw Exception('Gagal mengunggah media');
      return PantiMediaModel.fromJson(
          jsonDecode(res.body) as Map<String, dynamic>);
    } on SocketException {
      throw Exception('Tidak bisa konek ke server');
    }
  }

  Future<void> deletePantiMedia(int pantiId, int mediaId) async {
    final uri =
        Uri.parse('$_base/profiles/panti/$pantiId/media/$mediaId/');
    try {
      final res = await http.delete(uri).timeout(const Duration(seconds: 15));
      if (res.statusCode != 204) throw Exception('Gagal menghapus media');
    } on SocketException {
      throw Exception('Tidak bisa konek ke server');
    }
  }
}
