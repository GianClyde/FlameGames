import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';

class PlayerTurnArrow extends SpriteComponent {
  final bool isTurn;
  bool isVisible = false;

  PlayerTurnArrow({required this.isTurn, super.size, super.position});

  @override
  FutureOr<void> onLoad() async {
    final arrowSprite = await Flame.images.load('player_arrow.png');
    sprite = Sprite(arrowSprite);
    return super.onLoad();
  }
}
