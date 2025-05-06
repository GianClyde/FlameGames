import 'package:flame/components.dart';
import 'package:flame/timer.dart';
import 'package:flutter/material.dart';
import 'package:flame_practice/game.dart';

class WinOverlay extends PositionComponent with HasGameReference<MyGame> {
  late TextComponent textLabel;
  late Timer _timer;
  late String result;

  final bool isWinner;
  final bool hasFolded;
  WinOverlay({
    this.hasFolded = false,
    required this.isWinner,
    super.position,
    super.size,
    super.priority,
  }) {
    _timer = Timer(5.0, onTick: _removeOverlay, autoStart: true);
    if (hasFolded) {
      result = "FOLDED";
    } else {
      if (isWinner) {
        result = "WIN";
      } else {
        result = "LOSE";
      }
    }
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final overlayBackground = RectangleComponent(
      size: size,
      position: Vector2.zero(),
      priority: -1,
      paint: Paint()..color = Colors.black.withOpacity(0.6),
    );
    add(overlayBackground);

    textLabel = TextComponent(
      text: result,
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 40,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      anchor: Anchor.center,
      position: Vector2(size.x / 2, size.y / 2),
    );
    add(textLabel);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _timer.update(dt);
  }

  void _removeOverlay() {
    removeFromParent();
  }
}
