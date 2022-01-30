// ignore_for_file: camel_case_types, file_names

import 'package:flutter/material.dart';
import 'package:tp3_jouons_a_ping/score.dart';

class TableauScore extends StatefulWidget {
  List<Score> _scores;

  TableauScore(this._scores, {Key? key}) : super(key: key);

  @override
  _TableauScoreState createState() => _TableauScoreState();
}

class _TableauScoreState extends State<TableauScore> {
  @override
  Widget build(BuildContext context) {
    // var items = box.values.toList();
    // https://github.com/hivedb/hive/issues/198

    widget._scores.sort((a, b) => b.value.compareTo(a.value));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tableau des scores"),
        backgroundColor: const Color.fromRGBO(50, 70, 100, 1),
      ),
      body: buildContent(widget._scores),
    );
  }

  Widget buildContent(List<Score> scores) {
    if (scores.isEmpty) {
      return const Center(
        child: Text(
          'No scores yet!',
          style: TextStyle(fontSize: 24),
        ),
      );
    } else {
      return Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: scores.length,
              itemBuilder: (BuildContext context, int index) {
                final score = scores[index];

                return buildTransaction(context, score);
              },
            ),
          ),
        ],
      );
    }
  }

  Widget buildTransaction(
    BuildContext context,
    Score score,
  ) {
    return Column(
      children: [
        Text(
          "${score.value.toString()}-${score.name}",
          style: const TextStyle(fontSize: 30),
          maxLines: 1,
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 20,
        )
      ],
    );

    // Card(
    //   color: Colors.white,
    //   child: ExpansionTile(
    //     tilePadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
    //     title: Text(
    //       score.name,
    //       maxLines: 2,
    //       style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
    //     ),
    //     subtitle: Text(score.value.toString()),
    //     // trailing: Text(
    //     //   score.value.toString(),
    //     //   style: const TextStyle(
    //     //       color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
    //     // ),
    //     // children: const [],
    //   ),
    // );
  }
}
