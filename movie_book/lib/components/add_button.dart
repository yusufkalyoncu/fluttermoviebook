import 'package:flutter/material.dart';


import '../screens/add_screen.dart';

class AddMovie extends StatelessWidget {
  const AddMovie({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      alignment: Alignment.topLeft,
      child: TextButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=> AddScreen()));
          },
          child: Text(
            "Film Ekle",
            style: TextStyle(fontSize: 24),
          )),
    );
  }
}
