import 'dart:async';
import 'package:flame/components.dart';

class HeaderText extends TextComponent {
  final String userName;

  HeaderText({required this.userName, super.position, super.size});

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();
    text = "$userName's turn";
  }

  void updateUserName(String userName) {
    text = "$userName's turn";
  }
}
