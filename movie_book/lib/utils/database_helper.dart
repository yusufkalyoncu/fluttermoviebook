import 'dart:io';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'dart:typed_data';

import '../models/film.dart';
import '../models/oyuncu.dart';
import '../models/yonetmen.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  static Database? _database;

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper.internal();
      return _databaseHelper!;
    } else
      return _databaseHelper!;
  }

  DatabaseHelper.internal();

  Future<Database> _getDatabase() async {
    if (_database == null) {
      _database = await _initializeDatabase();
      return _database!;
    } else {
      return _database!;
    }
  }

  Future<Database> _initializeDatabase() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "movies.db");

// Check if the database exists
    var exists = await databaseExists(path);

    if (!exists) {
      // Should happen only the first time you launch your application
      print("Creating new copy from asset");

      // Make sure the parent directory exists
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      // Copy from asset
      ByteData data = await rootBundle.load(join("assets", "movies.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      print("Opening existing database");
    }
// open the database
    return await openDatabase(path, readOnly: false);
  }

  Future<List<Yonetmen>> yonetmenListesiniGetir() async {
    List<Yonetmen> tumYonetmenler = [];
    var db = await _getDatabase();
    var sonuc = await db.query("Yonetmen");
    var mapListesi = sonuc;
    for (Map<String, dynamic> map in mapListesi) {
      tumYonetmenler.add(Yonetmen.fromMap(map));
    }
    return tumYonetmenler;
  }

  Future<List<Oyuncu>> oyuncuListesiniGetir() async {
    List<Oyuncu> tumOyuncular = [];
    var db = await _getDatabase();
    var sonuc = await db.query("Oyuncu");
    var mapListesi = sonuc;
    for (Map<String, dynamic> map in mapListesi) {
      tumOyuncular.add(Oyuncu.fromMap(map));
    }
    return tumOyuncular;
  }

  Future<List<Film>>? filmListesiniGetir() async {
    List<Film> tumFilmler = [];
    var db = await _getDatabase();
    var sonuc = await db.query("Film");
    var mapListesi = sonuc;
    for (Map<String, dynamic> map in mapListesi) {
      tumFilmler.add(Film.fromMap(map));
    }
    return tumFilmler;
  }

  Future<int> yonetmenEkle(Yonetmen yonetmen) async {
    var db = await _getDatabase();
    var sonuc = await db.insert("Yonetmen", yonetmen.toMap());
    return sonuc;
  }

  Future<int> oyuncuEkle(Oyuncu oyuncu) async {
    var db = await _getDatabase();
    var sonuc = await db.insert("Oyuncu", oyuncu.toMap());
    return sonuc;
  }

  Future<int> filmEkle(Film film) async {
    var db = await _getDatabase();
    var sonuc = await db.insert("Film", film.toMap());
    return sonuc;
  }

  Future<int> oynamakTablosunaEkle(List<Oyuncu> oyuncular, int filmID) async {
    var db = await _getDatabase();
    var map = Map<String, dynamic>();
    var sonuc;
    for (int i = 0; i < oyuncular.length; i++) {
      map['oyuncu_id'] = oyuncular[i].id;
      map['film_id'] = filmID;
      sonuc = await db.insert("Oynamak", map);
      //print("${oyuncular[i].id} id'li oyuncu $filmID'li filme eklendi");
    }
    return sonuc;
  }

  Future<int> oyuncu_yonetmenTablosunaEkle(
      List<Oyuncu> oyuncular, int yonetmenID,int filmID) async {
    var db = await _getDatabase();
    var map = Map<String, dynamic>();
    var sonuc;
    for (int i = 0; i < oyuncular.length; i++) {
      map['oyuncu_id'] = oyuncular[i].id;
      map['yonetmen_id'] = yonetmenID;
      map['film_id'] = filmID;
      sonuc = await db.insert("Oyuncu_Yonetmen", map);
      //print("${oyuncular[i].id} id'li oyuncu $yonetmenID yönetmenine eklendi");
    }
    return sonuc;
  }

  Future<int> turTablosunaEkle(List<String> turler, filmID) async {
    var db = await _getDatabase();
    var map = Map<String, dynamic>();
    var sonuc;
    for (int i = 0; i < turler.length; i++) {
      map['tur_adi'] = turler[i];
      map['film_id'] = filmID;
      sonuc = await db.insert("Tur", map);
      //print("${turler[i]} kategorisi $filmID filmine eklendi");
    }
    return sonuc;
  }

  Future<int> yorumEkle(int filmID, String yorum) async {
    var db = await _getDatabase();
    var map = Map<String, dynamic>();
    map['film_id'] = filmID;
    map['yorum'] = yorum;
    var sonuc = await db.insert("Yorum", map);
    return sonuc;
  }

  //ekstra ihtiyaçlar

  Future<Film>? adToFilm(String filmAdi) async {
    Film film;
    var db = await _getDatabase();
    var sonuc = await db.rawQuery("select * from Film where ad='$filmAdi'");
    film = Film.fromMap(sonuc[0]);
    return film;
  }
  Future<Yonetmen>? filmToYonetmen(Film film) async{
    Yonetmen yonetmen;
    var db = await _getDatabase();
    var sonuc = await db.rawQuery("select * from Yonetmen where Yonetmen.id = ${film.yonetmen_id}");
    yonetmen = Yonetmen.fromMap(sonuc[0]);
    return yonetmen;
  }

  Future<List<Oyuncu>>? filmToOyuncular(Film film) async {
    List<Oyuncu> filmdekiOyuncular = [];
    var db = await _getDatabase();
    var sonuc = await db.rawQuery(
        "select * from Oyuncu where id IN	(select Oynamak.oyuncu_id from Oynamak where Oynamak.film_id=${film.id})");
    var mapListesi = sonuc;
    for (Map<String, dynamic> map in mapListesi) {
      filmdekiOyuncular.add(Oyuncu.fromMap(map));
    }
    return filmdekiOyuncular;
  }

  Future<List<String>>? filmToKategoriler(Film film)async{
    List<String> filminKategorileri = [];
    var db = await _getDatabase();
    var sonuc = await db.rawQuery("select * from Tur where Tur.film_id =${film.id}");
    var mapListesi = sonuc;
    for(Map<String, dynamic> map in mapListesi){
      filminKategorileri.add(map['tur_adi']);
    }
    return filminKategorileri;
  }

  Future<List<String>>? filmToYorumlar(Film film)async{
    List<String> filminYorumlari = [];
    var db = await _getDatabase();
    var sonuc = await db.rawQuery("select * from Yorum where Yorum.film_id = ${film.id}");
    var mapListesi = sonuc;
    for(Map<String,dynamic> map in mapListesi){
      filminYorumlari.add(map['yorum']);
    }
    return filminYorumlari;
  }

  Future<int>? filmSil(Film film)async{
    var db = await _getDatabase();
    int sonuc = await db.delete("Film", where: 'Film.id = ?', whereArgs: [film.id]);
    //sildi 1
    return sonuc;
  }

  Future<int>? filmiGuncelle(Film film) async {
    var db = await _getDatabase();
    int sonuc = await db.update("Film", film.toMap(), where: "id = ?",whereArgs: [film.id]);
    //debugPrint("filmiGuncelle cevap : "+sonuc.toString());
    return sonuc;
  }

  Future<int>? oynamakTablosunuGuncelle(int filmID, List<Oyuncu> oyuncular) async {
    var db = await _getDatabase();
    int sonuc = await db.delete("Oynamak",where: 'film_id = ?', whereArgs: [filmID]);
    //debugPrint("oynamakTablosunuGuncelle cevap : "+sonuc.toString());
    return await oynamakTablosunaEkle(oyuncular, filmID);

  }

  Future<int>? oyuncu_yonetmen_tablosunu_guncelle(List<Oyuncu> oyuncular, int yonetmenID,int filmID) async {
    var db = await _getDatabase();
    int sonuc = await db.delete("Oyuncu_Yonetmen",where: 'film_id = ?',whereArgs: [filmID]);
    //debugPrint("oyuncu_yonetmen_Guncelle cevap : "+sonuc.toString());
    return await oyuncu_yonetmenTablosunaEkle(oyuncular, yonetmenID, filmID);
  }

  Future<int>? oyuncuSil(Oyuncu oyuncu) async {

    var db = await _getDatabase();
    db.execute("PRAGMA foreign_keys = ON");
    int sonuc = await db.delete("Oyuncu",where: 'id = ?', whereArgs: [oyuncu.id]);
    return sonuc;

  }

  Future<int>? yonetmenSil(Yonetmen yonetmen) async {
    var db = await _getDatabase();
    //int sonuc = await db.delete("Yonetmen",where: "id=?",whereArgs: [yonetmen.id]);
    db.execute("PRAGMA foreign_keys = ON");
    await db.rawQuery("delete from Yonetmen where id=${yonetmen.id}");
    return 1;
  }

  Future<int>? yorumSil(String yorum,Film film) async {
    var db = await _getDatabase();
    await db.rawQuery("delete from Yorum where yorum='${yorum}' and film_id=${film.id}");
    return 1;
  }


}
