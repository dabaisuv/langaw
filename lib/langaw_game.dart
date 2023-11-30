import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';

import 'package:flame/game.dart';
import 'package:flame/text.dart';

import 'package:flame_audio/flame_audio.dart';
import 'components/fly.dart';
import 'components/flame_cursor.dart';

class LangawGame extends FlameGame
    with TapCallbacks, DragCallbacks, HoverCallbacks {
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
    await FlameAudio.audioCache.load('sfx/biu1.mp3');
    await FlameAudio.audioCache.load('sfx/biu2.mp3');
    await FlameAudio.audioCache.load('music/dreams.mp3');
    // print(FlameAudio.audioCache.loadedFiles.entries);
    biu1Pool = await FlameAudio.createPool(
      'sfx/biu1.mp3',
      maxPlayers: 99,
    );

    biu2Pool = await FlameAudio.createPool(
      'sfx/biu2.mp3',
      maxPlayers: 99,
    );

    //init cursor
    flameCursor = FlameCursor()
      ..size = Vector2(size.x / 18, size.x / 18)
      ..position = size / 2
      ..priority = 2;
    add(flameCursor);
    mousePosition = size / 2;

    //init audio
    FlameAudio.bgm.initialize();
    FlameAudio.bgm.audioPlayer.play(
        AssetSource(
          'music/dreams.mp3',
        ),
        volume: 0.3);
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
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    if (!isFirstLoad) {
      background.size = size;
      flySize
        ..x = size.x / 9
        ..y = size.x / 9;
      scoreText
        ..anchor = Anchor.topCenter
        ..x = 1 / 2 * size.x
        ..y = 0;
    }

    isFirstLoad = false;
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
  void onPointerMove(PointerMoveEvent event) {
    super.onPointerMove(event);
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

  void playBiu() {
    // var index = random.nextInt(2) + 1;
    // if (index == 1) {
    //   biu1Pool.start();
    // } else {
    //   biu2Pool.start();
    // }
  }

  void updateCursorPosition(Vector2 position) {
    mousePosition = position;
    flameCursor.position = mousePosition;
  }
}
