import 'package:emrals/styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AnimatedText extends StatefulWidget {
  /// Text widget that animates from 0 to [value]
  final double value;
  final Duration duration;
  final TextStyle textStyle;

  const AnimatedText(
      {Key key,
      @required this.value,
      this.duration = const Duration(milliseconds: 500),
      this.textStyle = const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: EMRALS_COLOR,
      )})
      : super(key: key);
  @override
  _AnimatedTextState createState() => _AnimatedTextState();
}

class _AnimatedTextState extends State<AnimatedText>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  final formatter = NumberFormat("#,###");
  AnimationController controller;
  Animation<double> animation;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    animation = Tween<double>(
      begin: 0,
      end: widget.value,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.linear,
      ),
    );
    controller.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, _) {
        return Text(
          formatter.format(animation.value),
          style: widget.textStyle,
        );
      },
    );
  }
}
