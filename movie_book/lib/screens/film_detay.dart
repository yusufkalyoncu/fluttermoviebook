import 'package:flutter/material.dart';
import 'package:movie_app/models/yonetmen.dart';
import 'package:movie_app/utils/database_helper.dart';

import '../models/film.dart';
import '../models/oyuncu.dart';

class FilmDetay extends StatefulWidget {
  Film film;
  FilmDetay(this.film);

  @override
  _FilmDetayState createState() => _FilmDetayState();
}

class _FilmDetayState extends State<FilmDetay> {
  late DatabaseHelper databaseHelper;
  var yorumFormKey = GlobalKey<FormState>();
  void initState() {
    databaseHelper = DatabaseHelper();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    @override
    Film film = widget.film;
    Size size = MediaQuery.of(context).size;
    return Material(
      child: Container(
          width: size.width,
          height: size.height,
          color: Colors.black,
          child: FutureBuilder(
              future: _verileriGetir(film),
              builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    return _filmDetaySayfasi(
                        film,
                        size,
                        snapshot.data![0],
                        snapshot.data![1],
                        snapshot.data![2],
                        snapshot.data![3]);
                  } else {
                    return Center(
                      child: Text(
                        "Bilgilere Ulaşılamadı",
                        style: TextStyle(fontSize: 24, color: Colors.white),
                      ),
                    );
                  }
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(
                    child: Text(
                      "Bekleniyor...",
                      style: TextStyle(fontSize: 24, color: Colors.white),
                    ),
                  );
                } else {
                  return Center(
                    child: Text(
                      "HATA 404",
                      style: TextStyle(fontSize: 24, color: Colors.white),
                    ),
                  );
                }
              })),
    );
  }

  _filmDetaySayfasi(
      Film film,
      Size size,
      List<Oyuncu> filmdekiOyuncular,
      List<String> filminKategorileri,
      List<String> filminYorumlari,
      Yonetmen filminYonetmeni) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          centerTitle: true,
          expandedHeight: 300,
          flexibleSpace: Stack(children: [
            FlexibleSpaceBar(
              background: FadeInImage.assetNetwork(
                placeholder: 'assets/loading.gif',
                image: film.pic_url!,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    film.ad! + " (${film.tarih})",
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  )),
            ),
          ]),
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            [
              _filmPuani(size, film),
              Divider(
                color: Colors.white,
              ),
              _filmAciklamasi(size, film),
              Divider(
                color: Colors.white,
              ),
              _filmOyunculariVeYonetmeni(size, film, filmdekiOyuncular,
                  filminYonetmeni, filminKategorileri),
              Divider(
                color: Colors.white,
              ),
              _filminYorumlari(size, film, filminYorumlari)
            ],
          ),
        ),
      ],
    );
  }

  Future<List<dynamic>> _verileriGetir(Film film) async {
    List<Oyuncu>? filmdekiOyuncular =
        await databaseHelper.filmToOyuncular(film);
    List<String>? filminKategorileri =
        await databaseHelper.filmToKategoriler(film);
    List<String>? filminYorumlari = [];
    filminYorumlari = await databaseHelper.filmToYorumlar(film);
    Yonetmen? filminYonetmeni = await databaseHelper.filmToYonetmen(film);
    List response = [
      filmdekiOyuncular,
      filminKategorileri,
      filminYorumlari,
      filminYonetmeni
    ];
    return response;
  }

  _filmPuani(Size size, Film film) {
    return Padding(
        padding: const EdgeInsets.all(1),
        child: Container(
          width: size.width,
          height: 30,
          color: Colors.black,
          child: Row(
            children: [
              SizedBox(
                width: 10,
              ),
              Icon(
                Icons.favorite,
                color: Colors.red,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                film.puan.toString() + "/10",
                style: TextStyle(fontSize: 16, color: Colors.white),
              )
            ],
          ),
        ));
  }

  _filmAciklamasi(Size size, Film film) {
    return Container(
      width: size.width,
      height: 120,
      color: Colors.black,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            film.desc!,
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
    );
  }

  _filmOyunculariVeYonetmeni(
      Size size,
      Film film,
      List<Oyuncu> filmdekiOyuncular,
      Yonetmen filminYonetmeni,
      List<String> filminKategorileri) {
    String oyuncular = "";
    for (Oyuncu oyuncu in filmdekiOyuncular) {
      oyuncular += oyuncu.ad! + " " + oyuncu.soyad! + ", ";
    }
    String kategoriler = "";
    for (String kategori in filminKategorileri) {
      kategoriler += kategori + ", ";
    }
    return Container(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 5,
              ),
              Text(
                "Oyuncu Kadrosu: " + oyuncular,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                  "Yönetmen: " +
                      filminYonetmeni.ad! +
                      " " +
                      filminYonetmeni.soyad!,
                  style: TextStyle(color: Colors.white, fontSize: 16)),
              SizedBox(
                height: 5,
              ),
              Text("Kategoriler: " + kategoriler,
                  style: TextStyle(color: Colors.white, fontSize: 16)),
            ],
          ),
        ),
      ),
      width: size.width,
      height: 120,
      color: Colors.black,
    );
  }

  _filminYorumlari(Size size, Film film, List<String> filminYorumlari) {
    String yapilanYorum = "";
    return Column(
      children: [
        Container(
          height: 15,
          color: Colors.black,
        ), //sized box
        Container(
          width: size.width,
          height: 40,
          color: Colors.black,
          child: Center(
              child: Text(
            "YORUMLAR",
            style: TextStyle(
                fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
          )),
        ),
        Container(
            width: size.width,
            height:
                filminYorumlari.isEmpty ? 70 : 55 + filminYorumlari.length * 55,
            color: Colors.black,
            child: filminYorumlari.isEmpty
                ? Center(
                    child: Text(
                    "Henüz yorum yapılmamış.",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ))
                : ListView.builder(
                    itemCount: filminYorumlari.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.all(3),
                        child: ListTile(
                          leading:
                              Icon(Icons.comment, color: Colors.grey.shade50),
                          title: Text(
                            filminYorumlari[index],
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          trailing: InkWell(
                            child: Icon(
                              Icons.delete,
                              color: Colors.grey.shade400,
                            ),
                            onTap: () async {
                              await showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text("Yorumu Sil"),
                                      content: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                "VAZGEÇ",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.red),
                                              )),
                                          TextButton(
                                              onPressed: () async {
                                                await databaseHelper.yorumSil(
                                                    filminYorumlari[index],
                                                    film);
                                                setState(() {});
                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                "SİL",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.green),
                                              )),
                                        ],
                                      ),
                                    );
                                  }).then((value) {
                                setState(() {});
                              });
                            },
                          ),
                          //tileColor: Colors.grey, doesnt work
                        ),
                      );
                    })),
        Container(
          width: size.width,
          height: 200,
          color: Colors.black,
          child: Form(
            key: yorumFormKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    maxLines: 4,
                    autofocus: false,
                    decoration: InputDecoration(
                      hintText: 'Yorum Yaz',
                      filled: true,
                      fillColor: Colors.grey,
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                    ),
                    validator: (deger) {
                      if (deger!.length < 3) {
                        return 'Yorum en az 3 karakter olmalı';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (deger) {
                      yapilanYorum = deger!;
                    },
                  ),
                ),
                TextButton(
                    onPressed: () async {
                      if (yorumFormKey.currentState!.validate()) {
                        yorumFormKey.currentState!.save();
                        var sonuc = await _yorumYap(film, yapilanYorum);
                        if (sonuc != 0) {
                          debugPrint("Yorum Eklendi");
                        } else {
                          debugPrint("Yorum Eklenemedi ! ");
                        }
                        setState(() {});
                      }
                    },
                    child: Text(
                      "Paylaş",
                      style: TextStyle(fontSize: 18),
                    )),
              ],
            ),
          ),
        )
      ],
    );
  }

  _yorumYap(Film film, String yorum) async {
    return await databaseHelper.yorumEkle(film.id!, yorum);
  }
}
