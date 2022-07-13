import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/input.dart';

import '../langaw_game.dart';

class Fly extends SpriteAnimationComponent
    with TapCallbacks, Hoverable, DragCallbacks {
  late Iterable<Future<Sprite>> sprites;
  late double sizeRatio;
  late LangawGame game;
  late Vector2 target;
  bool isArrived = false;

  bool isDead = false;
  Fly(this.game);

  @override
  Future<void>? onLoad() async {
    sprites = [1, 2].map((e) => Sprite.load('flies/fly$e.png'));
    animation =
        SpriteAnimation.spriteList(await Future.wait(sprites), stepTime: 0.05);

    target = Vector2.random(game.random)
      ..x *= game.size.x - size.x
      ..y *= game.size.y - size.y;
    return super.onLoad();
  }

  @override
  void onTapDown(TapDownEvent event) {
    isDead = true;

    super.onTapDown(event);
  }

  @override
  bool onHoverEnter(PointerHoverInfo info) {
    isDead = true;
    return true;
  }

  @override
  void onGameResize(Vector2 size) {
    this.size = game.flySize;
    super.onGameResize(size);
  }

  @override
  Future<void> update(double dt) async {
    if (isDead) {
      animation = SpriteAnimation.spriteList(
          [await Sprite.load('flies/dead.png')],
          stepTime: 0.05, loop: false);

      position.moveToTarget(Vector2(x, game.size.y), 5);
      if (y == game.size.y) {
        game.remove(this);
        game.spawnFlies(1);
        game.score++;
      }
    } else {
      if (!isArrived) {
        position.moveToTarget(target, 2);
        if (position == target) {
          isArrived = true;
        }
      } else {
        target = Vector2.random(game.random)
          ..x *= game.size.x - size.x
          ..y *= game.size.y - size.y;
        isArrived = false;
      }

      if (!game.containsPoint(position)) {
        game.remove(this);
        game.spawnFlies(1);
        game.score -= 0.1;
      }
    }
    if (containsPoint(game.dragPosition)) {
      isDead = true;
    }
    super.update(dt);
  }

  @override
  bool get debugMode => true;
}
