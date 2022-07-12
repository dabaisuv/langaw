import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:langaw/langaw_game.dart';

class Backyard {
  late LangawGame game;
  late Sprite bgSprite;
  late Rect bgRect;

  Backyard(this.game) {
    bgRect = Rect.fromLTWH(0, game.screenSize.y - (game.tileSize * 23),
        game.tileSize * 9, game.tileSize * 23);
    Sprite.load('background/langaw-game-background.png').then((value) {
      bgSprite = value;
    });
  }

  void render(Canvas canvas) {
    bgSprite.renderRect(canvas, bgRect);
  }

  void update(double dt) {}

  void onGameResize() {
    bgRect = Rect.fromLTWH(0, game.screenSize.y - (game.tileSize * 23),
        game.tileSize * 9, game.tileSize * 23);
  }
}
