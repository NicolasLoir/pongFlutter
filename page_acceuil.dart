// ignore_for_file: file_names

import 'package:flutter/material.dart';

class PageAcceuil extends StatelessWidget {
  const PageAcceuil({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text(
            "Bienvenue sur PONG",
            style: TextStyle(fontSize: 40),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
