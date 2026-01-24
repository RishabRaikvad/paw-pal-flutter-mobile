import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class ImageUploadService {
  static const String cloudName = "dejmfx6fq";
  static const String uploadPreset = "profile_images";

  Future<String?> uploadImage({
    required File? image,
    required String uid,
  }) async {
    if (image == null) return null;
    final uri = Uri.parse(
      "https://api.cloudinary.com/v1_1/$cloudName/image/upload",
    );
    final uniqueId = "$uid-${DateTime.now().millisecondsSinceEpoch}";
    final request = http.MultipartRequest("POST", uri)
      ..fields['upload_preset'] = uploadPreset
      ..fields['public_id'] = uniqueId
      ..files.add(
        await http.MultipartFile.fromPath(
          'file',
          image.path,
        ),
      );

    final response = await request.send();

    if (response.statusCode != 200) {
      throw Exception("Cloudinary upload failed");
    }

    final responseBody = await response.stream.bytesToString();
    final data = json.decode(responseBody);
    debugPrint("📦 Cloudinary Response: $data");

    return data['secure_url']; // 🔥 save in Firestore
  }
}
