import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tp3_jouons_a_ping/balle.dart';
import 'package:tp3_jouons_a_ping/batte.dart';
import 'package:tp3_jouons_a_ping/score.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

enum Direction { haut, bas, gauche, droite }

class Pong extends StatefulWidget {
  List<Score> _scores;
  Pong(this._scores, {Key? key}) : super(key: key);

  @override
  _PongState createState() => _PongState();
}

class _PongState extends State<Pong> with SingleTickerProviderStateMixin {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();

  static const INITIAL_SPEED = 4.5;
  double largeurScreen = 400; //espace dispo sur écran
  double hauteurScreen = 400; //espace dispo sur écran
  late double posX; //position de la balle
  late double posY; //position de la balle
  double largeurBatte = 0;
  double hauteurObj = 0;
  double positionBatte = 0;
  double increment = INITIAL_SPEED;
  int score = 0;

  late Animation animation;
  late AnimationController controleur;

  Direction vDir = Direction.bas;
  Direction hDir = Direction.droite;

  late double randX;
  late double randY;

  @override
  void initState() {
    posX = 0;
    posY = 0;
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
    // Hive.close();
    controleur.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SOLO"),
        backgroundColor: const Color.fromRGBO(50, 70, 100, 1),
      ),
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
                        deplacerBatte(maj, context),
                    child: Batte(largeurBatte, hauteurObj),
                  ),
                  bottom: 0,
                  left: positionBatte,
                ),
                Positioned(
                  child: Balle(hauteurObj),
                  top: posY,
                  left: posX,
                ),
                Positioned(
                  top: 0,
                  right: 24,
                  child: Text('Score: ' + score.toString()),
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
      increment += acceleration;
    }
    if (posX >= largeurScreen - hauteurObj && hDir == Direction.droite) {
      hDir = Direction.gauche;
      randX = nombreAleatoire();
      increment += acceleration;
    }
    if (posY >= hauteurScreen - hauteurObj * 2 && vDir == Direction.bas) {
      if (posX >= (positionBatte - hauteurObj) &&
          posX <= (positionBatte + largeurBatte + hauteurObj)) {
        score++;
        increment += nombreAleatoire();
        vDir = Direction.haut;
        randY = nombreAleatoire();
      } else {
        controleur.stop();
        afficherMessage(context);
      }
    }
    if (posY <= 0 && vDir == Direction.haut) {
      vDir = Direction.bas;
      randY = nombreAleatoire();
      increment += acceleration;
    }
  }

  void deplacerBatte(DragUpdateDetails maj, BuildContext context) {
    safeSetState(() {
      positionBatte += maj.delta.dx;
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
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  buildName(),
                  const Text('Voulez vous faire une autre partie?'),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: const Color.fromRGBO(50, 70, 100, 1),
              ),
              child: const Text('Oui'),
              onPressed: () async {
                final isValid = formKey.currentState!.validate();

                if (isValid) {
                  add_score(score, nameController.text);
                  setState(() {
                    posX = 0;
                    posY = 0;
                    randX = nombreAleatoire();
                    randY = nombreAleatoire();
                    score = 0;
                    increment = INITIAL_SPEED;
                  });
                  Navigator.of(context).pop();
                  controleur.repeat();
                }
              },
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: const Color.fromRGBO(50, 70, 100, 1),
                ),
                child: const Text('Non'),
                onPressed: () async {
                  final isValid = formKey.currentState!.validate();

                  if (isValid) {
                    add_score(score, nameController.text);
                    Navigator.of(context).pop();
                    // dispose(); -> called with the second pop
                    Navigator.of(context).pop();
                  }
                }),
          ],
        );
      },
    );
  }

  void add_score(int valeur, String nom) {
    final Score un_score = Score()
      ..name = nom
      ..value = valeur;
    // widget._scores.add(un_score);
    Hive.box<Score>('scores').add(un_score);
  }

  double nombreAleatoire() {
    var alea = Random();
    int monNombre = alea.nextInt(41);
    return (80 + monNombre) / 100;
  }

  Widget buildName() => TextFormField(
        controller: nameController,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Entrer votre nom',
        ),
        validator: (name) =>
            name != null && name.isEmpty ? 'Donner votre nom' : null,
      );
}
