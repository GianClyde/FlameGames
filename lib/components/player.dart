import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame_practice/components/game_card.dart';
import 'package:flame_practice/game.dart';
import 'package:flame_practice/models/card.dart';
import 'package:flame_practice/models/player.dart';
import 'package:flutter/material.dart';
import 'package:flame_practice/models/card.dart' as game_card;
import 'package:flutter/material.dart';

class Player extends PositionComponent with HasGameReference<MyGame> {
  final PlayerModel player;
  final game_card.Card? card1;
  final game_card.Card? card2;
  final game_card.Card? guessCard;

  late GameCard? gameCard1;
  late GameCard? gameCard2;
  late GameCard? gameGuessCard;

  late TextComponent userName;

  late bool turn;

  late String frontImagePath;

  Player({
    required this.player,
    super.size,
    super.children,
    super.position,
    super.angle,
    super.key,
    required this.card1,
    required this.card2,
    required this.guessCard,
  }) : super(priority: 20) {
    debugMode = true;
  }

  @override
  FutureOr<void> onLoad() async {
    frontImagePath = 'cards/clubs_2.png';
    userName = TextComponent(
      text: player.user,
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 12,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      anchor: Anchor.center,
      position: Vector2(size.x / 2 + 40, size.y / 2 - 15),
    );

    add(userName);

    gameCard1 =
        card1 != null
            ? GameCard(
              size: Vector2(50, 70),
              scale: Vector2(0.5, 0.5),
              position: Vector2(size.x, size.y),
              card: game_card.Card(
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
              card: game_card.Card(
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
              card: game_card.Card(
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
