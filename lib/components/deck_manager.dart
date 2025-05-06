import 'dart:math';

import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flame_practice/models/card.dart';

class DeckManager {
  final List<Card> _deck = [];
  final List<String> suits = ['clubs', 'diamonds', 'hearts', 'spades'];
  final List<String> values = [
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

  bool _isLoaded = false;

  Future<void> load() async {
    if (_isLoaded) return;

    for (final suit in suits) {
      for (final value in values) {
        final path = 'cards/${suit}_$value.png';
        final front = Sprite(await Flame.images.load(path));
        final back = Sprite(
          await Flame.images.load('cards/other_back_red.png'),
        );

        _deck.add(Card(front: front, back: back, suit: suit, value: value));
      }
    }

    _deck.shuffle(Random());
    _isLoaded = true;
  }

  Card drawCard() {
    if (_deck.isEmpty) {
      throw StateError('No more cards in the deck!');
    }
    return _deck.removeLast();
  }

  void resetDeck() {
    _deck.clear();
    _isLoaded = false;
  }
}
