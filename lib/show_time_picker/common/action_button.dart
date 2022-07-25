
import 'package:flutter/material.dart';

import '../state/state_container.dart';

/// Render the [Ok] and [Cancel] buttons
class ActionButtons extends StatelessWidget {
  const ActionButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timeState = TimeModelBinding.of(context);
    final color =
        timeState.widget.accentColor ?? Theme.of(context).colorScheme.secondary;
    final defaultButtonStyle = TextButton.styleFrom(
      textStyle: TextStyle(color: color),
    );

    if (timeState.widget.isOnValueChangeMode) {
      return const SizedBox(
        height: 8,
      );
    }

    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          TextButton(
            style: (timeState.widget.cancelButtonStyle ??
                timeState.widget.buttonStyle) ??
                defaultButtonStyle,
            onPressed: timeState.onCancel,
            child: Text(
              timeState.widget.cancelText,
              style: timeState.widget.cancelStyle,
            ),
          ),
          SizedBox(width: timeState.widget.buttonsSpacing ?? 0),
          TextButton(
            onPressed: timeState.onOk,
            style: timeState.widget.buttonStyle ?? defaultButtonStyle,
            child: Text(
              timeState.widget.okText,
              style: timeState.widget.okStyle,
            ),
          ),
        ],
      ),
    );
  }
}
