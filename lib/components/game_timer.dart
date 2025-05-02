import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame_practice/game.dart';

class GameTimer extends Component with HasGameReference<MyGame> {
  final List<Sprite> sprites;
  final SpriteComponent spriteComponent;
  final SpriteComponent backgroundSprite;
  final double tickDuration;
  final int totalTicks;

  late Timer _timer;
  int _currentTick = 0;

  GameTimer({
    required this.backgroundSprite,
    required this.sprites,
    required this.spriteComponent,
    this.tickDuration = 1.0,
    this.totalTicks = 5,
  }) {
    _timer = Timer(tickDuration, onTick: _updateSprite, repeat: true);
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    spriteComponent.sprite = sprites[_currentTick];
    add(backgroundSprite);
    add(spriteComponent);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _timer.update(dt);
  }

  void _updateSprite() {
    if (_currentTick < totalTicks - 1) {
      _currentTick++;
      spriteComponent.sprite = sprites[_currentTick];
    } else {
      _timer.stop();
      //game.timerEnded();
    }
  }

  void start() => _timer.start();
}
