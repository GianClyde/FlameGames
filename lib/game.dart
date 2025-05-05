import 'dart:async';
import 'package:flame/cache.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame_practice/components/beginning_timer_overlay.dart';
import 'package:flame_practice/components/card_holder.dart';
import 'package:flame_practice/components/game_card.dart';
import 'package:flame_practice/components/game_timer.dart';
import 'package:flame_practice/components/header_text.dart';
import 'package:flame_practice/components/money_holder.dart';
import 'package:flame_practice/components/player.dart';
import 'package:flame_practice/components/table.dart';
import 'package:flame_practice/components/win_overlay.dart';
import 'package:flame_practice/models/card.dart';
import 'package:flame_practice/models/player.dart';
import 'package:flame_practice/models/room.dart';

class MyGame extends FlameGame {
  // Core game components
  late Table table;
  late HeaderText headerText;
  late GameTimer gameTimer;
  late MoneyHolder moneyHolder;

  // Card holders and zoomed cards
  late CardHolder cardHolder1, guessCardHolder, cardHolder2;
  late GameCard card1, guessCard, card2;
  late Sprite shadowSprite, guessSprite;

  //Card Values for Logic purposes
  late Card card1Val;
  late Card guessCardVal;
  late Card card2Val;

  // Player-related properties
  late Map<String, Player> playerMaps;
  final Room room;
  late double angle;
  late PlayerModel activePlayer;
  int currentPlayerIndex = 0;
  late final Images images;

  late List<Sprite> timerSprites;

  //beginning overlay
  late GameOverlayTimer _startingGameOverlayTimer;

  // Predefined table positions for players
  final List<Vector2> tableCoordinates = [
    Vector2(320, 260),
    Vector2(530, 260),
    Vector2(670, 245),
    Vector2(620, 140),
    Vector2(410, 140),
    Vector2(275, 160),
  ];

  //TODO link active player cards to cardVal 1 and 2

  // Result tracking
  late String cardResult;
  late bool isWinner;
  bool hasShownWinnerOverlay = false;

  MyGame({super.children, super.world, super.camera, required this.room});

  @override
  Future<void> onLoad() async {
    await Flame.device.fullScreen();
    await Flame.device.setLandscape();
    images = Images();
    await _createBackground();
    startGame();
  }

  void startGame() async {
    timerSprites = [];
    for (int i = 0; i <= 9; i++) {
      timerSprites.add(await loadSprite('numbers/$i.png'));
    }

    await images.loadAll(['cards/other_back_red.png']);
    _createTable();
    _createHeaderText();
    _createGameTimer();
    _createStartCountdown();

    card1Val = await Card.generateRandomCard(images);
    guessCardVal = await Card.generateRandomCard(images);
    card2Val = await Card.generateRandomCard(images);

    await _createPlayers();
    await _createZoomedCards();
    await _createZoomedCardHolders();
    await _createMoneyHolder();
  }

  Future<void> _createBackground() async {
    final backgroundSprite = await loadSprite('background.png');
    final background = SpriteComponent(
      sprite: backgroundSprite,
      size: size,
      priority: -1,
    );
    await add(background);
  }

  Future<void> _createHeaderText() async {
    headerText = HeaderText(
      userName: "JM",
      position: Vector2((size.x / 2) - 50, 30),
    );
    add(headerText);
  }

  Future<void> _createStartCountdown() async {
    _startingGameOverlayTimer = GameOverlayTimer(
      size: size,
      position: Vector2.zero(),
      priority: 12,
      backgroundSprite: SpriteComponent(
        sprite: await loadSprite('timer_bg.png'),
        size: Vector2(100, 100),
      ),
      sprites: timerSprites,
    );

    add(_startingGameOverlayTimer);
  }

  Future<void> _createWinnerOverlay() async {
    final existing = children.whereType<WinOverlay>().toList();
    for (final overlay in existing) {
      overlay.removeFromParent();
    }

    final winOverlay = WinOverlay(
      size: size,
      position: Vector2.zero(),
      priority: 12,
      isWinner: isWinner,
    );

    add(winOverlay);
  }

  Future<void> _createGameTimer() async {
    final background = SpriteComponent(
      sprite: await loadSprite('timer_bg.png'),
      size: Vector2(100, 100),
    );

    gameTimer = GameTimer(
      sprites: timerSprites,
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
      front: Sprite(await Flame.images.load('cards/clubs_2.png')),
      back: Sprite(await Flame.images.load('cards/other_back_red.png')),
    );

    for (int i = 0; i < room.listPlayers.length; i++) {
      angle = _calculatePlayerAngle(i);

      playerMaps['player$i'] = Player(
        position: tableCoordinates[i],
        card1: card1,
        card2: card1,
        angle: angle,
        guessCard: card1,
        player: room.listPlayers[i],
      );
      activePlayer = room.listPlayers[0];

      add(playerMaps['player$i']!);
    }
  }

