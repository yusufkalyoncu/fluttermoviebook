import 'package:flutter/material.dart';

class KategoriListesi extends StatefulWidget {
  const KategoriListesi({Key? key}) : super(key: key);

  @override
  _KategoriListesiState createState() => _KategoriListesiState();
}

class _KategoriListesiState extends State<KategoriListesi> {
  @override
  List<String> kategoriler = [
    'Animasyon',
    'Aksiyon',
    'Belgesel',
    'Bilim Kurgu',
    'Biyografi',
    'Casusluk',
    'Çizgi Roman',
    'Dini',
    'Fantastik',
    'Gerilim',
    'Korku',
    'Komedi',
    'Macera',
    'Müzikal',
    'Romantik',
    'Savaş',
    'Spor',
    'Tarihi',
    'Uzay',
    'Video Oyunu',
    'Western',
    'Gençlik'
  ];
  List<String> secilenKategoriler = [];

  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 100,
            child: ListView.builder(
                itemCount: kategoriler.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      if (secilenKategoriler.contains(kategoriler[index])) {
                        secilenKategoriler.remove(kategoriler[index]);
                      } else {
                        secilenKategoriler.add(kategoriler[index]);
                      }
                      setState(() {});
                    },
                    leading: CircleAvatar(
                      child: Icon(Icons.category),
                    ),
                    title: Text(
                      kategoriler[index],
                      style: TextStyle(fontSize: 22),
                    ),
                    tileColor: secilenKategoriler.contains(kategoriler[index])
                        ? Colors.green
                        : Colors.grey,
                  );
                }),
          ),
          Expanded(
              child: Container(
            color: Colors.grey.shade400,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(onPressed: (){Navigator.pop(context);}, child: Text("VAZGEÇ",style: TextStyle(color: Colors.red,fontSize: 18),)),
                TextButton(onPressed: (){Navigator.pop(context,secilenKategoriler);}, child: Text("KAYDET",style: TextStyle(color: Colors.green,fontSize: 18),))
              ],
            ),
          ))
        ],
      ),
    );
  }
}
