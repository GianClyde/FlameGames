import 'package:flame/game.dart';
import 'package:flame_practice/game.dart';
import 'package:flame_practice/models/room.dart';
import 'package:flame_practice/models/user.dart';
import 'package:flame_practice/models/wallets.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() {
  final MyGame game = MyGame(
    room: Room(
      roomId: "ASdsad",
      userList: [
        User(
          id: "12345",
          userName: "Me",
          userWallet: Wallet(walletId: "12345w", balance: 1000),
        ),
        User(
          id: "54211",
          userName: "You",
          userWallet: Wallet(walletId: "12345a", balance: 2000),
        ),
        User(
          id: "54211",
          userName: "Us",
          userWallet: Wallet(walletId: "12345a", balance: 3000),
        ),
        User(
          id: "1423432",
          userName: "They",
          userWallet: Wallet(walletId: "423432", balance: 4000),
        ),
      ],
    ),
  );

  runApp(MaterialApp(home: Scaffold(body: GameWidget(game: game))));
}
