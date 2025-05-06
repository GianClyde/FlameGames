import 'package:flame/game.dart';
import 'package:flame_practice/game.dart';
import 'package:flame_practice/models/room.dart';
import 'package:flame_practice/models/user.dart';
import 'package:flame_practice/overlay/betting/betting.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() {
  final MyGame game = MyGame(
    room: Room(
      roomId: "ASdsad",
      userList: [
        User(id: "12345", userName: "Me"),
        User(id: "54211", userName: "You"),
        User(id: "54211", userName: "Us"),
      ],
    ),
  );

  runApp(
    MaterialApp(
      home: Scaffold(
        body: GameWidget(
          game: game,
          backgroundBuilder: (context) => const SizedBox.shrink(),
          overlayBuilderMap: {
            'better': (context, game) => Positioned(left: 100, child: Better()),
          },
        ),
      ),
    ),
  );
}
