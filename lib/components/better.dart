import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame_practice/components/CircularButton.dart';
import 'package:flame_practice/components/betting_buttons.dart';
import 'package:flame_practice/components/slider.dart';
import 'package:flame_practice/components/slider_counter.dart';
import 'package:flame_practice/game.dart';
import 'package:flutter/material.dart';

class Better extends SpriteComponent with HasGameReference<MyGame> {
  late BettingButtons minBtn;
  late BettingButtons maxBtn;
  late BettingButtons halfBtn;

  late SliderComponent slider;
  late SliderCounter sliderCounter;

  late double sliderValue;

  late Vector2 btnSize;

  late CircularButton closeButton;

  final VoidCallback onMinBtnPressed;
  final VoidCallback onHalfBtnPressed;
  final VoidCallback onMaxBtnPressed;
  final VoidCallback onClosed;

  final double sliderMinValue;
  final Sprite bg;

  Better({
    super.position,
    super.size,
    super.scale,
    super.angle,
    super.nativeAngle,
    super.anchor,
    super.children,
    super.priority,
    super.key,
    required this.bg,
    required this.sliderMinValue,
    required this.onClosed,
    required this.onMinBtnPressed,
    required this.onHalfBtnPressed,
    required this.onMaxBtnPressed,
  }) : super(sprite: bg) {
    debugMode = true;
  }

  @override
  FutureOr<void> onLoad() async {
    btnSize = Vector2(110, 60);
    sliderValue = sliderMinValue;
    await _createSliderRow();
    await _createBetButtons();
    await _createCloseButton();
    return super.onLoad();
  }

  Future<void> _createBetButtons() async {
    final minBtnImg = await Flame.images.load('buttons/min_btn.png');
    final halfBtnImg = await Flame.images.load('buttons/half_btn.png');
    final maxBtnImg = await Flame.images.load('buttons/max_btn.png');
    minBtn = BettingButtons(
      priority: 15,
      normal: Sprite(minBtnImg),
      pressed: Sprite(minBtnImg),
      onPressed: onMinBtnPressed,
      size: btnSize,
      position: Vector2((size.x / 2) - 155, size.y / 2 - 10),
    );

    add(minBtn);

    halfBtn = BettingButtons(
      priority: 15,
      normal: Sprite(halfBtnImg),
      pressed: Sprite(halfBtnImg),
      onPressed: onMinBtnPressed,
      size: btnSize,
      position: Vector2((size.x / 2) - 55, size.y / 2 - 10),
    );

    add(halfBtn);

    maxBtn = BettingButtons(
      priority: 15,
      normal: Sprite(maxBtnImg),
      pressed: Sprite(maxBtnImg),
      onPressed: onMinBtnPressed,
      size: btnSize,
      position: Vector2((size.x / 2) + 40, size.y / 2 - 10),
    );

    add(maxBtn);
  }

  Future<void> _createSliderRow() async {
    slider = SliderComponent(
      position: Vector2(size.x / 2 - 50, size.y / 2 - 20),
      value: sliderMinValue,
      onChanged: (value) {
        sliderValue = value;
        sliderCounter.updateValue(value);
        print("SLIDERVAL: $value");
      },
      sliderWidth: 200,
    );

    final counterBg = await Flame.images.load('card_bg.png');
    sliderCounter = SliderCounter(
      position: Vector2(size.x / 2 - 150, size.y / 2 - 20),
      sliderVal: sliderValue,
      bg: Sprite(counterBg),
      size: Vector2(80, 20),
    );

    add(slider);
    add(sliderCounter);
  }

  Future<void> _createCloseButton() async {
    final closeSprite = await Flame.images.load('buttons/x_btn.png');
    closeButton = CircularButton(
      size: Vector2(20, 20),
      position: Vector2(size.x - 20, size.y - 80),
      btnSprite: Sprite(closeSprite),
      onPressed: onClosed,
    );

    add(closeButton);
  }
}
