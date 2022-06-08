import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

class CustomShowCaseWidget extends StatelessWidget {
  final GlobalKey globalKey;
  final String desc;
  final Widget child;
  final double paddingAll;
  final bool? isCircle;

  const CustomShowCaseWidget(
      {Key? key,
      required this.globalKey,
      required this.desc,
      required this.child,
      required this.paddingAll,
      this.isCircle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Showcase(
      key: globalKey,
      child: child,
      description: desc,
      overlayPadding: EdgeInsets.all(paddingAll),
      shapeBorder: isCircle != null && isCircle! ? const CircleBorder() : null,
      radius: isCircle != null && isCircle!
          ? const BorderRadius.all(Radius.circular(70))
          : null,
    );
  }
}
