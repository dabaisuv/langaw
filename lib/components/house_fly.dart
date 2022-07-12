import 'dart:ui';

import 'package:langaw/components/fly.dart';

import 'fly.dart';
import 'package:flame/sprite.dart';

class HouseFly extends Fly {
  HouseFly(super.game, double x, double y) {
    flyRect = Rect.fromLTWH(x, y, game.tileSize, game.tileSize);
    flyingSprite = <Sprite>[];
    Sprite.load('flies/fly1.png').then((value) => flyingSprite.add(value));
    Sprite.load('flies/fly2.png').then((value) => flyingSprite.add(value));
    Sprite.load('flies/dead.png').then((value) => deadSprite = value);
  }
}
