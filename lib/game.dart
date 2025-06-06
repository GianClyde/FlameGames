import 'dart:async';
import 'package:flame/cache.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame_practice/components/beginning_timer_overlay.dart';
import 'package:flame_practice/components/better.dart';
import 'package:flame_practice/components/betting_buttons_row.dart';
import 'package:flame_practice/components/card_holder.dart';
import 'package:flame_practice/components/cards_equal_box.dart';
import 'package:flame_practice/components/deck_manager.dart';
import 'package:flame_practice/components/game_card.dart';
import 'package:flame_practice/components/game_timer.dart';
import 'package:flame_practice/components/header_text.dart';
import 'package:flame_practice/components/money_holder.dart';
import 'package:flame_practice/components/player.dart';
import 'package:flame_practice/components/slider.dart';
import 'package:flame_practice/components/table.dart';
import 'package:flame_practice/components/win_overlay.dart';
import 'package:flame_practice/models/card.dart';
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
  late Player activePlayer;
  int currentPlayerIndex = 0;
  late final Images images;

  late List<Sprite> timerSprites;

  //beginning overlay
  late GameOverlayTimer _startingGameOverlayTimer;

  //deck manager related
  late DeckManager deckManager;
  late Card playerCard1;
  late Card playerGuessCard;
  late Card playerCard2;

  // Predefined table positions for players
  final List<Vector2> tableCoordinates = [
    Vector2(320, 260),
    Vector2(530, 260),
    Vector2(670, 245),
    Vector2(620, 140),
    Vector2(410, 140),
    Vector2(275, 160),
  ];

  //buttons row for betting
  late BettingButtonsRow bettingButtonsRow;
  late bool hasFolded;

  // Result tracking
  late String cardResult;
  late bool isWinner;
  bool hasShownWinnerOverlay = false;

  bool betterShown = false;
  bool cardsEqual = false;

  //Better
  late Better better;

  //pot
  double pot = 0.0;
  late MoneyHolder potHolder;

  late CardsEqualBox cardsEqualBox;

  String playerSide = "in between";

  MyGame({super.children, super.world, super.camera, required this.room});

  bool hasBet = false;

  @override
  Future<void> onLoad() async {
    await Flame.device.fullScreen();
    await Flame.device.setLandscape();
    images = Images();
    await _createBackground();
    isWinner = false;
    startGame();
  }

  void startGame() async {
    timerSprites = [];
    hasFolded = false;
    for (int i = 0; i <= 9; i++) {
      timerSprites.add(await loadSprite('numbers/$i.png'));
    }

    deckManager = DeckManager();
    await deckManager.load();

    await images.loadAll(['cards/other_back_red.png']);
    _createTable();

    _createGameTimer();
    _createStartCountdown();

    await _createPotHolder();
    await _createPlayers();

    await _createHeaderText();
    card1Val = activePlayer.card1!;
    guessCardVal = activePlayer.guessCard!;
    card2Val = activePlayer.card2!;
    print("Active player: ${activePlayer.user.userName}");
    print("isTurn: ${activePlayer.turn}");

    await _createZoomedCards();
    await _createZoomedCardHolders();
    await _createMoneyHolder();
    await _creatBettingButtons();
    // await _createCardEqualBox();
  }

  Future<void> _createPotHolder() async {
    final potHolderSprite = await loadSprite('holders/pot_bg.png');
    potHolder = MoneyHolder(
      fontSize: 12,
      bg: potHolderSprite,
      position: Vector2(size.x / 2 - 60, size.y / 2 - 25),
      size: Vector2(130, 60),
    );

    add(potHolder);
  }

  Future<void> _createBetter() async {
    final betterBg = await loadSprite('better_bg.png');

    better = Better(
      sliderMaxValue: activePlayer.walletBalance,
      size: Vector2(390, 75),
      priority: 15,
      position: Vector2(size.x / 2 - 200, size.y / 2 + 130),
      sliderMinValue: 100,
      onMinBtnPressed: () {},
      onHalfBtnPressed: () {},
      onMaxBtnPressed: () {},
      bg: betterBg,
      onClosed: () async {
        remove(better);
        await _creatBettingButtons();
        betterShown = false;
      },
      onDealPressed: () {
        hasBet = true;
        activePlayer.updateCurrentBet(amount: better.sliderValue);
        betterShown = false;
        remove(better);

        cardsEqual = activePlayer.card1?.value == activePlayer.card2?.value;
        print(
          "CARDSEQUAL: $cardsEqual || ACTIVE PLAYER: ${activePlayer.user.userName} || ACTIV PLAYER CARDS = AC1: ${activePlayer.card1?.value}  AGC: ${activePlayer.guessCard?.value}  AC2: ${activePlayer.card2?.value} ||  CARD VALUES = C1: ${card1Val.value} C2: ${card2Val.value}",
        );

        if (cardsEqual) {
          _createCardEqualBox();
        } else {
          _creatBettingButtons();
        }
        gameTimer.stop();
        gameFlow();

        print("BET VALUE: ${activePlayer.currentBet}");
      },
    );

    if (!betterShown) {
      await add(better);
    } else {
      remove(better);
    }
  }

  Future<void> _createCardEqualBox() async {
    final betterBg = await loadSprite('better_bg.png');
    cardsEqualBox = CardsEqualBox(
      size: Vector2(390, 75),
      priority: 15,
      position: Vector2(size.x / 2 - 200, size.y / 2 + 130),
      bg: betterBg,
      onHigherPresed: () async {
        playerSide = "higher";
        if (cardsEqualBox.isMounted) {
          remove(cardsEqualBox);
          await _creatBettingButtons();

          gameTimer.stop();
          cardsEqual = false;
          gameFlow();
        }
      },
      onLowerPresed: () async {
        playerSide = "lower";
        if (cardsEqualBox.isMounted) {
          remove(cardsEqualBox);
          await _creatBettingButtons();

          gameTimer.stop();
          cardsEqual = false;
          gameFlow();
        }
      },
    );

    if (cardsEqual) {
      add(cardsEqualBox);
    } else {
      if (cardsEqualBox.isMounted) {
        remove(cardsEqualBox);
      }
    }
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
      userName: activePlayer.user.userName,
      position: Vector2((size.x / 2) - 50, 30),
    );
    add(headerText);
  }

  Future<void> _creatBettingButtons() async {
    bettingButtonsRow = BettingButtonsRow(
      priority: 10,
      //scale: Vector2(0.1, 0.1),
      position: Vector2(size.x / 2 - 40, size.y / 2 + 150),
      allInPressed: () {
        print("ALL INNNNNNNNNNNNN");
      },
      betPressed: () async {
        await _createBetter();
        remove(bettingButtonsRow);
        betterShown = !betterShown;
        print("BETTTTTTTTTTTTTTTT");
      },
      foldPressed: () {
        hasFolded = true;
        fold();
        print("FOLDDDDDDDDDDDDDDDD");
      },
    );

    add(bettingButtonsRow);
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

  Future<void> _createWinnerOverlay({
    bool hasFolded = false,
    bool deckEmpty = false,
  }) async {
    final existing = children.whereType<WinOverlay>().toList();
    for (final overlay in existing) {
      overlay.removeFromParent();
    }

    final winOverlay = WinOverlay(
      size: size,
      position: Vector2.zero(),
      priority: 20,
      isWinner: isWinner,
      hasFolded: hasFolded,
      deckEmpty: deckEmpty,
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

    // playerCard1 = deckManager.drawCard();
    // playerCard2 = deckManager.drawCard();
    // playerGuessCard = deckManager.drawCard();

    // //for testing purposes
    // playerCard1 = Card(
    //   suit: "clubs",
    //   value: "4",
    //   front: Sprite(await Flame.images.load('cards/clubs_4.png')),
    //   back: Sprite(await Flame.images.load('cards/other_back_red.png')),
    // );
    // playerCard2 = Card(
    //   suit: "clubs",
    //   value: "4",
    //   front: Sprite(await Flame.images.load('cards/clubs_4.png')),
    //   back: Sprite(await Flame.images.load('cards/other_back_red.png')),
    // );
    // playerGuessCard = deckManager.drawCard();

    for (int i = 0; i < room.userList.length; i++) {
      angle = _calculatePlayerAngle(i);

      playerMaps['player$i'] = Player(
        position: tableCoordinates[i],
        card1: deckManager.drawCard(),
        card2: deckManager.drawCard(),
        angle: angle,
        guessCard: deckManager.drawCard(),
        user: room.userList[i],
      );

      playerMaps['player$i']?.walletBalance =
          (playerMaps['player$i']!.walletBalance - 100);

      pot += 100;
      potHolder.updateMoney(pot);
      add(playerMaps['player$i']!);
    }

    activePlayer = playerMaps["player0"]!;
    activePlayer.setTurn(true);
  }

  double _calculatePlayerAngle(int index) {
    if (index == 2) return 270 * (3.14159265 / 180);
    if (index == 3 || index == 4) return 180 * (3.14159265 / 180);
    if (index == 5) return 90 * (3.14159265 / 180);
    return 0;
  }

  Future<void> _createZoomedCards() async {
    card1 = GameCard(size: Vector2(70, 90), card: activePlayer.card1!);
    guessCard = GameCard(size: Vector2(70, 90), card: activePlayer.guessCard!);
    card2 = GameCard(size: Vector2(70, 90), card: activePlayer.card2!);

    card1.onFlip = () => activePlayer.gameCard1?.startFlip();
    guessCard.onFlip = () => activePlayer.gameGuessCard?.startFlip();
    card2.onFlip = () => activePlayer.gameCard2?.startFlip();

    card1.onResetFlip = () => activePlayer.gameCard1?.resetFlip();
    guessCard.onResetFlip = () => activePlayer.gameGuessCard?.resetFlip();
    card2.onResetFlip = () => activePlayer.gameCard2?.resetFlip();

    card1.onUpdateCard =
        (newCard) async => activePlayer.gameCard1?.updateCard(newCard);
    guessCard.onUpdateCard =
        (newCard) async => activePlayer.gameGuessCard?.updateCard(newCard);
    card2.onUpdateCard =
        (newCard) async => activePlayer.gameCard2?.updateCard(newCard);
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
      fontSize: 18,
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
    print("HAS BET: $hasBet");
    if (hasBet) {
      print("HAS BET: gameflow");
      gameFlow();
    } else {
      print("HAS BET: fold");
      hasFolded = true;
      fold();
    }
  }

  void beginningTimerEnded() {
    gameTimer.start();
  }

  Future<void> switchToNextPlayer() async {
    activePlayer.setTurn(false);

    if (betterShown) {
      remove(better);
      betterShown = false;
      await _creatBettingButtons();
    }

    currentPlayerIndex = (currentPlayerIndex + 1) % room.userList.length;
    activePlayer = playerMaps["player$currentPlayerIndex"]!;

    final newCard1 = deckManager.drawCard();
    final newGuessCard = deckManager.drawCard();
    final newCard2 = deckManager.drawCard();

    if (newCard1 == null || newGuessCard == null || newCard2 == null) {
      print("One or more drawn cards are null. Skipping turn.");
      return;
    }

    activePlayer.card1 = newCard1;
    activePlayer.guessCard = newGuessCard;
    activePlayer.card2 = newCard2;

    activePlayer.gameCard1?.updateCard(newCard1);
    activePlayer.gameGuessCard?.updateCard(newGuessCard);
    activePlayer.gameCard2?.updateCard(newCard2);

    activePlayer.setTurn(true);
    gameTimer.reset();
  }

  Future<void> gameFlow() async {
    guessCard.startFlip();

    TimerComponent delayTimer = TimerComponent(
      period: 2.0,
      removeOnFinish: true,
      onTick: () async {
        if (gameTimer.hasEnded && !hasShownWinnerOverlay) {
          isWinner = checkResults(bet: playerSide);
          print("Result: $isWinner");

          await _createWinnerOverlay(hasFolded: hasFolded);
          hasShownWinnerOverlay = true;
          card1.resetFlip();
          guessCard.resetFlip();
          card2.resetFlip();
          hasBet = false;
          startIntervalTimer(3);
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
        hasFolded = false;
        await switchToNextPlayer();

        headerText.updateUserName(activePlayer.user.userName);

        await card1.updateCard(activePlayer.card1!);
        await guessCard.updateCard(activePlayer.guessCard!);
        await card2.updateCard(activePlayer.card2!);

        print(
          "CARD COUNT: ${deckManager.getDrawnCount()} out of ${deckManager.getDeckSize()}",
        );

        card1Val = activePlayer.card1!;
        guessCardVal = activePlayer.guessCard!;
        card2Val = activePlayer.card2!;

        card1.startFlip();
        card2.startFlip();
        // activePlayer.gameCard1!.startFlip();
        // activePlayer.gameCard2!.startFlip();
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

    print("RESULTS: PLAYER SIDE: ${bet} - CARD RESULT: ${cardResult}");
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

  void fold() {
    print("HAS BET: fold called");
    card1.resetFlip();
    guessCard.resetFlip();
    card2.resetFlip();
    if (!hasShownWinnerOverlay) {
      gameTimer.stop();
      isWinner = false;
      hasBet = false;
      _createWinnerOverlay(hasFolded: hasFolded).then((_) {
        hasShownWinnerOverlay = true;
        startIntervalTimer(5);
      });
    }
  }
}
