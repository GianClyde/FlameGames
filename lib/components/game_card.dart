import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/timer.dart';
import 'package:flame_practice/game.dart';

class GameCard extends PositionComponent with HasGameReference<MyGame> {
  late SpriteComponent front;
  late SpriteComponent back;
  late Timer _flipTimer;

  bool isFlipped = false;

  GameCard({
    required Sprite frontSprite,
    required Sprite backSprite,
    super.position,
    Vector2? size,
  }) : super(size: size, priority: 10) {
    front = SpriteComponent(sprite: frontSprite, size: size);
    back = SpriteComponent(sprite: backSprite, size: size);

    _flipTimer = Timer(5, onTick: flipCard, repeat: false);
  }

  @override
  Future<void> onLoad() async {
    add(back);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _flipTimer.update(dt);
  }

  void flipCard() {
    // Flip animation using scale effect
    add(
      ScaleEffect.to(
        Vector2(0, 1),
        EffectController(duration: 0.3),
        onComplete: () {
          remove(back);
          add(front);

          // Animate the scale back to full size
          add(ScaleEffect.to(Vector2(1, 1), EffectController(duration: 0.3)));

          isFlipped = true;
        },
      ),
    );
  }
}
