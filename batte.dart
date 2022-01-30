import 'package:flutter/material.dart';

class Batte extends StatelessWidget {
  final double largeur;
  final double hauteur;

  Batte(this.largeur, this.hauteur);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: largeur,
      height: hauteur,
      decoration: BoxDecoration(
        color: Colors.blue[900],
      ),
    );
  }
}
