import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

import 'dart:ui';
import 'dart:math';
import 'components/fly.dart';
import 'components/house_fly.dart';
import 'components/backyard.dart';

class LangawGame extends Game with TapDetector {
  bool isFirst = true;
  late Vector2 screenSize;
  late double tileSize;
  List<Fly> flies = <Fly>[];
  late Random random;
  late Backyard background;

  void spawnFly(int spawnNum) {
    for (var i = 0; i < spawnNum; i++) {
      double x = random.nextDouble() * (screenSize.x - tileSize);
      double y = random.nextDouble() * (screenSize.y - tileSize);

      flies.add(HouseFly(this, x, y));
    }
  }

  @override
  Future<void>? onLoad() {
    background = Backyard(this);
    random = Random.secure();
    spawnFly(20);
    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    // Rect bgRect = Rect.fromLTWH(0, 0, screenSize.x, screenSize.y);
    // Paint bgPaint = Paint();
    // bgPaint.color = const Color(0xff576574);
    // canvas.drawRect(bgRect, bgPaint);
    background.render(canvas);

    for (var fly in flies) {
      fly.render(canvas);
    }
  }

  @override
  void update(double dt) {
    for (var fly in flies) {
      fly.update(dt);
    }
    flies.removeWhere((Fly fly) => fly.isOffScreen);
  }

  @override
  void onGameResize(Vector2 size) {
    screenSize = size;
    tileSize = screenSize.x / 9;

    isFirst ? null : background.onGameResize();

    for (var fly in flies) {
      fly.onGameResize();
    }
    isFirst = false;
    super.onGameResize(size);
  }

  @override
  void onTapDown(TapDownInfo info) {
    var tapedNum = 0;
    for (var fly in flies) {
      if (fly.flyRect.contains(info.raw.localPosition)) {
        fly.onTapDown();
        tapedNum++;
      }
    }

    spawnFly(tapedNum);

    super.onTapDown(info);
  }
}
