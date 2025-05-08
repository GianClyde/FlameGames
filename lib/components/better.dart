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
  late BettingButtons dealBtn;

  late SliderComponent slider;
  late SliderCounter sliderCounter;

  late double sliderValue;

  late Vector2 btnSize;

  late CircularButton closeButton;

  final double sliderMaxValue;
  final VoidCallback onMinBtnPressed;
  final VoidCallback onHalfBtnPressed;
  final VoidCallback onMaxBtnPressed;
  final VoidCallback onDealPressed;
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
    required this.sliderMaxValue,
    required this.onClosed,
    required this.onDealPressed,
    required this.onMinBtnPressed,
    required this.onHalfBtnPressed,
    required this.onMaxBtnPressed,
  }) : super(sprite: bg);

  @override
  FutureOr<void> onLoad() async {
    btnSize = Vector2(110, 60);
    sliderValue = sliderMinValue;

    await _createSliderRow();
    await _createBetButtons();
    await _createCloseButton();
    slider.setMax(sliderMaxValue);
    return super.onLoad();
  }

  Future<void> _createBetButtons() async {
    final minBtnImg = await Flame.images.load('buttons/min_btn.png');
    final halfBtnImg = await Flame.images.load('buttons/half_btn.png');
    final maxBtnImg = await Flame.images.load('buttons/max_btn.png');
    final dealBtnImg = await Flame.images.load('buttons/deal_btn.png');
    minBtn = BettingButtons(
      priority: 15,
      normal: Sprite(minBtnImg),
      pressed: Sprite(minBtnImg),
      onPressed: onMinBtnPressed,
      size: btnSize,
      position: Vector2((size.x / 2) - 190, size.y / 2 - 10),
    );

    add(minBtn);

    halfBtn = BettingButtons(
      priority: 15,
      normal: Sprite(halfBtnImg),
      pressed: Sprite(halfBtnImg),
      onPressed: onMinBtnPressed,
      size: btnSize,
      position: Vector2((size.x / 2) - 85, size.y / 2 - 10),
    );

    add(halfBtn);

    maxBtn = BettingButtons(
      priority: 15,
      normal: Sprite(maxBtnImg),
      pressed: Sprite(maxBtnImg),
      onPressed: onMinBtnPressed,
      size: btnSize,
      position: Vector2((size.x / 2) + 20, size.y / 2 - 10),
    );

    add(maxBtn);

    dealBtn = BettingButtons(
      priority: 15,
      normal: Sprite(dealBtnImg),
      pressed: Sprite(dealBtnImg),
      onPressed: onDealPressed,
      size: Vector2(75, 60),
      position: Vector2((size.x / 2) + 120, size.y / 2 - 30),
    );

    add(dealBtn);
  }

  Future<void> _createSliderRow() async {
    slider = SliderComponent(
      position: Vector2(size.x / 2 - 80, size.y / 2 - 20),
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
      position: Vector2(size.x / 2 - 180, size.y / 2 - 20),
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
      position: Vector2(size.x - 10, size.y - 80),
      btnSprite: Sprite(closeSprite),
      onPressed: onClosed,
    );

    add(closeButton);
  }
}
