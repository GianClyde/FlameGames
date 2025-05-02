import 'package:flame_practice/models/card.dart';

class PlayerModel {
  final String userName;
  final Card card1;
  final Card card2;

  PlayerModel({
    required this.userName,
    required this.card1,
    required this.card2,
  });
}
