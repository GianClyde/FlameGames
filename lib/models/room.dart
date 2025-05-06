import 'package:flame_practice/models/user.dart';

class Room {
  final String roomId;
  final List<User> userList;
  final double pot;
  Room({this.pot = 0, required this.roomId, required this.userList});
}
