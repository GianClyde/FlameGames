import 'package:flame_practice/models/user.dart';

class Room {
  final String roomId;
  final List<User> userList;

  Room({required this.roomId, required this.userList});
}
