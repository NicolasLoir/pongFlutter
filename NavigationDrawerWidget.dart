// ignore_for_file: camel_case_types, file_names

import 'package:flutter/material.dart';
import 'package:tp3_jouons_a_ping/PongVersus.dart';
import 'package:tp3_jouons_a_ping/pong.dart';
import 'package:tp3_jouons_a_ping/score.dart';
import 'package:tp3_jouons_a_ping/tableauScore.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Navigation_drawer_widget extends StatelessWidget {
  Navigation_drawer_widget({Key? key}) : super(key: key);

  final padding = const EdgeInsets.symmetric(horizontal: 20);

  final List<Score> scores = [];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        color: const Color.fromRGBO(50, 70, 100, 1),
        child: ListView(
          padding: padding,
          children: <Widget>[
            const SizedBox(
              height: 48,
            ),
            buildMenuItem(
              text: 'Score',
              icon: Icons.stacked_bar_chart_sharp,
              onClicked: () => selectedItem(context, 0),
            ),
            const SizedBox(
              height: 16,
            ),
            buildMenuItem(
              text: 'Solo',
              icon: Icons.smart_toy_outlined,
              onClicked: () => selectedItem(context, 1),
            ),
            const SizedBox(
              height: 16,
            ),
            buildMenuItem(
              text: 'VS',
              icon: Icons.people,
              onClicked: () => selectedItem(context, 2),
            ),
            const SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMenuItem(
      {required String text, required IconData icon, VoidCallback? onClicked}) {
    final color = Colors.white;

    return ListTile(
        leading: Icon(
          icon,
          color: color,
          size: 30,
        ),
        title: Text(
          text,
          style: TextStyle(color: color),
          textAlign: TextAlign.justify,
        ),
        hoverColor: color,
        onTap: onClicked);
  }

  void selectedItem(BuildContext context, int index) {
    Navigator.of(context).pop();
    switch (index) {
      case 0:
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ValueListenableBuilder<Box<Score>>(
                  valueListenable: Hive.box<Score>('scores').listenable(),
                  builder: (context, box, _) {
                    final score_bd = box.values.toList().cast<Score>();

                    return TableauScore(score_bd);
                  },
                )));
        break;
      case 1:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Pong(scores),
        ));
        break;
      case 2:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const PongVersus(),
        ));
        break;
    }
  }
}
