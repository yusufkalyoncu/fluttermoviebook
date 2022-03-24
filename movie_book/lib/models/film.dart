import 'oyuncu.dart';

class Film{

  int? id;
  String? ad;
  double? puan;
  String? tarih;
  int? yonetmen_id;
  String? pp_url;
  String? pic_url;
  String? desc;
  Film(this.ad,this.puan,this.tarih,this.yonetmen_id,this.pp_url,this.pic_url,this.desc);
  Film.withID(this.id,this.ad,this.puan,this.tarih,this.yonetmen_id,this.pp_url,this.pic_url,this.desc);

  Map<String,dynamic> toMap(){
    var map =  Map<String,dynamic>();
    map['id'] = id;
    map['ad'] = ad;
    map['puan'] = puan;
    map['tarih'] = tarih;
    map['yonetmen_id'] = yonetmen_id;
    map['pp_url'] = pp_url;
    map['pic_url'] = pic_url;
    map['desc'] = desc;
    return map;
  }

    Film.fromMap(Map<String,dynamic> map){
    this.id = map['id'];
    this.ad = map['ad'];
    this.puan = map['puan'];
    this.tarih = map['tarih'];
    this.yonetmen_id = map['yonetmen_id'];
    this.pp_url = map['pp_url'];
    this.pic_url = map['pic_url'];
    this.desc = map['desc'];
  }

    String toString() {
    // TODO: implement toString
    return "Film{ID: $id, AD: $ad, PUAN: $puan, TARIH: $tarih, YONETMEN_ID: $yonetmen_id, PPURL: $pp_url, PICURL: $pic_url\nDESC: $desc}";
  }  
}