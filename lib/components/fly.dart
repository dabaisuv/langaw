import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:langaw/langaw_game.dart';

class Fly {
  late Rect flyRect;
  final LangawGame game;
  bool isDead = false;
  bool isOffScreen = false;
  late List<Sprite> flyingSprite;
  late Sprite deadSprite;
  double flyingSpriteIndex = 0;

  late Offset targetLocation;

  double get speed => game.tileSize * 3;

  Fly(this.game) {
    setTargetLocation();
  }

  void render(Canvas canvas) {
    if (isDead) {
      deadSprite.renderRect(canvas, flyRect.inflate(2));
    } else {
      flyingSprite[flyingSpriteIndex.toInt()]
          .renderRect(canvas, flyRect.inflate(2));
    }
  }

  void update(double dt) {
    if (isDead) {
      flyRect = flyRect.translate(0, game.tileSize * 12 * dt);
    } else {
      flyingSpriteIndex += 30 * dt;
      if (flyingSpriteIndex >= 2) {
        flyingSpriteIndex -= 2;
      }

      double stepDistance = speed * dt;
      Offset toTarget = targetLocation - Offset(flyRect.left, flyRect.top);
      if (stepDistance < toTarget.distance) {
        Offset stepToTarget =
            Offset.fromDirection(toTarget.direction, stepDistance);
        flyRect = flyRect.shift(stepToTarget);
      } else {
        flyRect = flyRect.shift(toTarget);
        setTargetLocation();
      }
    }

    if (flyRect.top > game.screenSize.y) {
      isOffScreen = true;
    }
  }

  void onTapDown() {
    // x = Random.secure().nextDouble() * (game.screenSize.x - game.tileSize);
    // y = Random.secure().nextDouble() * (game.screenSize.y - game.tileSize);

    isDead = true;
  }

  void onGameResize() {}

  void setTargetLocation() {
    double x = game.random.nextDouble() *
        (game.screenSize.x - (game.tileSize * 2.025));
    double y = game.random.nextDouble() *
        (game.screenSize.y - (game.tileSize * 2.025));
    targetLocation = Offset(x, y);
  }
}
