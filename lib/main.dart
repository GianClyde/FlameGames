import 'package:flame/game.dart';
import 'package:flame_practice/game.dart';
import 'package:flame_practice/models/player.dart';
import 'package:flame_practice/models/room.dart';
import 'package:flutter/widgets.dart';

void main() {
  final MyGame game = MyGame(
    room: Room(
      roomId: "ASdsad",
      listPlayers: [
        PlayerModel(user: "user", isTurn: true, card1: null, card2: null),
        PlayerModel(user: "fghfgh", isTurn: true, card1: null, card2: null),
      ],
    ),
  );
  runApp(GameWidget(game: game));
}
