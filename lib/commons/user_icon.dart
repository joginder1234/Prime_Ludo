import 'package:flutter/material.dart';

class UserIcon extends StatelessWidget {
  double height;
  double width;
  UserIcon({Key? key, required this.height, required this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      height: height,
      width: width,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 1.2),
          shape: BoxShape.circle),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(500),
        child: Image.asset(
          'assets/avatar.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
