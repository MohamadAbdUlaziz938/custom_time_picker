
import 'package:flutter/material.dart';

import '../utils/constant.dart';
import '../state/state_container.dart';

/// Just a simple [Dialog] with common styling
class WrapperDialog extends StatelessWidget {
  /// The child [Widget] to render
  final Widget child;

  /// Constructor for the [Widget]
  const WrapperDialog({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timeState = TimeModelBinding.of(context);
    final borderRadius = timeState.widget.borderRadius ?? BORDER_RADIUS;
    final elevation = timeState.widget.elevation ?? ELEVATION;

    return Dialog(
      insetPadding: timeState.widget.dialogInsetPadding,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      elevation: elevation,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: child,
      ),
    );
  }
}
