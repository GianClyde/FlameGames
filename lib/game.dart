import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame_practice/components/card_holder.dart';
import 'package:flame_practice/components/game_card.dart';
import 'package:flame_practice/components/game_timer.dart';
import 'package:flame_practice/components/header_text.dart';
import 'package:flame_practice/components/money_holder.dart';
import 'package:flame_practice/components/player.dart';
import 'package:flame_practice/components/table.dart';
import 'package:flame_practice/models/card.dart';

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

  late Map<String, Player> playerMaps;

  final int playersCount;

  MyGame({
    super.children,
    super.world,
    super.camera,
    required this.playersCount,
  });

  @override
  Future<void> onLoad() async {
    await Flame.device.fullScreen();
    await Flame.device.setLandscape();

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
    _createGameTimer();
    await _createPlayers();
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

    List<Sprite> timerSprites = [];
    for (int i = 0; i <= 9; i++) {
      timerSprites.add(await loadSprite('numbers/$i.png'));
    }

    gameTimer = GameTimer(
      sprites: timerSprites,
      //spriteComponent: SpriteComponent(size: Vector2(100, 100)),
      backgroundSprite: background,
      position: Vector2(size.x - 150, 30),
    );

    add(gameTimer);
  }

  Future<void> _createPlayers() async {
    playerMaps = {};
    final card1 = Card(
      suit: "Spades",
      value: "4",
      imagePath: 'cards/clubs_4.png',
    );
    for (int i = 0; i <= playersCount; i++) {
      playerMaps['player$i'] = Player(
        userName: "player$i",
        card1: card1,
        card2: card1,
      );

      add(playerMaps['player$i']!);
    }
  }

  Future<void> _createZoomedCards() async {
    final frontSprite = await loadSprite('cards/clubs_2.png');
    //final _yPosition = size.x / 2 - 420;

    card1 = GameCard(
      frontSprite: frontSprite,
      //position: Vector2(_yPosition, (size.y * 0.1 - 20)),
      size: Vector2(70, 90),
    );

    guessCard = GameCard(
      frontSprite: frontSprite,
      //position: Vector2(_yPosition, (size.y * 0.1) + 120 + 10),
      size: Vector2(70, 90),
    );

    card2 = GameCard(
      frontSprite: frontSprite,
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

  void timerEnded() {
    card1.startFlip();
    card2.startFlip();
  }
}
