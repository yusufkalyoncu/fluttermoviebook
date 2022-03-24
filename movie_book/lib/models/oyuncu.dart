class Oyuncu{
  int? id;
  String? ad;
  String? soyad;
  String? cinsiyet;
  String? pic_url;
  Oyuncu(this.ad,this.soyad,this.cinsiyet,this.pic_url);
  Oyuncu.withID(this.id,this.ad,this.soyad,this.cinsiyet,this.pic_url);

  Map<String,dynamic> toMap(){
    var map =  Map<String,dynamic>();
    map['id'] = id;
    map['ad'] = ad;
    map['soyad'] = soyad;
    map['cinsiyet'] = cinsiyet;
    map['pic_url'] = pic_url;
    return map;
  }

  Oyuncu.fromMap(Map<String,dynamic> map){
    this.id = map['id'];
    this.ad = map['ad'];
    this.soyad = map['soyad'];
    this.cinsiyet = map['cinsiyet'];
    this.pic_url = map['pic_url'];
  }

  @override
  String toString() {
    // TODO: implement toString
    return "Oyuncu{ID: $id, AD: $ad, SOYAD: $soyad, CINSIYET: $cinsiyet, PICURL: $pic_url}";
  }
}