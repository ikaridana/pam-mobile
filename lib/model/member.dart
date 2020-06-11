import 'dart:convert';
class Member {
  final int id;
  final String nama;
  final String nim;
  final String jurusan;
  Member({
    this.id,
    this.nama,
    this.nim,
    this.jurusan,
  });
  factory Member.fromJson(Map<String, dynamic> item) {
    return Member(
      id: item["id"] as int,
      nama: item["nama"] as String,
      nim: item["nim"] as String,
      jurusan: item["jurusan"] as String,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "nama": nama,
      "nim": nim,
      "jurusan": jurusan,
    };
  }
}
List<Member> membersFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<Member>.from(data.map((item) => Member.fromJson(item)));
}
String memberToJson(Member data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
