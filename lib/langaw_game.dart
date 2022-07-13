import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'components/fly.dart';

class LangawGame extends FlameGame
    with HasTappableComponents, HasHoverables, HasDraggableComponents {
  bool isFirstLoad = true;
  late SpriteComponent background;
  late List<Fly> flies;
  late Vector2 flySize;
  Random random = Random.secure();
  late TextComponent scoreText;
  late double score;
  late Vector2 dragPosition;

  @override
  Future<void>? onLoad() async {
    dragPosition = Vector2(0, 0);
    background = SpriteComponent()
      ..size = size
      ..sprite = await loadSprite('background/langaw-game-background.png');
    add(background);

    flySize = Vector2(size.x / 9, size.x / 9);

    flies = <Fly>[];
    spawnFlies(100);

    score = 0;
    const style =
        TextStyle(color: Color.fromARGB(255, 220, 225, 77), fontSize: 30);
    final regular = TextPaint(style: style);
    scoreText = TextComponent(text: '得分：$score', textRenderer: regular)
      ..anchor = Anchor.topCenter
      ..x = 1 / 2 * size.x
      ..y = 0;

    add(scoreText);
    return super.onLoad();
  }

  @override
  void onGameResize(Vector2 canvasSize) {
    if (!isFirstLoad) {
      background.size = canvasSize;
      flySize
        ..x = canvasSize.x / 9
        ..y = canvasSize.x / 9;
      scoreText
        ..anchor = Anchor.topCenter
        ..x = 1 / 2 * size.x
        ..y = 0;
    }

    isFirstLoad = false;
    super.onGameResize(canvasSize);
  }

  void spawnFlies(int spawnNum) {
    var tempFlies = Iterable.generate(spawnNum, (int i) {
      double x = random.nextDouble() * (size.x - size.x / 9);
      double y = random.nextDouble() * (size.y - size.x / 9);
      return Fly(this)..position = Vector2(x, y);
    }).toList();

    flies.addAll(tempFlies);

    addAll(tempFlies);
  }

  @override
  void update(double dt) {
    super.update(dt);
    scoreText.text = '得分：$score';
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    dragPosition = event.canvasPosition;
  }
}
