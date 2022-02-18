import 'package:flutter/material.dart';

class ScoreBanner extends StatelessWidget {
  double width;
  double height;
  AlignmentDirectional alignment;
  bool showBannerBg;
  double textsize;
  ScoreBanner(
      {Key? key,
      required this.width,
      required this.height,
      required this.alignment,
      required this.showBannerBg,
      required this.textsize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: height,
      child: SizedBox(
          child: Stack(alignment: AlignmentDirectional.center, children: [
        showBannerBg ? Image.asset('assets/drop1.png') : const SizedBox(),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/coin.png',
            ),
            Text(
              '100.00',
              style: TextStyle(
                  fontSize: textsize,
                  fontWeight: FontWeight.bold,
                  color: showBannerBg ? Colors.black : const Color(0xffFFD700)),
            )
          ],
        ),
      ])),
    );
  }
}
