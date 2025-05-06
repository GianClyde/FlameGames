import 'package:flame/game.dart';
import 'package:flame_practice/game.dart';
import 'package:flame_practice/models/room.dart';
import 'package:flame_practice/models/user.dart';
import 'package:flutter/widgets.dart';

void main() {
  final MyGame game = MyGame(
    room: Room(
      roomId: "ASdsad",
      userList: [
        User(id: "12345", userName: "Me"),
        User(id: "54211", userName: "You"),
      ],
    ),
  );
  runApp(GameWidget(game: game));
}
