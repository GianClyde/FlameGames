import 'package:flame_practice/overlay/betting/bet_button.dart';
import 'package:flutter/material.dart';

class Better extends StatefulWidget {
  const Better({super.key});
  @override
  State<Better> createState() => _BetterState();
}

class _BetterState extends State<Better> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: BoxDecoration(color: Colors.black.withAlpha(150)),
        width: 500,
        height: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Text("PHP 100.00"),
                Slider(
                  value: 200.0,
                  onChanged: (value) {},
                  min: 100,
                  max: 1000,
                ),
              ],
            ),
            Row(
              children: [
                BetButton(
                  btnImgPath: "assets/images/overlay/max_btn.png",
                  onPressed: () {},
                ),
                BetButton(
                  btnImgPath: "assets/images/overlay/max_btn.png",
                  onPressed: () {},
                ),
                BetButton(
                  btnImgPath: "assets/images/overlay/max_btn.png",
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
