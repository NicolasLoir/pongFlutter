import 'package:flutter/material.dart';
import 'package:tp3_jouons_a_ping/NavigationDrawerWidget.dart';
import 'package:tp3_jouons_a_ping/page_acceuil.dart';

class PageAcceuilPong extends StatelessWidget {
  const PageAcceuilPong({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Navigation_drawer_widget(),
      appBar: AppBar(
        title: const Text("Jeu pong"),
        backgroundColor: const Color.fromRGBO(50, 70, 100, 1),
      ),
      body: const SafeArea(child: PageAcceuil()),
    );
  }
}
