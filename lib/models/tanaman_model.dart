import 'package:pupuk_frontend/models/clarifai_model.dart';

class TanamanModel {
  int? id;
  int? umur;
  String? namaPupuk;
  String? keterangan;
  String? dosis;
  String? updatedAt;
  String? gambar;
  List<Clarifai>? clarifais;

  TanamanModel(
      {this.id,
      this.umur,
      this.namaPupuk,
      this.keterangan,
      this.dosis,
      this.updatedAt,
      this.gambar,
      this.clarifais});

  TanamanModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    umur = int.parse(json['umur']);
    namaPupuk = json['nama_pupuk'];
    keterangan = json['keterangan'];
    dosis = json['dosis'];
    updatedAt = json['updated_at'];
    gambar = json['gambar'];
    if (json['clarifais'] != null) {
      clarifais = [];
      json['clarifais'].forEach((v) {
        clarifais!.add(Clarifai.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['umur'] = umur;
    data['namaPupuk'] = namaPupuk;
    data['keterangan'] = keterangan;
    data['dosis'] = dosis;
    data['updated_at'] = updatedAt;
    data['gambar'] = gambar;
    return data;
  }
}
