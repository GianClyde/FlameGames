import 'package:flame/components.dart';

class CardHolder extends SpriteComponent {
  CardHolder({required Sprite holderSprite, super.position, Vector2? size})
    : super(sprite: holderSprite, size: size, priority: 9);
}
