import 'package:flutter/material.dart';

class Balle extends StatelessWidget {
  double diametre;

  Balle(this.diametre);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diametre,
      height: diametre,
      decoration: BoxDecoration(
        color: Colors.amber[400],
        shape: BoxShape.circle,
      ),
    );
  }
}
