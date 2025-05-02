import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_practice/game.dart';

class Table extends SpriteComponent with HasGameReference<MyGame> {
  static const double _maxSize = 500;

  Table({required super.position, double size = _maxSize})
    : super(size: Vector2(850, 450), anchor: Anchor.center, priority: 1);

  @override
  FutureOr<void> onLoad() async {
    sprite = await game.loadSprite("gametable.png");
    return super.onLoad();
  }
}
