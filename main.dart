import 'package:flutter/material.dart';
import 'package:tp3_jouons_a_ping/page_acceuil_pong.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tp3_jouons_a_ping/score.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

// bug en dessous
  await Hive.initFlutter();

  Hive.registerAdapter(ScoreAdapter());
  await Hive.openBox<Score>('scores');

  runApp(MyApp());
}
// void main() {
//   runApp(MyApp());
// }

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jeu pong',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PageAcceuilPong(),
    );
  }
}
