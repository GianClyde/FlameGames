import 'package:flame/components.dart';
import 'package:flame_practice/game.dart';
import 'package:flutter/painting.dart';

class MoneyHolder extends SpriteComponent with HasGameReference<MyGame> {
  late SpriteComponent _background;
  late TextComponent _text;
  int _money = 0;

  MoneyHolder({
    required Sprite bg,
    required Vector2 position,
    required Vector2 size,
  }) : super(position: position, size: size, priority: -1, sprite: bg);

  @override
  Future<void> onLoad() async {
    _text = TextComponent(
      text: '\$$_money',
      position: Vector2(50, size.y / 2),
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color(0xFFFFFFFF),
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    //add(_background);
    add(_text);
  }

  void updateMoney(int newAmount) {
    _money = newAmount;
    _text.text = '\$$_money';
  }
}