  double _calculatePlayerAngle(int index) {
    if (index == 2) return 270 * (3.14159265 / 180);
    if (index == 3 || index == 4) return 180 * (3.14159265 / 180);
    if (index == 5) return 90 * (3.14159265 / 180);
    return 0;
  }

  Future<void> _createZoomedCards() async {
    card1 = GameCard(size: Vector2(70, 90), card: card1Val);
    guessCard = GameCard(size: Vector2(70, 90), card: guessCardVal);
    card2 = GameCard(size: Vector2(70, 90), card: card2Val);
  }

  Future<void> _createZoomedCardHolders() async {
    shadowSprite = await loadSprite('cards/card_shadow.png');
    guessSprite = await loadSprite('cards/question_card.png');

    final yPosition = size.x / 2 - 420;

    cardHolder1 = CardHolder(
      holderSprite: shadowSprite,
      position: Vector2(yPosition, (size.y * 0.1 - 20)),
      size: Vector2(105, 120),
      generatedGameCard: card1,
    );

    guessCardHolder = CardHolder(
      holderSprite: guessSprite,
      position: Vector2(yPosition, (size.y * 0.1 - 20) + 95 + 10),
      size: Vector2(105, 120),
      generatedGameCard: guessCard,
      isGuessCard: true,
    );

    cardHolder2 = CardHolder(
      holderSprite: shadowSprite,
      position: Vector2(yPosition, (size.y * 0.1 - 20) + 190 + 10 + 10),
      size: Vector2(105, 120),
      generatedGameCard: card2,
    );

    add(cardHolder1);
    add(guessCardHolder);
    add(cardHolder2);
  }

  Future<void> _createMoneyHolder() async {
    final moneyHolderSprite = await loadSprite('holders/amount_holder.png');
    final yPosition = size.x / 2 - 460;

    moneyHolder = MoneyHolder(
      bg: moneyHolderSprite,
      position: Vector2(yPosition, size.y / 2 + 120),
      size: Vector2(180, 80),
    );

    add(moneyHolder);
  }

  void _createTable() {
    table = Table(position: Vector2(size.x / 2, size.y / 2));
    add(table);
  }

  void timerEnded() {
    gameFlow();
  }

  void beginningTimerEnded() {
    gameTimer.start();
  }

  Future<void> switchToNextPlayer() async {
    currentPlayerIndex = (currentPlayerIndex + 1) % room.listPlayers.length;
    activePlayer = room.listPlayers[currentPlayerIndex];

    print("Active player: ${activePlayer.user}");
    gameTimer.reset();
  }

  Future<void> gameFlow() async {
    guessCard.startFlip();

    TimerComponent delayTimer = TimerComponent(
      period: 2.0,
      removeOnFinish: true,
      onTick: () async {
        if (gameTimer.hasEnded && !hasShownWinnerOverlay) {
          isWinner = checkResults(bet: "in between");
          print("Result: $isWinner");

          await _createWinnerOverlay();
          hasShownWinnerOverlay = true;
          card1.resetFlip();
          guessCard.resetFlip();
          card2.resetFlip();
          startIntervalTimer(5);
        }
      },
    );

    add(delayTimer);
  }

  void startIntervalTimer(double period) {
    TimerComponent intervalTimer = TimerComponent(
      period: period,
      removeOnFinish: true,
      onTick: () async {
        hasShownWinnerOverlay = false;
        switchToNextPlayer();

        card1Val = await Card.generateRandomCard(images);
        guessCardVal = await Card.generateRandomCard(images);
        card2Val = await Card.generateRandomCard(images);

        await card1.updateCard(card1Val);
        await guessCard.updateCard(guessCardVal);
        await card2.updateCard(card2Val);

        card1.startFlip();
        card2.startFlip();
        gameTimer.start();
      },
    );
    add(intervalTimer);
  }

  bool checkResults({required String bet}) {
    final String cardResult = compareGuessToRange(
      card1: card1Val,
      card2: card2Val,
      guessCard: guessCardVal,
    );
    print("card result: $cardResult bet: $bet");
    return bet == cardResult;
  }

  String compareGuessToRange({
    required Card card1,
    required Card card2,
    required Card guessCard,
  }) {
    final List<String> order = [
      'ace',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      '10',
      'jack',
      'queen',
      'king',
    ];

    int val1 = order.indexOf(card1.value);
    int val2 = order.indexOf(card2.value);
    int guessVal = order.indexOf(guessCard.value);

    if (val1 == -1 || val2 == -1 || guessVal == -1) {
      throw ArgumentError('Invalid card value');
    }

    if (val1 == val2) {
      if (guessVal > val1) return 'higher';
      if (guessVal < val1) return 'lower';
      return 'equal';
    }

    int minVal = val1 < val2 ? val1 : val2;
    int maxVal = val1 > val2 ? val1 : val2;

    if (guessVal > minVal && guessVal < maxVal) {
      return 'in between';
    } else {
      return 'not in between';
    }
  }
}
