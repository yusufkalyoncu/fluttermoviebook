import 'package:flutter/material.dart';
import 'package:movie_app/screens/kategori_listesi.dart';
import 'package:movie_app/screens/oyuncu_listesi.dart';
import 'package:movie_app/screens/yonetmen_listesi.dart';

import '../models/film.dart';
import '../models/oyuncu.dart';
import '../models/yonetmen.dart';
import '../utils/database_helper.dart';

class AddScreen extends StatefulWidget {
  AddScreen();
  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  @override
  String? yonetmen_adi;
  String? yonetmen_soyadi;
  String? yonetmen_pic;

  String? oyuncu_adi;
  String? oyuncu_soyadi;
  String? oyuncu_cinsiyeti;
  String? oyuncu_pic;

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

  var yonetmenFormKey = GlobalKey<FormState>();
  var oyuncuFormKey = GlobalKey<FormState>();
  var filmFormKey = GlobalKey<FormState>();

  late TextEditingController _yonetmenAdController;
  late TextEditingController _yonetmenSoyadController;
  late TextEditingController _yonetmenPicController;

  late TextEditingController _oyuncuAdController;
  late TextEditingController _oyuncuSoyadController;
  late TextEditingController _oyuncuPicController;

  late DatabaseHelper databaseHelper;

