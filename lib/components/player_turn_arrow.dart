import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';

class PlayerTurnArrow extends SpriteComponent {
  PlayerTurnArrow({super.size, super.position, super.scale});

  @override
  FutureOr<void> onLoad() async {
    final arrowSprite = await Flame.images.load('player_arrow.png');
    sprite = Sprite(arrowSprite);
    size = Vector2(35, 35);
    position = Vector2(size.x - 15, size.y - 85);
    priority = 15;
    return super.onLoad();
  }

  void show() {
    opacity = 1.0;
  }

  // void hide() {
  //   opacity = 0.0;
  // }
}
