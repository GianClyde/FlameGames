import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame_practice/components/card_holder.dart';
import 'package:flame_practice/components/game_card.dart';
import 'package:flame_practice/game.dart';
import 'package:flame_practice/models/card.dart';

class Player extends Component with HasGameReference<MyGame> {
  final String userName;
  final Card? card1;
  final Card? card2;

  late GameCard? gameCard1;
  late GameCard? gameCard2;

  late CardHolder? gameCardHolder1;
  late CardHolder? gameCardHolder2;

  late bool turn;

  Player({
    super.children,
    super.key,
    required this.userName,
    required this.card1,
    required this.card2,
  }) : super(priority: 20);

  @override
  FutureOr<void> onLoad() async {
    final holderSprite = await Flame.images.load('cards/card_shadow.png');

    gameCard1 =
        card1 != null
            ? GameCard(
              size: Vector2(50, 70),
              scale: Vector2(0.5, 0.5),
              frontSprite: Sprite(await Flame.images.load(card1!.imagePath)),
            )
            : null;

    // CardHolder with slightly larger size
    gameCardHolder1 = CardHolder(
      position: Vector2(500, 100),
      size: Vector2(60, 80), // Slightly bigger than gameCard
      scale: Vector2(0.5, 0.5),
      generatedGameCard: gameCard1,
      holderSprite: Sprite(holderSprite),
    );

    gameCard2 =
        card2 != null
            ? GameCard(
              size: Vector2(50, 70),

              frontSprite: Sprite(await Flame.images.load(card2!.imagePath)),
            )
            : null;

    gameCardHolder2 = CardHolder(
      position: Vector2(100, 100),
      size: Vector2(60, 80), // Slightly bigger than gameCard
      generatedGameCard: gameCard2,
      holderSprite: Sprite(holderSprite),
    );

    add(gameCardHolder1!);
    // add(gameCardHolder2!);

    return super.onLoad();
  }
}
