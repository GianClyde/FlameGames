import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_practice/game.dart';
import 'package:flame_practice/models/card.dart';

class GameCard extends PositionComponent with HasGameReference<MyGame> {
  late SpriteComponent front;
  late SpriteComponent back;
  final Card card;
  bool isFlipped = false;

  GameCard({required this.card, super.position, super.scale, Vector2? size})
    : super(size: size, priority: 10);

  @override
  Future<void> onLoad() async {
    front = SpriteComponent(sprite: card.front, size: size);
    back = SpriteComponent(sprite: card.back, size: size);

    await add(back); // Start with the back showing
  }

  void startFlip() {
    if (isFlipped) return;

    add(
      ScaleEffect.to(
        Vector2(0, 1),
        EffectController(duration: 0.3),
        onComplete: () async {
          if (contains(back)) {
            remove(back);
          }
          if (!contains(front)) {
            await add(front);
          }
          add(ScaleEffect.to(Vector2(1, 1), EffectController(duration: 0.3)));
          isFlipped = true;
        },
      ),
    );
  }

  void resetFlip() {
    if (!isFlipped) return;

    add(
      ScaleEffect.to(
        Vector2(0, 1),
        EffectController(duration: 0.3),
        onComplete: () async {
          if (contains(front)) {
            remove(front);
          }
          if (!contains(back)) {
            await add(back);
          }
          add(ScaleEffect.to(Vector2(1, 1), EffectController(duration: 0.3)));
          isFlipped = false;
        },
      ),
    );
  }
}
