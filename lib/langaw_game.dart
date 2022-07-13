import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flame_audio/flame_audio.dart';

import 'components/fly.dart';

class LangawGame extends FlameGame
    with HasTappableComponents, HasHoverables, HasDraggableComponents {
  bool isFirstLoad = true;
  late SpriteComponent background;
  late Vector2 flySize;
  Random random = Random.secure();
  late TextComponent scoreText;
  late double score;

  int get level => (score / 5).floor();

  @override
  Future<void>? onLoad() async {
    //await FlameAudio.audioCache.loadAll(['sfx/biu1.mp3', 'sfx/biu2.mp3']);

    FlameAudio.bgm.initialize();
    FlameAudio.bgm.play('music/dreams.mp3');
    background = SpriteComponent()
      ..size = size
      ..sprite = await loadSprite('background/langaw-game-background.png');
    add(background);

    flySize = Vector2(size.x / 9, size.x / 9);

    spawnFlies(20);

    score = 0;
    const style =
        TextStyle(color: Color.fromARGB(255, 220, 225, 77), fontSize: 30);
    final regular = TextPaint(style: style);
    scoreText =
        TextComponent(text: '等级: $level , 得分: $score', textRenderer: regular)
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

    addAll(tempFlies);
  }

  @override
  void update(double dt) {
    super.update(dt);
    scoreText.text = '等级: $level , 得分: $score';
    if (children.whereType<Fly>().isEmpty) {
      var tmpNum = (level * 10).floor() + 20;
      if (tmpNum >= 50) {
        spawnFlies(random.nextInt(40) + 10);
      } else {
        spawnFlies(random.nextInt(10) + tmpNum);
      }
    }
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    var tmpChildren = children.whereType<Fly>();
    for (var fly in tmpChildren) {
      if (fly.containsPoint(event.canvasPosition)) {
        if (!fly.isDead) {
          playBiu();
          fly.isDead = true;
        }
      }
    }
  }

  void playBiu() {
    var index = random.nextInt(2) + 1;
    FlameAudio.play('sfx/biu$index.mp3');
  }
}
