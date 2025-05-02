import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_practice/components/game_card.dart';

class CardHolder extends SpriteComponent {
  late GameCard gameCard;
  CardHolder({
    required GameCard generatedGameCard,
    required Sprite holderSprite,
    super.position,
    Vector2? size,
  }) : super(sprite: holderSprite, size: size, priority: 9) {
    gameCard = generatedGameCard;
  }

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();
    gameCard.position = Vector2(
      (size.x - gameCard.size.x) / 2,
      (size.y - gameCard.size.y) / 2,
    );

    add(gameCard);
  }
}
