import 'package:flame/components.dart';
import 'package:flame/timer.dart';
import 'package:flutter/material.dart';
import 'package:flame_practice/game.dart';

class GameOverlayTimer extends PositionComponent with HasGameReference<MyGame> {
  final List<Sprite> sprites;
  final SpriteComponent backgroundSprite;
  final double tickDuration;
  final int startTime;

  late Timer _timer;
  int _currentTick;

  late SpriteComponent tensSprite;
  late SpriteComponent onesSprite;
  late TextComponent textLabel;

  GameOverlayTimer({
    required this.backgroundSprite,
    required this.sprites,
    this.tickDuration = 1.0,
    this.startTime = 10,
    super.position,
    super.size,
    super.priority,
  }) : _currentTick = startTime {
    debugMode = true;
    _timer = Timer(
      tickDuration,
      onTick: _updateSprite,
      repeat: true,
      autoStart: true,
    );
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    if (sprites.isEmpty) {
      throw Exception("No valid sprites found for GameTimer.");
    }

    final overlayBackground = RectangleComponent(
      size: size,
      position: Vector2.zero(),
      priority: 12,
      // ignore: deprecated_member_use
      paint: Paint()..color = Colors.black.withOpacity(0.6),
    );
    add(overlayBackground);

    textLabel = TextComponent(
      text: 'Game starts in',
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 24,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      anchor: Anchor.center,
      position: Vector2(size.x / 2, size.y / 2 - 50),
    );
    add(textLabel);

    tensSprite = SpriteComponent(size: Vector2(30, 40))
      ..position = Vector2(size.x / 2 - 30, size.y / 2);
    onesSprite = SpriteComponent(size: Vector2(30, 40))
      ..position = Vector2(size.x / 2 + 10, size.y / 2);

    _updateNumberSprites(_currentTick);

    add(tensSprite);
    add(onesSprite);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _timer.update(dt);
  }

  void _updateSprite() {
    if (_currentTick > 0) {
      _currentTick--;
      _updateNumberSprites(_currentTick);
    } else {
      _timer.stop();
      game.beginningTimerEnded();
      removeFromParent();
    }
  }

  void start() => _timer.start();

  void _updateNumberSprites(int number) {
    final tens = number ~/ 10;
    final ones = number % 10;

    tensSprite.sprite = sprites[tens];
    onesSprite.sprite = sprites[ones];
  }
}
