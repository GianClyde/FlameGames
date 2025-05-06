// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/input.dart';

import 'package:flame_practice/components/betting_buttons.dart';

class BettingButtonsRow extends PositionComponent {
  late SpriteButtonComponent allInButton;
  late SpriteButtonComponent betButton;
  late SpriteButtonComponent foldButton;

  final VoidCallback allInPressed;
  final VoidCallback betPressed;
  final VoidCallback foldPressed;

  late Vector2 btnSize;
  BettingButtonsRow({
    required this.allInPressed,
    required this.betPressed,
    required this.foldPressed,
    super.position,
    super.size,
    super.scale,
    super.priority,
  });

  @override
  FutureOr<void> onLoad() async {
    btnSize = Vector2(90, 40);
    await _createButtons();
    return super.onLoad();
  }

  Future<void> _createButtons() async {
    final allInNormal = await Flame.images.load(
      'buttons/all_in_btn_active.png',
    );
    allInButton = BettingButtons(
      size: btnSize,
      position: Vector2(size.x / 2 - 100, size.y),
      normal: Sprite(allInNormal),
      pressed: Sprite(allInNormal),
      onPressed: allInPressed,
    );

    final betNormal = await Flame.images.load('buttons/bet_btn_active.png');
    betButton = BettingButtons(
      size: btnSize,
      position: Vector2(size.x / 2, size.y),
      normal: Sprite(betNormal),
      pressed: Sprite(betNormal),
      onPressed: betPressed,
    );

    final foldNormal = await Flame.images.load('buttons/focus_btn_active.png');
    foldButton = BettingButtons(
      size: btnSize,
      position: Vector2(size.x / 2 + 100, size.y),
      normal: Sprite(foldNormal),
      pressed: Sprite(foldNormal),
      onPressed: foldPressed,
    );

    add(allInButton);
    add(betButton);
    add(foldButton);
  }
}
