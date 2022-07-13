import 'package:flame/components.dart';

class FlameCursor extends SpriteComponent {
  @override
  Future<void>? onLoad() async {
    sprite = await Sprite.load('cursors/Red_Fire_Cursor.gif');

    return super.onLoad();
  }
}
