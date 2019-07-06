import 'package:flutter/widgets.dart';

// Adds a dispose method useful for closing constrollers thus preventing memory leaks.

Type _getType<B>() => B;

class BlocProvider<B> extends StatefulWidget {
  final void Function(BuildContext context, B bloc) onDispose;
  final B Function(BuildContext context, B bloc) builder;
  final Widget child;

  BlocProvider({
    Key key,
    @required this.child,
    @required this.builder,
    @required this.onDispose,
  }) : super(key: key);
  BlocProviderState<B> createState() => BlocProviderState<B>();
}

class BlocProviderState<B> extends State<BlocProvider<B>> {
  B bloc;

  @override
  void initState() {
    super.initState();
    if (widget.builder != null) {
      bloc = widget.builder(context, bloc);
    }
  }

  @override
  void dispose() {
    if (widget.onDispose != null) {
      widget.onDispose(context, bloc);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Provider(
      bloc: bloc,
      child: widget.child,
    );
  }
}

class Provider<B> extends InheritedWidget {
  final B bloc;

  Provider({Key key, this.bloc, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(Provider<B> oldWidget) {
    return oldWidget.bloc != bloc;
  }

  static B of<B>(BuildContext context) {
    final type = _getType<Provider<B>>();
    final Provider<B> provider = context.inheritFromWidgetOfExactType(type);

    return provider.bloc;
  }
}
