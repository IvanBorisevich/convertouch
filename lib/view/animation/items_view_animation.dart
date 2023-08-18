import 'package:convertouch/presenter/bloc/items_view_animation_bloc.dart';
import 'package:flutter/material.dart';

class ConvertouchItemsViewAnimation {
  static void startItemsAnimation() async {
    await Future.sync(() => ItemsViewAnimationBloc.I.sendItemIndexToAnimate(0));
  }

  static Widget wrapItemIntoAnimation(
    Widget item, {
    Duration duration = const Duration(milliseconds: 150),
  }) {
    return ConvertouchItemAnimation(
      item: item,
      duration: duration,
    );
  }

  static void dispose() {
    ItemsViewAnimationBloc.I.dispose();
  }
}

class ConvertouchItemAnimation extends StatefulWidget {
  final Widget item;
  final Duration duration;

  const ConvertouchItemAnimation({
    required this.item,
    required this.duration,
    super.key,
  });

  @override
  State createState() => _ConvertouchItemAnimationState();
}

class _ConvertouchItemAnimationState extends State<ConvertouchItemAnimation>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: ItemsViewAnimationBloc.I.listenToItemIndexToAnimate,
      initialData: 0,
      builder: (context, AsyncSnapshot<int> snapshot) {
        _controller.forward();
        return ScaleTransition(
          scale: _animation,
          child: FadeTransition(
            opacity: _animation,
            child: widget.item,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
