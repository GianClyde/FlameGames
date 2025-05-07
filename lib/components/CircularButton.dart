import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/input.dart';

class CircularButton extends SpriteButtonComponent {
  final Sprite btnSprite;

  CircularButton({
    required this.btnSprite,
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
  });

  @override
  FutureOr<void> onLoad() {
    button = btnSprite;
    buttonDown = btnSprite;

    onPressed = onPressed;
    return super.onLoad();
  }
}
