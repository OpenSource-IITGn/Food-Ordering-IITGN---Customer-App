//References
//UI inspirations https://www.youtube.com/watch?v=GeMJz3EcBgs&t=2826s
//Misc https://www.youtube.com/results?search_query=raja+yogan+flutter
//LOGIN-SIGNUP-SYSTEM-CODE https://github.com/bizz84/firebase-login-flutter/
import 'package:flutter/material.dart';
import 'auth.dart';
import 'root.dart';
void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Food Order Processing',
      theme: new ThemeData(
        primarySwatch: Colors.orange,
        fontFamily: "Raleway"
      ),
      debugShowCheckedModeBanner: false,
      home: new RootPage(auth: new Auth()),

    );
  }
}