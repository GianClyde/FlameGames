import 'package:flame/game.dart';
import 'package:flame_practice/game.dart';
import 'package:flutter/material.dart';

void main() {
  final MyGame game = MyGame(playersCount: 1);
  runApp(GameWidget(game: game));
}
