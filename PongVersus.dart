// ignore_for_file: file_names
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tp3_jouons_a_ping/balle.dart';
import 'package:tp3_jouons_a_ping/batte.dart';

enum Direction { haut, bas, gauche, droite }

class PongVersus extends StatefulWidget {
  const PongVersus({Key? key}) : super(key: key);

  @override
  _PongVersusState createState() => _PongVersusState();
}

class _PongVersusState extends State<PongVersus>
    with SingleTickerProviderStateMixin {
  static const INITIAL_SPEED = 4.5;
  double largeurScreen = 400; //espace dispo sur écran
  double hauteurScreen = 400; //espace dispo sur écran
  late double posX; //position de la balle
  late double posY; //position de la balle
  double largeurBatte = 0;
  double hauteurObj = 0;
  double positionBatteBot = 0;
  double positionBatteTop = 0;
  double increment = INITIAL_SPEED;
  int score_haut = 0;
  int score_bas = 0;

  late Animation animation;
  late AnimationController controleur;

  Direction vDir = Direction.haut;
  Direction hDir = Direction.droite;

  late double randX;
  late double randY;

  @override
  void initState() {
    posX = largeurScreen / 2;
    posY = hauteurScreen / 2;
    randX = nombreAleatoire();
    randY = nombreAleatoire();
    controleur = AnimationController(
      duration: const Duration(minutes: 10000),
      vsync: this,
    );
    animation = Tween<double>(begin: 0, end: 100).animate(controleur);
    animation.addListener(() {
      safeSetState(() {
        (hDir == Direction.droite)
            ? posX += ((increment * randX).round())
            : posX -= ((increment * randX).round());
        (vDir == Direction.bas)
            ? posY += ((increment * randY).round())
            : posY -= ((increment * randY).round());
        testerBordures();
      });
    });
    controleur.forward();
    super.initState();
  }

  @override
  void dispose() {
    controleur.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints contraints) {
            hauteurScreen = contraints.maxHeight;
            largeurScreen = contraints.maxWidth;
            largeurBatte = largeurScreen / 5;
            hauteurObj = hauteurScreen / 20;
            return Stack(
              children: <Widget>[
                Positioned(
                  child: GestureDetector(
                    onHorizontalDragUpdate: (DragUpdateDetails maj) =>
                        deplacerBatteTop(maj, context),
                    child: Batte(largeurBatte, hauteurObj),
                  ),
                  top: 0,
                  left: positionBatteTop,
                ),
                Positioned(
                  child: GestureDetector(
                    onHorizontalDragUpdate: (DragUpdateDetails maj) =>
                        deplacerBatteBot(maj, context),
                    child: Batte(largeurBatte, hauteurObj),
                  ),
                  bottom: 0,
                  left: positionBatteBot,
                ),
                Positioned(
                  child: Balle(hauteurObj),
                  top: posY,
                  left: posX,
                ),
                Positioned(
                  top: 20,
                  right: 24,
                  child: Text('Score: ' + score_bas.toString()),
                ),
                Positioned(
                  bottom: 20,
                  right: 24,
                  child: Text('Score: ' + score_haut.toString()),
                ),
                Positioned(
                  top: hauteurScreen / 2 - 20,
                  left: 0,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: const Color.fromRGBO(50, 70, 100, 1),
                      textStyle: const TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      semanticLabel: 'Home',
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void testerBordures() {
    const acceleration = 0.05;
    if (posX <= 0 && hDir == Direction.gauche) {
      hDir = Direction.droite;
      randX = nombreAleatoire();
      increment += acceleration / 2;
    }
    if (posX >= largeurScreen - hauteurObj && hDir == Direction.droite) {
      hDir = Direction.gauche;
      randX = nombreAleatoire();
      increment += acceleration / 2;
    }
    if (posY >= hauteurScreen - hauteurObj * 2 && vDir == Direction.bas) {
      if (posX >= (positionBatteBot - hauteurObj) &&
          posX <= (positionBatteBot + largeurBatte + hauteurObj)) {
        increment += nombreAleatoire();
        vDir = Direction.haut;
        randY = nombreAleatoire();
      } else {
        score_bas++;
        controleur.stop();
        afficherMessage(context);
      }
    }
    if (posY <= 0 + hauteurObj && vDir == Direction.haut) {
      if (posX >= (positionBatteTop - hauteurObj) &&
          posX <= (positionBatteTop + largeurBatte + hauteurObj)) {
        increment += nombreAleatoire();
        vDir = Direction.bas;
        randY = nombreAleatoire();
      } else {
        score_haut++;
        controleur.stop();
        afficherMessage(context);
      }
    }
  }

  void deplacerBatteBot(DragUpdateDetails maj, BuildContext context) {
    safeSetState(() {
      positionBatteBot += maj.delta.dx;
    });
  }

  void deplacerBatteTop(DragUpdateDetails maj, BuildContext context) {
    safeSetState(() {
      positionBatteTop += maj.delta.dx;
    });
  }

  void safeSetState(Function function) {
    if (mounted && controleur.isAnimating) {
      setState(() {
        function();
      });
    }
  }

  void afficherMessage(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Fin du jeu'),
          content: const Text('Voulez vous faire une autre partie?'),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: const Color.fromRGBO(50, 70, 100, 1),
              ),
              child: const Text('Oui'),
              onPressed: () {
                setState(() {
                  posX = largeurScreen / 2;
                  posY = hauteurScreen / 2;
                  randX = nombreAleatoire();
                  randY = nombreAleatoire();
                  increment = INITIAL_SPEED;
                });
                Navigator.of(context).pop();
                controleur.repeat();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: const Color.fromRGBO(50, 70, 100, 1),
              ),
              child: const Text('Non'),
              onPressed: () {
                Navigator.of(context).pop();
                // dispose(); -> called with the second pop
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  double nombreAleatoire() {
    var alea = Random();
    int monNombre = alea.nextInt(41);
    return (80 + monNombre) / 100;
  }
}
