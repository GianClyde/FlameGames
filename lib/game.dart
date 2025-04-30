import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame_practice/components/card_holder.dart';
import 'package:flame_practice/components/game_card.dart';
import 'package:flame_practice/components/table.dart';

class MyGame extends FlameGame {
  late Table table;

  late CardHolder cardHolder1;
  late CardHolder guessCardHolder;
  late CardHolder cardHolder2;

  late GameCard card1;
  late GameCard guessCard;
  late GameCard card2;

  late Sprite shadowSprite;
  late Sprite guessSprite;

  @override
  Future<void> onLoad() async {
    await Flame.device.fullScreen();
    await Flame.device.setLandscape();

    // Load background sprite first
    final backgroundSprite = await loadSprite('background.png');
    final background = SpriteComponent(
      sprite: backgroundSprite,
      size: size,
      priority: -1,
    );
    await add(background);

    startGame();
  }

  void startGame() async {
    _createTable();
    await _createZoomedCardHolders();
    // await _createZoomedCards();
  }

  Future<void> _createZoomedCards() async {
    final frontSprite = await loadSprite('front.jpg');
    final backSprite = await loadSprite('back.png');
    final _yPosition = size.x / 2 - 420;

    card1 = GameCard(
      frontSprite: frontSprite,
      backSprite: backSprite,
      position: Vector2(_yPosition, (size.y * 0.1)),
      size: Vector2(80, 110),
    );

    guessCard = GameCard(
      frontSprite: frontSprite,
      backSprite: backSprite,
      position: Vector2(_yPosition, (size.y * 0.1) + 120 + 10),
      size: Vector2(80, 110),
    );

    card2 = GameCard(
      frontSprite: frontSprite,
      backSprite: backSprite,
      position: Vector2(_yPosition, (size.y * 0.1) + 230 + 10 + 10),
      size: Vector2(80, 110),
    );

    add(card1);
    add(guessCard);
    add(card2);
  }

  Future<void> _createZoomedCardHolders() async {
    shadowSprite = await loadSprite('cards/card_shadow.png');
    guessSprite = await loadSprite('cards/question_card.png');

    final _yPosition = size.x / 2 - 420;

    cardHolder1 = CardHolder(
      holderSprite: shadowSprite,
      position: Vector2(_yPosition, (size.y * 0.1)),
      size: Vector2(90, 120),
    );

    guessCardHolder = CardHolder(
      holderSprite: guessSprite,
      position: Vector2(_yPosition, (size.y * 0.1) + 120 + 10),
      size: Vector2(90, 120),
    );

    cardHolder2 = CardHolder(
      holderSprite: shadowSprite,
      position: Vector2(_yPosition, (size.y * 0.1) + 230 + 10 + 10),
      size: Vector2(90, 120),
    );

    add(cardHolder1);
    add(guessCardHolder);
    add(cardHolder2);
  }

  void _createTable() {
    table = Table(position: Vector2(size.x / 2, size.y / 2));
    add(table);
  }
}
