import 'dart:math';

import 'package:flutter/material.dart';

class RevealProgressButton extends StatefulWidget {
  final Color startColor;
  final Color endColor;
  final String name;
  final Function onPressed;
  final int state;

  const RevealProgressButton({
    Key key,
    @required this.startColor,
    @required this.endColor,
    @required this.name,
    @required this.onPressed,
    @required this.state,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RevealProgressButtonState();
}

class _RevealProgressButtonState extends State<RevealProgressButton>
    with TickerProviderStateMixin {
  Animation<double> _animation;
  AnimationController _controller;
  double _fraction = 0.0;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _RevealProgressButtonPainter(
          _fraction, MediaQuery.of(context).size,
          endColor: Colors.transparent //widget.endColor,
          ),
      child: _ProgressButton(
        callback: reveal,
        startColor: widget.startColor,
        endColor: widget.endColor,
        name: widget.name,
        onPressed: () => widget.onPressed(),
        state: widget.state,
      ),
    );
  }

  @override
  void deactivate() {
    reset();
    super.deactivate();
  }

  @override
  dispose() {
    if (_controller != null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void reveal() {
    _controller = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller)
      ..addListener(() {
        setState(() {
          _fraction = _animation.value;
        });
      })
      ..addStatusListener((AnimationStatus state) {
        if (state == AnimationStatus.completed) {
          /* Navigation.navigateTo(context, 'page_two',
              transition: TransitionType.fadeIn); */
        }
      });
    _controller.forward();
  }

  void reset() {
    _fraction = 0.0;
  }
}

class _ProgressButton extends StatefulWidget {
  final Function callback;
  final Color startColor;
  final Color endColor;
  final String name;
  final Function onPressed;
  final int state;

  const _ProgressButton({
    Key key,
    @required this.callback,
    @required this.startColor,
    @required this.endColor,
    @required this.name,
    @required this.onPressed,
    @required this.state,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => __ProgressButtonState();
}

class __ProgressButtonState extends State<_ProgressButton>
    with TickerProviderStateMixin {
  //bool _isPressed = false, _animatingReveal = false;
  double _width = double.infinity;
  Animation _animation;
  GlobalKey _globalKey = GlobalKey();
  AnimationController _controller;

  @override
  dispose() {
    if (_controller != null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PhysicalModel(
        color: widget.startColor,
        elevation: 2,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          key: _globalKey,
          height: 38.0,
          width: widget.state != 0 ? _width : double.infinity,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            decoration: BoxDecoration(
              border: Border.all(
                  color: widget.state == 0 ? Colors.white : widget.startColor,
                  width: 2.5),
              borderRadius: BorderRadius.circular(30),
            ),
            child: RaisedButton(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: EdgeInsets.all(0.0),
              color: widget.state == 2 ? widget.endColor : widget.startColor,
              child: buildButtonChild(name: widget.name),
              disabledColor: widget.startColor,
              onPressed: widget.state == 0
                  ? () {
                      if (!mounted) return;
                      setState(() {
                        widget.onPressed();
                        animateButton();
                      });
                    }
                  : null,
            ),
          ),
        ));
  }

  void animateButton() {
    double initialWidth = _globalKey.currentContext.size.width;

    _controller =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller)
      ..addListener(() {
        setState(() {
          _width = initialWidth - ((initialWidth - 38.0) * _animation.value);
        });
      });
    _controller.forward();
  }

  Widget buildButtonChild({@required String name}) {
    if (widget.state == 0) {
      return Text(
        name,
        style: TextStyle(color: Colors.white, fontSize: 16.0),
      );
    } else if (widget.state == 1) {
      return SizedBox(
        height: 26.0,
        width: 26.0,
        child: CircularProgressIndicator(
          value: null,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    } else {
      return Icon(Icons.check, color: Colors.white);
    }
  }
}

class _RevealProgressButtonPainter extends CustomPainter {
  double _fraction = 0.0;
  Size _screenSize;
  final Color endColor;

  _RevealProgressButtonPainter(this._fraction, this._screenSize,
      {@required this.endColor});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = this.endColor
      ..style = PaintingStyle.fill;

    // todo Fix this
    // This solution is hardcoded,
    // because I know the exact widget position
    var finalRadius = sqrt(pow(_screenSize.width / 2, 2) +
        pow(_screenSize.height - 32.0 - 48.0, 2));
    var radius = 24.0 + finalRadius * _fraction;

    canvas.drawCircle(Offset(size.width / 2, size.height / 2), radius, paint);
  }

  @override
  bool shouldRepaint(_RevealProgressButtonPainter oldDelegate) {
    return oldDelegate._fraction != _fraction;
  }
}
