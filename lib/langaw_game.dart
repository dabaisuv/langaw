import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/audio_pool.dart';
import 'package:flutter/material.dart';
import 'package:flame_audio/flame_audio.dart';

import 'components/fly.dart';
import 'components/flame_cursor.dart';

class LangawGame extends FlameGame
    with HasTappableComponents, HasHoverables, HasDraggableComponents {
  bool isFirstLoad = true;
  late SpriteComponent background;
  late Vector2 flySize;
  Random random = Random.secure();
  late TextComponent scoreText;
  late double score;
  late AudioPool biu1Pool;
  late AudioPool biu2Pool;
  late AudioPool bgmPool;
  late FlameCursor flameCursor;
  late Vector2 mousePosition;

  int get level => (score / 5).floor();

  @override
  Future<void>? onLoad() async {
    //init cursor
    flameCursor = FlameCursor()
      ..size = Vector2(size.x / 18, size.x / 18)
      ..position = size / 2
      ..priority = 2;
    add(flameCursor);
    mousePosition = size / 2;

    //init audio
    biu1Pool = await AudioPool.create('audio/sfx/biu1.mp3', maxPlayers: 100);
    biu2Pool = await AudioPool.create('audio/sfx/biu2.mp3', maxPlayers: 100);
    FlameAudio.bgm.play('music/dreams.mp3');

    //init background
    background = SpriteComponent()
      ..size = size
      ..sprite = await loadSprite('background/langaw-game-background.png');
    add(background);

    //init flysize
    flySize = Vector2(size.x / 9, size.x / 9);

    //spawn flies
    spawnFlies(20);

    //init score board
    score = 0;
    const style =
        TextStyle(color: Color.fromARGB(255, 220, 225, 77), fontSize: 20);
    final regular = TextPaint(style: style);
    scoreText = TextComponent(
        text:
            '等级: $level , 得分: $score , 剩余: ${children.whereType<Fly>().where((element) => element.isDead == false).length}',
        textRenderer: regular)
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
    scoreText.text =
        '等级: $level , 得分: $score , 剩余: ${children.whereType<Fly>().where((element) => element.isDead == false).length}';
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
    updateCursorPosition(event.canvasPosition);
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

  @override
  void onMouseMove(PointerHoverInfo info) {
    updateCursorPosition(info.eventPosition.global);
    super.onMouseMove(info);
    propagateToChildren<Hoverable>((c) => c.handleMouseMovement(info));
  }

  void playBiu() {
    var index = random.nextInt(2) + 1;
    if (index == 1) {
      biu1Pool.start();
    } else {
      biu2Pool.start();
    }
  }

  void updateCursorPosition(Vector2 position) {
    mousePosition = position;
    flameCursor.position = mousePosition;
  }
}
