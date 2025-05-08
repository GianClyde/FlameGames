import 'dart:async';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame_practice/components/game_card.dart';
import 'package:flame_practice/components/player_turn_arrow.dart';
import 'package:flame_practice/game.dart';
import 'package:flame_practice/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flame_practice/models/card.dart' as game_card;

class Player extends PositionComponent with HasGameReference<MyGame> {
  final User user;
  final game_card.Card? card1;
  final game_card.Card? card2;
  final game_card.Card? guessCard;

  late GameCard? gameCard1;
  late GameCard? gameCard2;
  late GameCard? gameGuessCard;

  late TextComponent userName;

  bool turn = false;
  late PlayerTurnArrow playerTurnArrow;

  late String frontImagePath;

  late double walletBalance;

  late double currentBet;
  late double playerWinnings;
  Player({
    required this.user,
    super.size,
    super.children,
    super.position,
    super.angle,
    super.key,
    required this.card1,
    required this.card2,
    required this.guessCard,
  }) : super(priority: 20) {
    currentBet = 0;
    playerWinnings = 0;
    walletBalance = user.userWallet.balance;
  }
  @override
  FutureOr<void> onLoad() async {
    playerTurnArrow = PlayerTurnArrow();
    frontImagePath = 'cards/clubs_2.png';
    userName = TextComponent(
      text: user.userName,
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
              size: Vector2(28, 40),
              //scale: Vector2(0.5, 0.5),
              position: Vector2(size.x, size.y),
              card: card1!,
            )
            : null;

    gameGuessCard =
        guessCard != null
            ? GameCard(
              size: Vector2(28, 40),
              //scale: Vector2(0.5, 0.5),
              position: Vector2(size.x + 30, size.y),
              card: guessCard!,
            )
            : null;

    gameCard2 =
        card2 != null
            ? GameCard(
              size: Vector2(28, 40),
              //scale: Vector2(0.5, 0.5),
              position: Vector2(size.x + 60, size.y),
              card: card2!,
            )
            : null;

    add(gameCard1!);
    add(gameGuessCard!);
    add(gameCard2!);
    return super.onLoad();
  }

  void setTurn(bool isActive) async {
    turn = isActive;

    if (isActive) {
      if (!children.contains(playerTurnArrow)) {
        playerTurnArrow = PlayerTurnArrow(
          size: Vector2(200, 200),
          position: Vector2(size.x / 2, size.y / 2),
        );
        await add(playerTurnArrow);
      }
      playerTurnArrow.show();
    } else {
      playerTurnArrow.removeFromParent();
    }
  }

  void updateCurrentBet({required double amount}) {
    currentBet = amount;
  }

  void updatePlayerWinnings({required double newWinnings}) {
    playerWinnings = newWinnings;
  }
}
