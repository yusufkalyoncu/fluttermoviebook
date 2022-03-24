import 'package:flutter/material.dart';

import '../models/oyuncu.dart';
import '../utils/database_helper.dart';

class OyuncuListesi extends StatefulWidget {
  @override
  _OyuncuListesiState createState() => _OyuncuListesiState();
}

class _OyuncuListesiState extends State<OyuncuListesi> {
  List<Oyuncu>? tumOyuncular;
  late DatabaseHelper databaseHelper;
  @override
  void initState() {
    super.initState();
    databaseHelper = DatabaseHelper();
  }

  @override
  List<Oyuncu>? secilenOyuncular = [];
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 50,
            child: tumOyuncular == null
                ? FutureBuilder(
                    future: _oyunculariGetir(),
                    builder: (context, AsyncSnapshot<List<Oyuncu>?> snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                              itemCount: tumOyuncular!.length,
                              itemBuilder: (context, index) {
                                if (tumOyuncular == null ||
                                    tumOyuncular!.isEmpty)
                                  return Center(
                                    child: Text(
                                      "OYUNCU LİSTESİ BOŞ",
                                      style: TextStyle(
                                          fontSize: 32, color: Colors.white),
                                    ),
                                  );
                                else {
                                  return Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: ListTile(
                                      onTap: () {
                                        if (secilenOyuncular!
                                            .contains(tumOyuncular![index])) {
                                          secilenOyuncular!
                                              .remove(tumOyuncular![index]);
                                        } else {
                                          secilenOyuncular!
                                              .add(tumOyuncular![index]);
                                        }
                                        setState(() {});
                                      },
                                      tileColor: secilenOyuncular!
                                              .contains(tumOyuncular![index])
                                          ? Colors.green
                                          : Colors.white,
                                      leading: CircleAvatar(
                                          backgroundColor: Colors.red,
                                          backgroundImage: NetworkImage(
                                              tumOyuncular![index].pic_url!)),
                                      title: Text(
                                          tumOyuncular![index].ad.toString() +
                                              " " +
                                              tumOyuncular![index]
                                                  .soyad
                                                  .toString()),
                                      trailing: InkWell(
                                        onTap: () {
                                          _oyuncuSil(tumOyuncular![index],
                                              tumOyuncular!, index);
                                        },
                                        child: Icon(
                                          Icons.delete,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              });
                        } else {
                          return Center(
                            child: Text("Yönetmen Listesi Boş"),
                          );
                        }
                      } else {
                        return Center(
                          child: Text("Bekleniyor..."),
                        );
                      }
                    },
                  )
                : ListView.builder(
                    itemCount: tumOyuncular!.length,
                    itemBuilder: (context, index) {
                      if (tumOyuncular == null || tumOyuncular!.isEmpty)
                        return Center(
                          child: Text(
                            "OYUNCU LİSTESİ BOŞ",
                            style: TextStyle(fontSize: 32, color: Colors.white),
                          ),
                        );
                      else {
                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: ListTile(
                            onTap: () {
                              if (secilenOyuncular!
                                  .contains(tumOyuncular![index])) {
                                secilenOyuncular!.remove(tumOyuncular![index]);
                              } else {
                                secilenOyuncular!.add(tumOyuncular![index]);
                              }
                              setState(() {});
                            },
                            tileColor:
                                secilenOyuncular!.contains(tumOyuncular![index])
                                    ? Colors.green
                                    : Colors.white,
                            leading: ClipOval(
                              child: Image.network(
                                tumOyuncular![index].pic_url!,
                                width: 40,
                                height: 40,
                                fit: BoxFit.cover,
                              ),
                            ),
                            /*CircleAvatar(
                                child: Image.network(
                                    tumOyuncular![index].pic_url!)),*/
                            title: Text(tumOyuncular![index].ad.toString() +
                                " " +
                                tumOyuncular![index].soyad.toString()),
                            trailing: InkWell(
                              onTap: () {
                                _oyuncuSil(
                                    tumOyuncular![index], tumOyuncular!, index);
                              },
                              child: Icon(
                                Icons.delete,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                        );
                      }
                    }),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "VAZGEÇ",
                    style: TextStyle(fontSize: 14, color: Colors.red),
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context, secilenOyuncular);
                  },
                  child: Text(
                    "ONAYLA",
                    style: TextStyle(fontSize: 14, color: Colors.green),
                  ))
            ],
          )
        ],
      ),
    );
  }

  Future<List<Oyuncu>?> _oyunculariGetir() async {
    return tumOyuncular = await databaseHelper.oyuncuListesiniGetir();
  }

  _oyuncuSil(Oyuncu oyuncu, List<Oyuncu> tumOyuncular, int index) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Oyuncuyu Sil"),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {});
                    },
                    child: Text(
                      "VAZGEÇ",
                      style: TextStyle(fontSize: 16, color: Colors.red),
                    )),
                TextButton(
                    onPressed: () async {
                      await databaseHelper.oyuncuSil(oyuncu);
                      tumOyuncular.removeAt(index);
                      setState(() {});
                      Navigator.pop(context);
                    },
                    child: Text(
                      "SİL",
                      style: TextStyle(fontSize: 16, color: Colors.green),
                    )),
              ],
            ),
          );
        });
  }
}

/*
ListView.builder(
                itemCount: tumOyuncular!.length,
                itemBuilder: (context, index) {
                  if (tumOyuncular == null ||
                      tumOyuncular!.isEmpty)
                    return Center(
                      child: Text(
                        "OYUNCU LİSTESİ BOŞ",
                        style: TextStyle(fontSize: 32, color: Colors.white),
                      ),
                    );
                  else {
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ListTile(
                        onTap: () {
                          if (secilenOyuncular!
                              .contains(tumOyuncular![index])) {
                            secilenOyuncular!
                                .remove(tumOyuncular![index]);
                          } else {
                            secilenOyuncular!.add(tumOyuncular![index]);
                          }
                          setState(() {});
                        },
                        tileColor: secilenOyuncular!
                                .contains(tumOyuncular![index])
                            ? Colors.green
                            : Colors.white,
                        leading: CircleAvatar(
                            child: Image.network(
                                tumOyuncular![index].pic_url!)),
                        title: Text(tumOyuncular![index].ad.toString() +
                            " " +
                            tumOyuncular![index].soyad.toString()),
                      ),
                    );
                  }
                }),
 */