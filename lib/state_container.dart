import 'package:emrals/data/database_helper.dart';
import 'package:emrals/models/user.dart';
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
  final User initialUser;
  final double initialEmrals;
  StateContainer({@required this.child, this.initialUser, this.initialEmrals});
  static StateContainerState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_InheritedStateContainer)
            as _InheritedStateContainer)
        .data;
  }

  @override
  StateContainerState createState() => StateContainerState();
}

class StateContainerState extends State<StateContainer> {
  double oldEmrals;
  double emralsBalance;
  User loggedInUser;

  @override
  void initState() {
    super.initState();
    loggedInUser = widget.initialUser;
    emralsBalance = widget.initialEmrals;
    DatabaseHelper().getUser().then((u) {
      oldEmrals = u.emrals;
    });
  }

  void refreshUser() async {
    loggedInUser = await DatabaseHelper().getUser();
    setState(() {
      updateEmrals(loggedInUser.emrals);
    });
  }

  void updateEmrals(double emrals) {
    double temp = emralsBalance;
    setState(() {
      this.emralsBalance = emrals;
    });
    oldEmrals = temp;
  }

  void updateUser(User user) {
    setState(() {
      this.loggedInUser = user;
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
