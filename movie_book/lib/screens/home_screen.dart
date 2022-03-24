import 'package:flutter/material.dart';
import 'package:movie_app/screens/add_screen.dart';
import 'package:movie_app/screens/film_detay.dart';
import 'package:movie_app/screens/update_screen.dart';
import '../components/main_title.dart';
import '../models/film.dart';
import '../models/oyuncu.dart';
import '../models/yonetmen.dart';
import '../utils/database_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  @override
  late DatabaseHelper databaseHelper;

  List<Yonetmen>? tumYonetmenler;
  List<Oyuncu>? tumOyuncular;
  List<Film>? tumFilmler;

  void initState() {
    super.initState();
    databaseHelper = DatabaseHelper();
  }

  Widget build(BuildContext context) {
    @override
    Size size = MediaQuery.of(context).size;
    return Material(
      child: Container(
        padding: EdgeInsets.all(20),
        height: size.height,
        width: size.width,
        color: Colors.black,
        child: Column(
          children: [
            MainTitle(),
            TextButton(
                onPressed: () async {
                  await Navigator.push(context,
                          MaterialPageRoute(builder: (context) => AddScreen()))
                      .then((value) {
                    setState(() {});
                  });
                },
                child: Text(
                  "EKLE",
                  style: TextStyle(color: Colors.white, fontSize: 24),
                )),
            Container(
                color: Colors.grey.shade900,
                width: 350,
                height: 450,
                child: FutureBuilder(
                  future: _filmleriGetir(),
                  builder: (context, AsyncSnapshot<List<Film>?> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.data!.length == 0)
                        return Center(
                          child: Text(
                            "Film Listesi Boş",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        );
                      else
                        return GridView.builder(
                            itemCount: snapshot.data!.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    childAspectRatio: 0.69,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 2,
                                    crossAxisCount: 2),
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => FilmDetay(
                                              snapshot.data![index])));
                                },
                                onLongPress: () async {
                                  await showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text("Filmi Sil"),
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
                                                    await databaseHelper
                                                        .filmSil(snapshot
                                                            .data![index]);
                                                    setState(() {});
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text(
                                                    "SİL",
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.green),
                                                  )),
                                              TextButton(
                                                  onPressed: () async {
                                                    await Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                UpdateScreen(
                                                                    snapshot.data![
                                                                        index])));
                                                  },
                                                  child: Text(
                                                    "GÜNCELLE",
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
                                splashColor: Colors.deepOrange,
                                child: Card(
                                  elevation: 6,
                                  child: Column(
                                    children: [
                                      Hero(
                                        tag: snapshot.data![index].ad!,
                                        child: Container(
                                          height: 235,
                                          width: 175,
                                          child: FadeInImage.assetNetwork(
                                            placeholder: 'assets/loading.gif',
                                            image: snapshot.data![index].pp_url
                                                .toString(),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            });
                    } else
                      return Text("Yükleniyor...");
                  },
                )),
          ],
        ),
      ),
    );
  }

  Future<List<Film>?> _filmleriGetir() async {
    tumOyuncular = await databaseHelper.oyuncuListesiniGetir();
    tumYonetmenler = await databaseHelper.yonetmenListesiniGetir();
    tumFilmler = await databaseHelper.filmListesiniGetir();
    return tumFilmler;
  }
}
