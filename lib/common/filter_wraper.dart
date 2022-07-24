import 'dart:ui';

import 'package:flutter/material.dart';

import '../state/state_container.dart';
class FilterWrapper extends StatelessWidget {
  /// child of the filter in the [Widget] tree
  final Widget? child;

  /// Constructor for the [Widget]
  const FilterWrapper({
    Key? key,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timeState = TimeModelBinding.of(context);
    final double blurAmount = timeState.widget.blurredBackground ? 5 : 0;

    if (blurAmount == 0.0) {
      return Container(
        child: child,
      );
    }

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: blurAmount, sigmaY: blurAmount),
      child: child,
    );
  }
}