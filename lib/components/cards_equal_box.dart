import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame_practice/components/betting_buttons.dart';
import 'package:flutter/material.dart';

class CardsEqualBox extends SpriteComponent {
  final Sprite bg;
  final VoidCallback onHigherPresed;
  final VoidCallback onLowerPresed;
  late BettingButtons _higherBtn;
  late BettingButtons _lowerBtn;
  late TextComponent _text;

  CardsEqualBox({
    super.priority,
    super.position,
    super.size,
    required this.onHigherPresed,
    required this.onLowerPresed,
    required this.bg,
  }) : super(sprite: bg);

  @override
  FutureOr<void> onLoad() async {
    final higherSprite = await Flame.images.load('buttons/higher_btn.png');
    final lowerSprite = await Flame.images.load('buttons/lower_btn.png');

    _text = TextComponent(
      text: 'YOUR CARDS ARE A PAIR! PICK SIDE',
      position: Vector2(190, size.y / 2 - 15),
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: TextStyle(
          color: const Color(0xFFFFFFFF),
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    add(_text);
    _higherBtn = BettingButtons(
      size: Vector2(210, 60),
      position: Vector2((size.x / 2) - 200, size.y / 2 - 15),
      normal: Sprite(higherSprite),
      pressed: Sprite(higherSprite),
      onPressed: onHigherPresed,
    );

    add(_higherBtn);

    _lowerBtn = BettingButtons(
      size: Vector2(210, 60),
      position: Vector2((size.x / 2) - 10, size.y / 2 - 15),
      normal: Sprite(lowerSprite),
      pressed: Sprite(lowerSprite),
      onPressed: onLowerPresed,
    );
    add(_lowerBtn);

    return super.onLoad();
  }
}
