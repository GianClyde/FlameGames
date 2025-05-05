import 'dart:math';
import 'package:flame/cache.dart';
import 'package:flame/components.dart';

class Card {
  final String suit;
  final String value;
  final Sprite front;
  final Sprite back;

  Card({
    required this.suit,
    required this.value,
    required this.front,
    required this.back,
  });

  static final List<String> suits = ['hearts', 'diamonds', 'clubs', 'spades'];
  static final List<String> values = [
    'ace',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    'jack',
    'queen',
    'king',
  ];

  static Future<Card> generateRandomCard(Images images) async {
    final random = Random();
    final suit = suits[random.nextInt(suits.length)];
    final value = values[random.nextInt(values.length)];

    final frontImagePath = 'cards/${suit}_$value.png';
    final backImagePath = 'cards/other_back_red.png';

    final frontImage = await images.load(frontImagePath);
    final backImage = await images.load(backImagePath);

    final frontSprite = Sprite(frontImage);
    final backSprite = Sprite(backImage);

    return Card(suit: suit, value: value, front: frontSprite, back: backSprite);
  }
}
