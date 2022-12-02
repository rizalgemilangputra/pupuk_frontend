class TanamanModel {
  int? id;
  int? umur;
  String? namaPupuk;
  String? keterangan;
  String? updatedAt;
  String? gambar;

  TanamanModel(
      {this.id,
      this.umur,
      this.namaPupuk,
      this.keterangan,
      this.updatedAt,
      this.gambar});

  TanamanModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    umur = int.parse(json['umur']);
    namaPupuk = json['nama_pupuk'];
    keterangan = json['keterangan'];
    updatedAt = json['updated_at'];
    gambar = json['gambar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['umur'] = umur;
    data['namaPupuk'] = namaPupuk;
    data['keterangan'] = keterangan;
    data['updated_at'] = updatedAt;
    data['gambar'] = gambar;
    return data;
  }
}
