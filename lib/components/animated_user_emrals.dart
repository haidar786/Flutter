import 'package:emrals/state_container.dart';
import 'package:emrals/styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AnimatedUserEmrals extends StatefulWidget {
  final double initialEmrals;
  final formatter = new NumberFormat("#,###");
  AnimatedUserEmrals({this.initialEmrals});

  @override
  _AnimatedUserEmralsState createState() => _AnimatedUserEmralsState();
}

class _AnimatedUserEmralsState extends State<AnimatedUserEmrals> with SingleTickerProviderStateMixin{
  Animation emralsAnimation;
  AnimationController emralsAnimationController;

  @override
  void dispose() {
    super.dispose();
    emralsAnimationController.dispose();
  }

  @override
  void initState() {
    super.initState();
    emralsAnimationController = AnimationController(duration: Duration(seconds: 2), vsync: this);
  }

  Future runAnimation(double end, double begin) async{
    emralsAnimation = Tween<double>(end: end, begin: begin).animate(CurvedAnimation(parent: emralsAnimationController, curve: Curves.linear));
    emralsAnimationController.reset();
    await emralsAnimationController.forward();
  }


  @override
  Widget build(BuildContext context) {
    double oldEmrals = StateContainer.of(context).oldEmrals ?? 0;
    double newEmrals = StateContainer.of(context).emralsBalance ?? 0;
    if (oldEmrals != newEmrals) {
      runAnimation(newEmrals, oldEmrals).whenComplete(() {
        oldEmrals = newEmrals;
        StateContainer.of(context).oldEmrals = newEmrals;
      });
    } else {
      emralsAnimation = AlwaysStoppedAnimation(newEmrals);
      oldEmrals = newEmrals;
    }

    return AnimatedBuilder(
      animation: emralsAnimation,
      builder: (ctx, w) {
        return Text(
          widget.formatter.format(emralsAnimation.value),
          style: TextStyle(
            color: emralsColor(),
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        );
      },
    );
  }
}
