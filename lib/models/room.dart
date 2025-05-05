import 'package:flame_practice/models/player.dart';

class Room {
  final String roomId;
  final List<PlayerModel> listPlayers;

  Room({required this.roomId, required this.listPlayers});
}
