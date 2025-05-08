import 'package:flame/components.dart';
import 'package:flame_practice/game.dart';

class GameTimer extends PositionComponent with HasGameReference<MyGame> {
  final List<Sprite> sprites;
  final SpriteComponent backgroundSprite;
  final double tickDuration;
  final int startTime;

  late Timer _timer;
  late bool hasEnded = false;
  int _currentTick;

  late SpriteComponent tensSprite;
  late SpriteComponent onesSprite;

  GameTimer({
    required this.backgroundSprite,
    required this.sprites,
    this.tickDuration = 1.0,
    this.startTime = 20,
    super.position,
    super.size,
  }) : _currentTick = startTime {
    _timer = Timer(
      tickDuration,
      onTick: _updateSprite,
      repeat: true,
      autoStart: false,
    );
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    if (sprites.isEmpty) {
      throw Exception("No valid sprites found for GameTimer.");
    }

    tensSprite = SpriteComponent(size: Vector2(30, 40));
    onesSprite = SpriteComponent(size: Vector2(30, 40));

    tensSprite.position = Vector2(20, 30);
    onesSprite.position = Vector2(50, 30);

    _updateNumberSprites(_currentTick);

    add(backgroundSprite);
    add(tensSprite);
    add(onesSprite);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_timer.isRunning()) {
      _timer.update(dt);
    }
  }

  void _updateSprite() {
    if (_currentTick > 0) {
      _currentTick--;
      _updateNumberSprites(_currentTick);
    } else {
      hasEnded = true;
      _timer.stop();
      game.timerEnded();
    }
  }

  void start() {
    hasEnded = false;
    if (!_timer.isRunning()) {
      _timer.start();
    }
  }

  void reset() {
    hasEnded = false;
    _currentTick = startTime;
    _updateNumberSprites(_currentTick);
    _timer.stop();
  }

  void _updateNumberSprites(int number) {
    final tens = number ~/ 10;
    final ones = number % 10;

    tensSprite.sprite = sprites[tens];
    onesSprite.sprite = sprites[ones];
  }

  void stop() {
    if (_timer.isRunning()) {
      _timer.stop();
    }
    hasEnded = true;
  }
}
