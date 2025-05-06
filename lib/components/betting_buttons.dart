import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

class BettingButtons extends SpriteButtonComponent {
  final Sprite normal;
  final Sprite pressed;

  BettingButtons({
    super.button,
    super.buttonDown,
    super.onPressed,
    super.position,
    super.size,
    super.scale,
    super.angle,
    super.anchor,
    super.children,
    super.priority,
    required this.normal,
    required this.pressed,
  });
  @override
  FutureOr<void> onLoad() async {
    button = normal;
    buttonDown = pressed;

    onPressed = onPressed;
  }
}
