class Yonetmen{
  int? id;
  String? ad;
  String? soyad;
  String? pic_url;

  Yonetmen(this.ad,this.soyad,this.pic_url);
  Yonetmen.withID(this.id,this.ad,this.soyad,this.pic_url);

    Map<String,dynamic> toMap(){
    var map =  Map<String,dynamic>();
    map['id'] = id;
    map['ad'] = ad;
    map['soyad'] = soyad;
    map['pic_url'] = pic_url;
    return map;
  }

  Yonetmen.fromMap(Map<String,dynamic> map){
    this.id = map['id'];
    this.ad = map['ad'];
    this.soyad = map['soyad'];
    this.pic_url = map['pic_url'];
  }

  String toString() {
    return "Oyuncu{ID: $id, AD: $ad, SOYAD: $soyad, PICURL: $pic_url}";
  }

  
}