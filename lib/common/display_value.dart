// ignore_for_file: no_leading_underscores_for_local_identifiers


import 'package:flutter/material.dart';

import '../state/state_container.dart';

/// Render the [Hour] or [Minute] value for `Android` picker
class DisplayValue extends StatelessWidget {
  /// The [value] to display
  final String value;

  /// The [onTap] handler
  final Null Function()? onTap;

  /// Whether the [value] is selected or not
  final bool isSelected;

  /// Constructor for the [Widget]
  const DisplayValue({
    Key? key,
    required this.value,
    this.onTap,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timeState = TimeModelBinding.of(context);
    final _commonTimeStyles = Theme.of(context).textTheme.headline2!.copyWith(
      fontSize: 62,
      fontWeight: FontWeight.bold,
    );

    final color =
        timeState.widget.accentColor ?? Theme.of(context).colorScheme.secondary;
    final unselectedColor = timeState.widget.unselectedColor ?? Colors.grey;

    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3.0),
        child: InkWell(
          onTap: onTap,
          child: Text(
            value,
            textScaleFactor: 1.0,
            style: _commonTimeStyles.copyWith(
                color: isSelected ? color : unselectedColor),
          ),
        ),
      ),
    );
  }
}
