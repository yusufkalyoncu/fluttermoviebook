import 'package:flutter/material.dart';
import 'package:movie_app/models/film.dart';
import 'package:movie_app/utils/database_helper.dart';

import '../models/oyuncu.dart';
import '../models/yonetmen.dart';
import 'kategori_listesi.dart';
import 'oyuncu_listesi.dart';
import 'yonetmen_listesi.dart';

class UpdateScreen extends StatefulWidget {
  Film film;
  UpdateScreen(this.film);

  @override
  _UpdateScreenState createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  @override
  var filmFormKey = GlobalKey<FormState>();
  String? film_adi;
  double? film_puani;
  String? film_tarihi;
  String? film_pp;
  String? film_pic;
  String? film_desc;
  int? film_yonetmen_id;

  Yonetmen? filminYonetmeni;
  List<Oyuncu>? filminOyunculari;
  List<String>? filminKategorileri;
  late DatabaseHelper databaseHelper;

  late TextEditingController _adController;
  late TextEditingController _puanController;
  late TextEditingController _tarihController;
  late TextEditingController _ppController;
  late TextEditingController _picController;
  late TextEditingController _descController;

  @override
  void initState() {
    super.initState();
    databaseHelper = DatabaseHelper();
  }

  Widget build(BuildContext context) {
    Film film = widget.film;
    Size size = MediaQuery.of(context).size;

    film_adi = film.ad;
    film_puani = film.puan;
    film_tarihi = film.tarih;
    film_pp = film.pp_url;
    film_pic = film.pic_url;
    film_desc = film.desc;

    _adController = new TextEditingController(text: film_adi);
    _puanController = new TextEditingController(text: film_puani.toString());
    _tarihController = new TextEditingController(text: film_tarihi);
    _ppController = new TextEditingController(text: film_pp);
    _picController = new TextEditingController(text: film_pic);
    _descController = new TextEditingController(text: film_desc);

    return Material(
      child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.grey.shade600,
          child: FutureBuilder(
              future: _kategorileri_oyunculari_yonetmeni_getir(film),
              builder: (context, AsyncSnapshot<int> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    return SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.all(48),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadiusDirectional.circular(16),
                                  color: Colors.red),
                              width: 300,
                              height: 750,
                              child: _buildFilmForm(film),
                            )
                          ],
                        ),
                      ),
                    );
                  } else {
                    return Center(
                      child: Text("Bir hata oluştu"),
                    );
                  }
                } else {
                  return Center(
                    child: Text("Bekleniyor..."),
                  );
                }
              })),
    );
  }

  _buildFilmForm(Film film) {
    return Container(
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(8),
      child: Form(
          key: filmFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Flexible(
                  child: TextFormField(
                controller: _adController,
                autofocus: false,
                decoration: InputDecoration(
                  hintText: 'Film Adını Giriniz',
                  filled: true,
                  fillColor: Colors.green.shade100,
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                ),
                validator: (deger) {
                  if (deger!.length <= 0) {
                    return 'Film Adı Boş Bırakılamaz';
                  } else {
                    return null;
                  }
                },
                onSaved: (deger) {
                  film_adi = deger;
                },
              )),
              Flexible(
                  child: TextFormField(
                controller: _puanController,
                autofocus: false,
                decoration: InputDecoration(
                  hintText: 'Film Puanını Giriniz',
                  filled: true,
                  fillColor: Colors.green.shade100,
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                ),
                validator: (deger) {
                  if (deger!.length <= 0) {
                    return 'Film Puanı Boş Bırakılamaz';
                  } else {
                    return null;
                  }
                },
                onSaved: (deger) {
                  film_puani = double.parse(deger!);
                },
              )),
              Flexible(
                  child: TextFormField(
                controller: _tarihController,
                autofocus: false,
                decoration: InputDecoration(
                  hintText: 'Filmin Yılını Giriniz YYYY',
                  filled: true,
                  fillColor: Colors.green.shade100,
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                ),
                validator: (deger) {
                  if (deger!.length <= 0) {
                    return 'Film Yılı Boş Bırakılamaz';
                  } else {
                    return null;
                  }
                },
                onSaved: (deger) {
                  film_tarihi = deger;
                },
              )),
              Flexible(
                  child: TextFormField(
                controller: _ppController,
                autofocus: false,
                decoration: InputDecoration(
                  hintText: "Film Kapak Fotoğrafı URL'i Giriniz",
                  filled: true,
                  fillColor: Colors.green.shade100,
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                ),
                validator: (deger) {
                  if (deger!.length <= 0) {
                    return 'Kapak URL Alanı Boş Bırakılamaz';
                  } else {
                    return null;
                  }
                },
                onSaved: (deger) {
                  film_pp = deger;
                },
              )),
              Flexible(
                  child: TextFormField(
                controller: _picController,
                autofocus: false,
                decoration: InputDecoration(
                  hintText: "Film Fotoğrafı URL'i Giriniz",
                  filled: true,
                  fillColor: Colors.green.shade100,
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                ),
                validator: (deger) {
                  if (deger!.length <= 0) {
                    return 'Film URL Alanı Boş Bırakılamaz';
                  } else {
                    return null;
                  }
                },
                onSaved: (deger) {
                  film_pic = deger;
                },
              )),
              Flexible(
                  child: TextFormField(
                controller: _descController,
                autofocus: false,
                maxLines: 20,
                decoration: InputDecoration(
                  hintText: "Film Özetini Giriniz",
                  filled: true,
                  fillColor: Colors.green.shade100,
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                ),
                validator: (deger) {
                  if (deger!.length <= 0) {
                    return 'Film Özet Alanı Boş Bırakılamaz';
                  } else {
                    return null;
                  }
                },
                onSaved: (deger) {
                  film_desc = deger;
                },
              )),
              Flexible(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () async {
                      await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => KategoriListesi()))
                          .then((value) {
                        setState(() {
                          filminKategorileri = value;
                        });
                      });
                    },
                    child: Text("Kategorileri Seç"),
                  ),
                  filminKategorileri == null
                      ? Text(
                          "Kategori Seçilmedi",
                          style: TextStyle(fontSize: 16),
                        )
                      : Text(
                          "${filminKategorileri!.length} Kategori Seçildi",
                          style: TextStyle(fontSize: 16),
                        )
                ],
              )),
              Flexible(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () async {
                      await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => YonetmenListesi()))
                          .then((value) {
                        setState(() {
                          filminYonetmeni = value;
                        });
                      });
                    },
                    child: Text("Yönetmen Seç"),
                  ),
                  filminYonetmeni == null
                      ? Text(
                          "Yönetmen Seçilmedi",
                          style: TextStyle(fontSize: 16),
                        )
                      : Text(
                          filminYonetmeni!.ad.toString() +
                              " " +
                              filminYonetmeni!.soyad.toString(),
                          style: TextStyle(fontSize: 16),
                        )
                ],
              )),
              Flexible(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () async {
                      await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OyuncuListesi()))
                          .then((value) {
                        print(value!.length.toString());
                        setState(() {
                          filminOyunculari = value;
                        });
                      });
                    },
                    child: Text("Oyuncuları Seç"),
                  ),
                  filminOyunculari == null
                      ? Text(
                          "Oyuncular Seçilmedi",
                          style: TextStyle(fontSize: 16),
                        )
                      : Text(
                          "${filminOyunculari!.length} Oyuncu Seçildi",
                          style: TextStyle(fontSize: 16),
                        )
                ],
              )),
              TextButton(
                  onPressed: () async {
                    if (filmFormKey.currentState!.validate()) {
                      filmFormKey.currentState!.save();
                      var sonuc = await _filmGuncelle(film);
                      if (sonuc != 0) {
                        debugPrint("Film Güncellendi");
                      } else {
                        debugPrint("Film Güncellenemedi ! ");
                      }
                      setState(() {
                        int count = 2;
                        Navigator.of(context).popUntil((_) => count-- <= 0);
                      });
                    }
                  },
                  child: Text("Film Güncelle"))
            ],
          )),
    );
  }

  _filmGuncelle(Film film) async {
    if (filminYonetmeni != null &&
        filminOyunculari != null &&
        filminKategorileri != null) {
      var sonuc = await databaseHelper.filmiGuncelle(new Film.withID(
          film.id,
          film_adi,
          film_puani,
          film_tarihi,
          filminYonetmeni!.id,
          film_pp,
          film_pic,
          film_desc));
          debugPrint("Filmin Oyunculari : "+filminOyunculari.toString());
          debugPrint(filminYonetmeni.toString());
      var sonuc2 = await databaseHelper.oynamakTablosunuGuncelle(
          film.id!, filminOyunculari!);
      var sonuc3 = await databaseHelper.oyuncu_yonetmen_tablosunu_guncelle(
          filminOyunculari!, film.yonetmen_id!, film.id!);

      return sonuc;
    }
  }

  Future<int> _kategorileri_oyunculari_yonetmeni_getir(Film film) async {
    if (filminOyunculari == null) {
      filminYonetmeni = await databaseHelper.filmToYonetmen(film);
      filminOyunculari = await databaseHelper.filmToOyuncular(film);
      filminKategorileri = await databaseHelper.filmToKategoriler(film);
    }

    return 1;
  }
}

/*
  Future<int> _filmEkle() async {
    if (filminYonetmeni != null &&
        filminOyunculari != null &&
        filminKategorileri != null) {
      await databaseHelper.filmEkle(new Film(film_adi, film_puani, film_tarihi,filminYonetmeni!.id, film_pp, film_pic, film_desc));
      Film? film = await databaseHelper.adToFilm(film_adi!);
      await databaseHelper.oynamakTablosunaEkle(filminOyunculari!, film!.id!);
      await databaseHelper.oyuncu_yonetmenTablosunaEkle(filminOyunculari!, filminYonetmeni!.id!,film.id!);
      return await databaseHelper.turTablosunaEkle(filminKategorileri!, film.id);
    } else
      return 0;
  }
*/

/*
SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(48),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadiusDirectional.circular(16),
                      color: Colors.red),
                  width: 300,
                  height: 750,
                  child: _buildFilmForm(film),
                )
              ],
            ),
          ),
        ),
 */