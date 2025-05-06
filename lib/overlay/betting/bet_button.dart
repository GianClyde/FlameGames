import 'package:flutter/widgets.dart';

class BetButton extends StatelessWidget {
  final String btnImgPath;
  final VoidCallback onPressed;
  const BetButton({
    super.key,
    required this.btnImgPath,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      width: 150,
      child: GestureDetector(onTap: onPressed, child: Image.asset(btnImgPath)),
    );
  }
}
