import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_practice/components/game_card.dart';
import 'package:flutter/widgets.dart';

class CardHolder extends SpriteComponent {
  final GameCard? gameCard;
  final bool isGuessCard;
  CardHolder({
    this.isGuessCard = false,
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
        (size.x - gameCard!.size.x) / 2 - 200,
        (size.y - gameCard!.size.y) / 2,
      );

      add(gameCard!);

      gameCard!.add(
        MoveEffect.to(
          Vector2(
            (size.x - gameCard!.size.x) / 2,
            (size.y - gameCard!.size.y) / 2,
          ),
          EffectController(duration: 2.0, curve: Curves.easeInOut),
          onComplete: () {
            if (!isGuessCard) {
              gameCard!.startFlip();
            }
          },
        ),
      );
    }
  }
}
