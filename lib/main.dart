import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'langaw_game.dart';

void main() {
  LangawGame langawGame = LangawGame();
  runApp(GameWidget(
    game: langawGame,
    mouseCursor: SystemMouseCursors.none,
  ));
  Flame.device.fullScreen();
  Flame.device.setOrientation(DeviceOrientation.portraitUp);
  Flame.images.loadAll(<String>[
    'flies/fly1.png',
    'flies/fly2.png',
    'flies/dead.png',
    'background/langaw-game-background.png',
  ]);
}
