import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class _InheritedStateContainer extends InheritedWidget {
  final StateContainerState data;

  _InheritedStateContainer({
    Key key,
    @required this.data,
    @required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_InheritedStateContainer old) => true;
}

class StateContainer extends StatefulWidget {
  final Widget child;
  StateContainer({@required this.child});
  static StateContainerState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_InheritedStateContainer)
            as _InheritedStateContainer)
        .data;
  }

  @override
  StateContainerState createState() => StateContainerState();
}

class StateContainerState extends State<StateContainer>
    with TickerProviderStateMixin {
  double emralsBalance;
  // AnimationController _controller;
  // Animation<double> animation;

  void updateEmrals(double emrals) {
    // _controller = new AnimationController(
    //   vsync: this,
    //   duration: const Duration(milliseconds: 1500),
    // );
    // animation = _controller;

    setState(() {
      // animation = new Tween<double>(
      //   begin: emralsBalance,
      //   end: emrals,
      // ).animate(new CurvedAnimation(
      //   curve: Curves.fastOutSlowIn,
      //   parent: _controller,
      // ));
      // if (emralsBalance < emrals) {
      //   _controller.forward(from: emralsBalance);
      // } else {
      //   _controller.reverse(from: emralsBalance);
      // }

      emralsBalance = emrals;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedStateContainer(
      data: this,
      child: widget.child,
    );
  }
}
