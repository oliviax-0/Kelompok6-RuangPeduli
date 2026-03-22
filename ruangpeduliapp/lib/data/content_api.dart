import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:ruangpeduliapp/data/data.dart';

// ─── BERITA MODEL ─────────────────────────────────────────────────────────────

class BeritaModel {
  final int id;
  final String title;
  final String content;
  final String? thumbnail;
  final String authorName;
  final String pantiName;
  final String? pantiProfilePicture;
  final String createdAt;
  final int upvoteCount;
  final int downvoteCount;

  BeritaModel({
    required this.id,
    required this.title,
    required this.content,
    this.thumbnail,
    required this.authorName,
    required this.pantiName,
    this.pantiProfilePicture,
    required this.createdAt,
    required this.upvoteCount,
    required this.downvoteCount,
  });

  factory BeritaModel.fromJson(Map<String, dynamic> json) {
    return BeritaModel(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      thumbnail: json['thumbnail'],
      authorName: json['author_name'] ?? '',
      pantiName: json['panti_name'] ?? '',
      pantiProfilePicture: json['panti_profile_picture'],
      createdAt: json['created_at'] ?? '',
      upvoteCount: json['upvote_count'] ?? 0,
      downvoteCount: json['downvote_count'] ?? 0,
    );
  }

  String get formattedDate {
    if (createdAt.isEmpty) return '';
    try {
      final dt = DateTime.parse(createdAt).toLocal();
      const months = [
        'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
        'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
      ];
      return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
    } catch (_) {
      return createdAt;
    }
  }
}

// ─── CONTENT API ──────────────────────────────────────────────────────────────

class ContentApi {
  String get _base => AppConfig.baseUrl;

  /// Fetch published beritas. Pass [pantiId] to filter by panti.
  Future<List<BeritaModel>> fetchBeritas({int? pantiId}) async {
    final uri = pantiId != null
        ? Uri.parse('$_base/content/berita/?panti=$pantiId')
        : Uri.parse('$_base/content/berita/');

    try {
      final res = await http.get(uri).timeout(
        const Duration(seconds: 15),
        onTimeout: () => throw Exception('Koneksi timeout'),
      );
      if (res.statusCode != 200) throw Exception('Gagal memuat berita');
      final List data = jsonDecode(res.body);
      return data
          .map((e) => BeritaModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on SocketException {
      throw Exception('Tidak bisa konek ke server');
    }
  }

  /// Toggle vote on a berita. [voteType] must be 'up' or 'down'.
  /// Returns { action, upvote_count, downvote_count }.
  Future<Map<String, dynamic>> voteBerita(
      int beritaId, int userId, String voteType) async {
    final uri = Uri.parse('$_base/content/berita/$beritaId/vote/');

    try {
      final res = await http
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'user_id': userId, 'vote_type': voteType}),
          )
          .timeout(
            const Duration(seconds: 15),
            onTimeout: () => throw Exception('Koneksi timeout'),
          );
      if (res.statusCode != 200) throw Exception('Gagal vote');
      return jsonDecode(res.body) as Map<String, dynamic>;
    } on SocketException {
      throw Exception('Tidak bisa konek ke server');
    }
  }
}
