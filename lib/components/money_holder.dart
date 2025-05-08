import 'package:flame/components.dart';
import 'package:flame_practice/game.dart';
import 'package:flutter/painting.dart';

class MoneyHolder extends SpriteComponent with HasGameReference<MyGame> {
  late TextComponent _text;
  final double fontSize;
  double _money = 0;

  MoneyHolder({
    required this.fontSize,
    required Sprite bg,
    required Vector2 position,
    required Vector2 size,
  }) : super(position: position, size: size, priority: 10, sprite: bg);

  @override
  Future<void> onLoad() async {
    _text = TextComponent(
      text: '\$$_money',
      position: Vector2(50, size.y / 2),
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: TextStyle(
          color: const Color(0xFFFFFFFF),
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    //add(_background);
    add(_text);
  }

  void updateMoney(double newAmount) {
    _money = newAmount;
    _text.text = '\$$_money';
  }
}
