import 'dart:io';
import 'package:http/http.dart' show Client;
import 'package:pam_perpustakaan/model/member.dart';

class ApiService {
  final String baseUrl = "http://192.168.43.225:3000/api/v1/members";
  Client client = Client();

  Future<List<Member>> getMember(int id) async {
    if (id == null) {
      final response = await client.get("$baseUrl",
          headers: {"Content-Type": "application/json"});
      if (response.statusCode == 200) {
        return membersFromJson(response.body);
      } else {
        throw HttpException(
            '${response.statusCode} : ${response.reasonPhrase}');
      }
    } else {
      final response = await client.get("$baseUrl/$id",
          headers: {"Content-Type": "application/json"});
      if (response.statusCode == 200) {
        return membersFromJson(response.body);
      } else {
        throw HttpException(
            '${response.statusCode} : ${response.reasonPhrase}');
      }
    }
  }

  Future<bool> addMember(Member data) async {
    final response = await client.post("$baseUrl",
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        body: memberToJson(data));

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      throw HttpException('${response.statusCode} : ${response.reasonPhrase}');
    }
  }

  Future<bool> updateMember(Member data, int id) async {
    final response = await client.put("$baseUrl/$id",
        headers: {"Content-Type": "application/json"},
        body: memberToJson(data));
    if (response.statusCode == 200) {
      return true;
    } else {
      throw HttpException('${response.statusCode} : ${response.reasonPhrase}');
    }
  }

  Future<bool> deleteMember(int id) async {
    final response = await client.delete("$baseUrl/$id",
        headers: {"Content-Type": "application/json"});

    if (response.statusCode == 200) {
      return true;
    } else {
      throw HttpException('${response.statusCode} : ${response.reasonPhrase}');
    }
  }
}
