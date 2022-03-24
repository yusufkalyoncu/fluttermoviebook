import 'package:flutter/material.dart';

class MainTitle extends StatelessWidget {
  const MainTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.all(1),
      width: 500,
      height: 80,
      color: Colors.black,
      child: Text(
        "MOVIES",
        style: TextStyle(
          color: Colors.red,
          fontSize: 62,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
