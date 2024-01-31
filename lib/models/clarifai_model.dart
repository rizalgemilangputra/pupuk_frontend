class Clarifai {
  String? hex;
  String? warna;
  double? nilai;

  Clarifai({this.hex, this.warna, this.nilai});

  Clarifai.fromJson(Map<String, dynamic> json) {
    hex = json['hex'];
    warna = json['warna'];
    nilai = json['nilai'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['hex'] = hex;
    data['warna'] = warna;
    data['nilai'] = nilai;
    return data;
  }
}
