import 'package:flame/components.dart';
import 'package:flame_practice/game.dart';

class IntervalTimer extends PositionComponent with HasGameReference<MyGame> {
  final double tickDuration;
  final int startTime;

  late Timer _timer;
  late bool hasEnded = false;
  int _currentTick;

  late SpriteComponent tensSprite;
  late SpriteComponent onesSprite;

  IntervalTimer({
    this.tickDuration = 1.0,
    this.startTime = 10,
    super.position,
    super.size,
  }) : _currentTick = startTime {
    _timer = Timer(
      tickDuration,
      onTick: _updateSprite,
      repeat: true,
      autoStart: false,
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_timer.isRunning()) {
      _timer.update(dt);
    }
  }

  void _updateSprite() {
    if (_currentTick > 0) {
      _currentTick--;
    } else {
      hasEnded = true;
      _timer.stop();
      game.timerEnded();
    }
  }

  void start() {
    if (!_timer.isRunning()) {
      hasEnded = false;
      _timer.start();
    }
  }

  void reset() {
    hasEnded = false;
    _currentTick = startTime;
    _timer.stop();
  }
}
