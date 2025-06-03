import 'dart:convert';
import 'dart:io';
import 'package:ecosnap/models/scan.dart';
import 'package:ecosnap/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../models/feed.dart';
import '../utils/constants.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // Récupérer la liste des feeds
  static Future<List<Feed>> fetchFeeds(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/feeds/'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
        HttpHeaders.contentTypeHeader: 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((item) => Feed.fromJson(item)).toList();
    } else {
      throw Exception('Erreur lors du chargement des feeds');
    }
  }

  static Future<int?> uploadScan(File image, String token) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/api/scan/'),
    );
    request.headers[HttpHeaders.authorizationHeader] = 'Bearer $token';

    request.files.add(
      await http.MultipartFile.fromPath(
        'image',
        image.path,
        contentType: MediaType('image', 'jpeg'),
      ),
    );

    var streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['scan_id']; // 👈 retourne l'identifiant du scan
    } else {
      return null;
    }
  }

  static Future<User?> getProfile(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/users/profile/'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
        HttpHeaders.contentTypeHeader: 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return User.fromJson(data);
    } else {
      return null;
    }
  }

  static Future<List<Scan>> getMyScans(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/scan/'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
        HttpHeaders.contentTypeHeader: 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => Scan.fromJson(json)).toList();
    } else {
      throw Exception('Erreur lors du chargement des scans');
    }
  }

  static Future<Scan?> getScanResult(String token, int scanId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/scan/my-scans/$scanId/'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
        HttpHeaders.contentTypeHeader: 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Scan.fromJson(data);
    } else {
      return null;
    }
  }

  Future<void> saveDeviceToken() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    if (fcmToken != null) {
      await http.post(
        Uri.parse('$baseUrl/api/scan/device/'),
        headers: {'Authorization': 'Bearer $token'},
        body: {'fcm_token': fcmToken},
      );
    }
  }
}
