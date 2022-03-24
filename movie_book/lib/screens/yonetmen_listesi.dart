import 'package:flutter/material.dart';
import 'package:movie_app/utils/database_helper.dart';

import '../models/yonetmen.dart';

class YonetmenListesi extends StatefulWidget {
  @override
  _YonetmenListesiState createState() => _YonetmenListesiState();
}

class _YonetmenListesiState extends State<YonetmenListesi> {
  List<Yonetmen>? tumYonetmenler;
  late DatabaseHelper databaseHelper;
  @override
  void initState() {
    super.initState();
    databaseHelper = DatabaseHelper();
  }

  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 40,
            color: Colors.blue,
            //child: Center(child: Text("YÖNETMENLER",style: TextStyle(fontSize: 32,fontWeight: FontWeight.bold),)),
          ),
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              //height: MediaQuery.of(context).size.height,
              color: Colors.blue,
              child: FutureBuilder(
                future: _yonetmenleriGetir(),
                builder: (context, AsyncSnapshot<List<Yonetmen>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: Text(
                          "YÖNETMEN LİSTESİ BOŞ",
                          style: TextStyle(fontSize: 32, color: Colors.white),
                        ),
                      );
                    } else {
                      return ListView.builder(
                          itemCount: tumYonetmenler!.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.pop(context, tumYonetmenler![index]);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListTile(
                                  leading: AspectRatio(
                                    aspectRatio: 1 / 1,
                                    child: ClipOval(
                                      child: FadeInImage.assetNetwork(
                                          placeholder: 'assets/loading.gif', image: tumYonetmenler![index].pic_url!,fit: BoxFit.cover,),
                                    ),
                                  ),
                                  title: Text(tumYonetmenler![index].ad.toString() +
                                      " " +
                                      tumYonetmenler![index].soyad.toString()),
                                  trailing: InkWell(
                                        onTap: () {
                                          _yonetmenSil(tumYonetmenler![index],
                                              tumYonetmenler!, index);
                                        },
                                        child: Icon(
                                          Icons.delete,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                      
                                ),
                              ),
                            );
                          });
                    }
                  } else {
                    return Center(
                      child: Text("Bekleniyor"),
                    );
                  }
                },
              ),
              /*ListView.builder(
                  itemCount: tumYonetmenler!.length,
                  itemBuilder: (context, index) {
                    if (tumYonetmenler == null || tumYonetmenler!.isEmpty)
                      return Center(
                        child: Text(
                          "YÖNETMEN LİSTESİ BOŞ",
                          style: TextStyle(fontSize: 32, color: Colors.white),
                        ),
                      );
                    else {
                      return InkWell(
                        onTap: (){
                          Navigator.pop(context,tumYonetmenler![index]);
                        },
                        child: ListTile(
                          leading: CircleAvatar(
                              child:
                                  Image.network(tumYonetmenler![index].pic_url!)),
                                  title: Text(tumYonetmenler![index].ad.toString()+" "+tumYonetmenler![index].soyad.toString()),
                        ),
                      );
                    }
                  }),*/
            ),
          ),
        ],
      ),
    );
  }

  Future<List<Yonetmen>> _yonetmenleriGetir() async {
    return tumYonetmenler = await databaseHelper.yonetmenListesiniGetir();
  }

    _yonetmenSil(Yonetmen yonetmen, List<Yonetmen> tumYonetmenler, int index) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Yönetmeni Sil"),
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
                      await databaseHelper.yonetmenSil(yonetmen);
                      tumYonetmenler.removeAt(index);
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
