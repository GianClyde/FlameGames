import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/painting.dart';

class SliderCounter extends SpriteComponent {
  late TextComponent _text;
  double _sliderValue = 0;

  SliderCounter({
    required double sliderVal,
    required Sprite bg,
    required Vector2 position,
    required Vector2 size,
  }) : super(position: position, size: size, priority: 15, sprite: bg) {
    _sliderValue = sliderVal;
  }

  @override
  FutureOr<void> onLoad() {
    _text = TextComponent(
      text: _sliderValue.toStringAsFixed(2),
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color(0xFFFFFFFF),
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    _text.position = Vector2(
      size.x / 2 - _text.width / 2,
      size.y / 2 - _text.height / 2,
    );

    add(_text);
    return super.onLoad();
  }

  void updateValue(double newValue) {
    _sliderValue = newValue;
    _text.text = _sliderValue.toStringAsFixed(2);
  }
}
