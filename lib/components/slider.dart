import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';

import 'package:flame_practice/game.dart';
import 'package:flutter/material.dart';

class SliderComponent extends PositionComponent
    with DragCallbacks, GestureHitboxes, HasGameReference<MyGame> {
  final double sliderWidth;
  final double sliderHeight;
  final double min;
  final double max;
  final ValueChanged<double>? onChanged;

  double _value;
  late Rect _thumbRect;
  bool _dragging = false;

  SliderComponent({
    required this.sliderWidth,
    this.sliderHeight = 20,
    this.min = 0.0,
    this.max = 1.0,
    double value = 0.5,
    this.onChanged,
    super.position,
  }) : _value = value,
       super(size: Vector2(sliderWidth, sliderHeight));

  @override
  Future<void> onLoad() async {
    super.onLoad();
    add(RectangleHitbox());
  }

  @override
  void render(Canvas canvas) {
    final Paint trackPaint = Paint()..color = Colors.grey.shade700;
    final Paint fillPaint = Paint()..color = Colors.blue;
    final Paint thumbPaint = Paint()..color = Colors.white;

    // Draw track
    canvas.drawRect(
      Rect.fromLTWH(0, sliderHeight / 3, sliderWidth, sliderHeight / 3),
      trackPaint,
    );

    // Draw fill
    double fillWidth = (valueToPosition(_value));
    canvas.drawRect(
      Rect.fromLTWH(0, sliderHeight / 3, fillWidth, sliderHeight / 3),
      fillPaint,
    );

    // Draw thumb
    double thumbX = fillWidth - sliderHeight / 2;
    _thumbRect = Rect.fromLTWH(thumbX, 0, sliderHeight, sliderHeight);
    canvas.drawOval(_thumbRect, thumbPaint);
  }

  double valueToPosition(double value) =>
      ((value - min) / (max - min)) * sliderWidth;

  double positionToValue(double pos) =>
      (pos / sliderWidth).clamp(0.0, 1.0) * (max - min) + min;

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    if (_thumbRect.contains(event.localPosition.toOffset())) {
      _dragging = true;
    }
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (_dragging) {
      final localX = event.localStartPosition.x;
      _value = positionToValue(localX);
      onChanged?.call(_value);
    }
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    _dragging = false;
  }
}
