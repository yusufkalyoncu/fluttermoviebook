import 'package:flutter/material.dart';
import 'package:movie_app/screens/home_screen.dart';

import 'constant.dart';


void main() {
  runApp(MyApp());
}
//C:\flutter_projects\movie_app\movie_app
class MyApp extends StatelessWidget {
  const MyApp({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Movies",
      theme: ThemeData(
        primarySwatch: Const.white
        //primaryColor: Const.kPrimaryColor,
      ),
      home: HomeScreen(),
      
    );
  }
}