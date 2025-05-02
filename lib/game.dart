import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame_practice/components/card_holder.dart';
import 'package:flame_practice/components/game_card.dart';
import 'package:flame_practice/components/game_timer.dart';
import 'package:flame_practice/components/header_text.dart';
import 'package:flame_practice/components/money_holder.dart';
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

  late HeaderText headerText;

  late GameTimer gameTimer;

  late MoneyHolder moneyHolder;

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
    _createHeaderText();
    await _createZoomedCards();
    await _createZoomedCardHolders();
    await _createMoneyHolder();
  }

  Future<void> _createHeaderText() async {
    headerText = HeaderText(
      userName: "JM",
      position: Vector2((size.x / 2) - 50, 30),
    );
    add(headerText);
  }

  Future<void> _createGameTimer() async {
    final background = SpriteComponent(
      sprite: await loadSprite('timer_bg.png'),
      size: Vector2(100, 100),
    );

    List<Sprite> timerSprites = [await loadSprite('')];
    gameTimer = GameTimer(
      sprites: timerSprites,
      spriteComponent: SpriteComponent(size: Vector2(100, 100)),
      backgroundSprite: background,
    );
  }

  Future<void> _createZoomedCards() async {
    final frontSprite = await loadSprite('cards/clubs_2.png');
    final backSprite = await loadSprite('cards/other_back_red.png');
    //final _yPosition = size.x / 2 - 420;

    card1 = GameCard(
      frontSprite: frontSprite,
      backSprite: backSprite,
      //position: Vector2(_yPosition, (size.y * 0.1 - 20)),
      size: Vector2(70, 90),
    );

    guessCard = GameCard(
      frontSprite: frontSprite,
      backSprite: backSprite,
      //position: Vector2(_yPosition, (size.y * 0.1) + 120 + 10),
      size: Vector2(70, 90),
    );

    card2 = GameCard(
      frontSprite: frontSprite,
      backSprite: backSprite,
      //position: Vector2(_yPosition, (size.y * 0.1) + 230 + 10 + 10),
      size: Vector2(70, 90),
    );
  }

  Future<void> _createZoomedCardHolders() async {
    shadowSprite = await loadSprite('cards/card_shadow.png');
    guessSprite = await loadSprite('cards/question_card.png');

    final _yPosition = size.x / 2 - 420;

    cardHolder1 = CardHolder(
      holderSprite: shadowSprite,
      position: Vector2(_yPosition, (size.y * 0.1 - 20)),
      size: Vector2(105, 120),
      generatedGameCard: card1,
    );

    guessCardHolder = CardHolder(
      holderSprite: guessSprite,
      position: Vector2(_yPosition, (size.y * 0.1 - 20) + 95 + 10),
      size: Vector2(105, 120),
      generatedGameCard: guessCard,
    );

    cardHolder2 = CardHolder(
      holderSprite: shadowSprite,
      position: Vector2(_yPosition, (size.y * 0.1 - 20) + 190 + 10 + 10),
      size: Vector2(105, 120),
      generatedGameCard: card2,
    );

    add(cardHolder1);
    add(guessCardHolder);
    add(cardHolder2);
  }

  Future<void> _createMoneyHolder() async {
    final moneyHolderSprite = await loadSprite('holders/amount_holder.png');
    final _yPosition = size.x / 2 - 460;
    moneyHolder = MoneyHolder(
      bg: moneyHolderSprite,
      position: Vector2(_yPosition, size.y / 2 + 120),
      size: Vector2(180, 80),
    );

    add(moneyHolder);
  }

  void _createTable() {
    table = Table(position: Vector2(size.x / 2, size.y / 2));
    add(table);
  }
}
