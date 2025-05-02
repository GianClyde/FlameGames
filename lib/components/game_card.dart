import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_practice/game.dart';

class GameCard extends PositionComponent with HasGameReference<MyGame> {
  late SpriteComponent front;
  late SpriteComponent back;

  bool isFlipped = false;

  GameCard({
    required Sprite frontSprite,
    required Sprite backSprite,
    super.position,
    Vector2? size,
  }) : super(size: size, priority: 10) {
    front = SpriteComponent(sprite: frontSprite, size: size);
    back = SpriteComponent(sprite: backSprite, size: size);
  }

  @override
  Future<void> onLoad() async {
    add(back);
  }

  void startFlip() {
    if (isFlipped) return;

    add(
      ScaleEffect.to(
        Vector2(0, 1),
        EffectController(duration: 0.3),
        onComplete: () {
          remove(back);
          add(front);
          add(ScaleEffect.to(Vector2(1, 1), EffectController(duration: 0.3)));

          isFlipped = true;
        },
      ),
    );
  }
}