  @override
  void initState() {
    super.initState();
    databaseHelper = DatabaseHelper();
    _yonetmenAdController = new TextEditingController(text: "");
    _yonetmenSoyadController = new TextEditingController(text: "");
    _yonetmenPicController = new TextEditingController(text: "");

    _oyuncuAdController = new TextEditingController(text: "");
    _oyuncuSoyadController = new TextEditingController(text: "");
    _oyuncuPicController = new TextEditingController(text: "");
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.grey.shade600,
        child: SingleChildScrollView(
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
                  height: 300,
                  child: _buildYonetmenForm(),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadiusDirectional.circular(16),
                      color: Colors.red),
                  width: 300,
                  height: 400,
                  child: _buildOyuncuForm(),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadiusDirectional.circular(16),
                      color: Colors.red),
                  width: 300,
                  height: 750,
                  child: _buildFilmForm(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildYonetmenForm() {
    return Container(
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(8),
      child: Form(
          key: yonetmenFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Flexible(
                  child: TextFormField(
                controller: _yonetmenAdController,
                autofocus: false,
                decoration: InputDecoration(
                  errorStyle: TextStyle(color: Colors.white),
                  hintText: 'Yönetmenin Adını Giriniz',
                  filled: true,
                  fillColor: Colors.green.shade100,
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                ),
                validator: (deger) {
                  if (deger!.length <= 0) {
                    return 'Yönetmen Adı Boş Bırakılamaz';
                  } else
                    return null;
                },
                onSaved: (deger) {
                  yonetmen_adi = deger;
                },
              )),
              Flexible(
                  child: TextFormField(
                controller: _yonetmenSoyadController,
                autofocus: false,
                decoration: InputDecoration(
                  errorStyle: TextStyle(color: Colors.white),
                  hintText: 'Yönetmenin Soyadını Giriniz',
                  filled: true,
                  fillColor: Colors.green.shade100,
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                ),
                validator: (deger) {
                  if (deger!.length <= 0) {
                    return 'Yönetmen Soyadı Boş Bırakılamaz';
                  } else
                    return null;
                },
                onSaved: (deger) {
                  yonetmen_soyadi = deger;
                },
              )),
              Flexible(
                  child: TextFormField(
                controller: _yonetmenPicController,
                autofocus: false,
                decoration: InputDecoration(
                  errorStyle: TextStyle(color: Colors.white),
                  hintText: "Yönetmenin Fotoğraf URL'i",
                  filled: true,
                  fillColor: Colors.green.shade100,
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                ),
                validator: (deger) {
                  if (deger!.length <= 0) {
                    return 'URL Boş Bırakılamaz';
                  } else
                    return null;
                },
                onSaved: (deger) {
                  yonetmen_pic = deger;
                },
              )),
              TextButton(
                  onPressed: () async {
                    if (yonetmenFormKey.currentState!.validate()) {
                      yonetmenFormKey.currentState!.save();
                      var sonuc = await _yonetmenEkle();
                      if (sonuc != 0) {
                        debugPrint("Yonetmen Eklendi");
                        await _showSuccessDialog();
                        _yonetmenAdController =
                            new TextEditingController(text: "");
                        _yonetmenSoyadController =
                            new TextEditingController(text: "");
                        _yonetmenPicController =
                            new TextEditingController(text: "");
                      } else {
                        debugPrint("Yonetmen Eklenemedi ! ");
                        await _showErrorDialog();
                      }
                      setState(() {});
                    }
                  },
                  child: Text("Yönetmen Ekle"))
            ],
          )),
    );
  }

  _buildOyuncuForm() {
    return Container(
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(8),
      child: Form(
          key: oyuncuFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Flexible(
                  child: TextFormField(
                controller: _oyuncuAdController,
                autofocus: false,
                decoration: InputDecoration(
                  errorStyle: TextStyle(color: Colors.white),
                  hintText: 'Oyuncunun Adını Giriniz',
                  filled: true,
                  fillColor: Colors.green.shade100,
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                ),
                validator: (deger) {
                  if (deger!.length <= 0) {
                    return 'Oyuncu Adı Boş Bırakılamaz';
                  } else
                    return null;
                },
                onSaved: (deger) {
                  oyuncu_adi = deger;
                },
              )),
              Flexible(
                  child: TextFormField(
                controller: _oyuncuSoyadController,
                autofocus: false,
                decoration: InputDecoration(
                  errorStyle: TextStyle(color: Colors.white),
                  hintText: 'Oyuncunun Soyadını Giriniz',
                  filled: true,
                  fillColor: Colors.green.shade100,
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                ),
                validator: (deger) {
                  if (deger!.length <= 0) {
                    return 'Oyuncu Soyadı Boş Bırakılamaz';
                  } else
                    return null;
                },
                onSaved: (deger) {
                  oyuncu_soyadi = deger;
                },
              )),
              Flexible(
                  child: TextFormField(
                controller: _oyuncuPicController,
                autofocus: false,
                decoration: InputDecoration(
                  errorStyle: TextStyle(color: Colors.white),
                  hintText: "Oyuncunun Fotoğraf URL'i",
                  filled: true,
                  fillColor: Colors.green.shade100,
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                ),
                validator: (deger) {
                  if (deger!.length <= 0) {
                    return 'Oyuncu Soyadı Boş Bırakılamaz';
                  } else
                    return null;
                },
                onSaved: (deger) {
                  oyuncu_pic = deger;
                },
              )),
              ListTile(
                title: Text("ERKEK"),
                leading: Radio(
                  value: 'ERKEK',
                  groupValue: oyuncu_cinsiyeti,
                  onChanged: (deger) {
                    setState(() {
                      oyuncu_cinsiyeti = deger.toString();
                    });
                  },
                ),
              ),
              ListTile(
                title: Text("KADIN"),
                leading: Radio(
                  value: 'KADIN',
                  groupValue: oyuncu_cinsiyeti,
                  onChanged: (deger) {
                    setState(() {
                      oyuncu_cinsiyeti = deger.toString();
                    });
                  },
                ),
              ),
              TextButton(
                  onPressed: () async {
                    if (oyuncuFormKey.currentState!.validate()) {
                      oyuncuFormKey.currentState!.save();
                      var sonuc = await _oyuncuEkle();
                      if (sonuc != 0) {
                        debugPrint("Oyuncu Eklendi");
                        await _showSuccessDialog();
                        _oyuncuAdController =
                            new TextEditingController(text: "");
                        _oyuncuSoyadController =
                            new TextEditingController(text: "");
                        _oyuncuPicController =
                            new TextEditingController(text: "");
                      } else {
                        debugPrint("Oyuncu Eklenemedi ! ");
                        await _showErrorDialog();
                      }
                      setState(() {});
                    }
                  },
                  child: Text("Oyuncu Ekle"))
            ],
          )),
    );
  }

  _buildFilmForm() {
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
                autofocus: false,
                decoration: InputDecoration(
                  errorStyle: TextStyle(color: Colors.white),
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
                autofocus: false,
                decoration: InputDecoration(
                  errorStyle: TextStyle(color: Colors.white),
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
                autofocus: false,
                decoration: InputDecoration(
                  errorStyle: TextStyle(color: Colors.white),
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
                autofocus: false,
                decoration: InputDecoration(
                  errorStyle: TextStyle(color: Colors.white),
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
                autofocus: false,
                decoration: InputDecoration(
                  errorStyle: TextStyle(color: Colors.white),
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
                autofocus: false,
                maxLines: 20,
                decoration: InputDecoration(
                  errorStyle: TextStyle(color: Colors.white),
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
                      var sonuc = await _filmEkle();
                      if (sonuc != 0) {
                        debugPrint("Film Eklendi");
                        await _showSuccessDialog();
                        Navigator.pop(context);
                      } else {
                        debugPrint("Film Eklenemedi ! ");
                        await _showErrorDialog();
                      }
                      setState(() {});
                    }
                  },
                  child: Text("Film Ekle"))
            ],
          )),
    );
  }

  Future<int> _yonetmenEkle() async {
    return await databaseHelper.yonetmenEkle(
        new Yonetmen(yonetmen_adi, yonetmen_soyadi, yonetmen_pic));
  }

  Future<int> _oyuncuEkle() async {
    return await databaseHelper.oyuncuEkle(
        new Oyuncu(oyuncu_adi, oyuncu_soyadi, oyuncu_cinsiyeti, oyuncu_pic));
  }

  Future<int> _filmEkle() async {
    if (filminYonetmeni != null &&
        filminOyunculari != null &&
        filminKategorileri != null) {
      await databaseHelper.filmEkle(new Film(film_adi, film_puani, film_tarihi,
          filminYonetmeni!.id, film_pp, film_pic, film_desc));
      Film? film = await databaseHelper.adToFilm(film_adi!);
      await databaseHelper.oynamakTablosunaEkle(filminOyunculari!, film!.id!);
      await databaseHelper.oyuncu_yonetmenTablosunaEkle(
          filminOyunculari!, filminYonetmeni!.id!, film.id!);
      return await databaseHelper.turTablosunaEkle(
          filminKategorileri!, film.id);
    } else
      return 0;
  }

  Future<void> _showSuccessDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Information'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text("Başarıyla Eklendi."),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Tamam',
                style: TextStyle(color: Colors.green),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showErrorDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Information'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text("Hata oluştu."),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Tamam'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
