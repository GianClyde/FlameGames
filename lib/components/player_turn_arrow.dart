import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';

class PlayerTurnArrow extends SpriteComponent {
  PlayerTurnArrow({super.size, super.position});

  @override
  FutureOr<void> onLoad() async {
    final arrowSprite = await Flame.images.load('player_arrow.png');
    sprite = Sprite(arrowSprite);
    return super.onLoad();
  }

  void show() {
    opacity = 1.0;
  }

  void hide() {
    opacity = 0.0;
  }
}
