import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_practice/components/game_card.dart';

class CardHolder extends SpriteComponent {
  late GameCard gameCard;
  CardHolder({
    required GameCard generatedGameCard,
    required Sprite holderSprite,
    super.position,
    super.size,
  }) : super(sprite: holderSprite, priority: 9) {
    gameCard = generatedGameCard;
  }

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    gameCard.size = Vector2(90, 100);

    gameCard.position = Vector2(
      (size.x - gameCard.size.x) / 2 + 10,
      (size.y - gameCard.size.y) / 2 + 5,
    );

    add(gameCard);
  }
}
