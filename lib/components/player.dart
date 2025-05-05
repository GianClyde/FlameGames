import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame_practice/components/game_card.dart';
import 'package:flame_practice/game.dart';
import 'package:flame_practice/models/card.dart';

class Player extends PositionComponent with HasGameReference<MyGame> {
  final String userName;
  final Card? card1;
  final Card? card2;
  final Card? guessCard;

  late GameCard? gameCard1;
  late GameCard? gameCard2;
  late GameCard? gameGuessCard;

  late bool turn;

  late String frontImagePath;

  Player({
    super.size,
    super.children,
    super.position,
    super.angle,
    super.key,
    required this.userName,
    required this.card1,
    required this.card2,
    required this.guessCard,
  }) : super(priority: 20) {
    debugMode = true;
  }

  @override
  FutureOr<void> onLoad() async {
    frontImagePath = 'cards/clubs_2.png';
    gameCard1 =
        card1 != null
            ? GameCard(
              size: Vector2(50, 70),
              scale: Vector2(0.5, 0.5),
              position: Vector2(size.x, size.y),
              card: Card(
                front: Sprite(await Flame.images.load('cards/clubs_2.png')),
                back: Sprite(
                  await Flame.images.load('cards/other_back_red.png'),
                ),
                suit: '',
                value: '',
              ),
            )
            : null;

    gameGuessCard =
        guessCard != null
            ? GameCard(
              size: Vector2(50, 70),
              scale: Vector2(0.5, 0.5),
              position: Vector2(size.x + 30, size.y),
              card: Card(
                front: Sprite(await Flame.images.load('cards/clubs_2.png')),
                back: Sprite(
                  await Flame.images.load('cards/other_back_red.png'),
                ),
                suit: '',
                value: '',
              ),
            )
            : null;

    gameCard2 =
        card2 != null
            ? GameCard(
              size: Vector2(50, 70),
              scale: Vector2(0.5, 0.5),
              position: Vector2(size.x + 60, size.y),
              card: Card(
                front: Sprite(await Flame.images.load('cards/clubs_2.png')),
                back: Sprite(
                  await Flame.images.load('cards/other_back_red.png'),
                ),
                suit: '',
                value: '',
              ),
            )
            : null;

    add(gameCard1!);
    add(gameGuessCard!);
    add(gameCard2!);
    return super.onLoad();
  }
}
