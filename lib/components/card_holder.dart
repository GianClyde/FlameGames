import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame_practice/components/game_card.dart';

class CardHolder extends SpriteComponent {
  final GameCard? gameCard;

  CardHolder({
    required Sprite holderSprite,
    GameCard? generatedGameCard,
    super.position,
    super.size,
    super.scale,
  }) : gameCard = generatedGameCard,
       super(sprite: holderSprite, priority: 9);

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    if (gameCard != null) {
      gameCard!.size = Vector2(70, 90);
      gameCard!.position = Vector2(
        (size.x - gameCard!.size.x) / 2,
        (size.y - gameCard!.size.y) / 2,
      );

      add(gameCard!);
    }
  }
}
