import 'package:hive/hive.dart';

part 'score.g.dart';

@HiveType(typeId: 0)
class Score extends HiveObject {
  @HiveField(0)
  late String name;

  @HiveField(1)
  late int value;
}
