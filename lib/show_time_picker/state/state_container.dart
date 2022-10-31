// ignore_for_file: must_be_immutable, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';

import '../utils/constant.dart';
import 'time.dart';

/// Stateful [Widget] for [InheritedWidget]
class TimeModelBinding extends StatefulWidget {
  Time initialTime;
  Time selectedTime;

  final void Function(TimeOfDay) onChange;

  final void Function(DateTime)? onChangeDateTime;

  final void Function()? onCancel;

  final bool is24HrFormat;

  final bool? displayHeader;

  final Color? accentColor;

  final Color? unselectedColor;

  String cancelText;

  String okText;

  final Image? sunAsset;

  final Image? moonAsset;

  final bool blurredBackground;

  final double? borderRadius;

  final double? elevation;

  final EdgeInsets? dialogInsetPadding;

  final MinuteInterval? minuteInterval;

  bool? disableMinute;
  bool? disableMinuteIfMaxHourSelected;
  double minMinuteAtCurrentHour;

  final bool? disableHour;

  final double? maxHour;

  double? maxMinute;

  final double? minHour;

  double? minMinute;

  final String? hourLabel;

  final String? minuteLabel;

  final bool isInlineWidget;

  final bool isOnValueChangeMode;

  final bool focusMinutePicker;

  final bool ltrMode;

  TextStyle okStyle;

  TextStyle cancelStyle;

  ButtonStyle? buttonStyle;

  ButtonStyle? cancelButtonStyle;

  double? buttonsSpacing;
  double maxMinuteAtMaximumHour = 0;

  final Widget child;

  TimeModelBinding({
    Key? key,
    required this.initialTime,
    required this.child,
    required this.selectedTime,
    required this.onChange,
    this.onChangeDateTime,
    this.onCancel,
    this.is24HrFormat = false,
    this.displayHeader,
    this.accentColor,
    this.ltrMode = true,
    this.unselectedColor,
    this.cancelText = "cancel",
    this.okText = "ok",
    this.isOnValueChangeMode = false,
    this.sunAsset,
    this.moonAsset,
    this.blurredBackground = false,
    this.borderRadius,
    this.elevation,
    this.dialogInsetPadding,
    this.minuteInterval,
    this.disableMinute,
    this.disableMinuteIfMaxHourSelected,
    this.disableHour,
    this.maxHour,
    this.maxMinute,
    this.minHour,
    this.minMinute,
    required this.maxMinuteAtMaximumHour,
    required this.minMinuteAtCurrentHour,
    this.hourLabel,
    this.minuteLabel,
    this.isInlineWidget = false,
    this.focusMinutePicker = false,
    this.okStyle = const TextStyle(fontWeight: FontWeight.bold),
    this.cancelStyle = const TextStyle(fontWeight: FontWeight.bold),
    this.buttonStyle,
    this.cancelButtonStyle,
    this.buttonsSpacing,
  }) : super(key: key);

  @override
  TimeModelBindingState createState() => TimeModelBindingState();

  static TimeModelBindingState of(BuildContext context) {
    final _ModelBindingScope scope =
        context.dependOnInheritedWidgetOfExactType<_ModelBindingScope>()!;
    return scope.modelBindingState;
  }
}

class _ModelBindingScope extends InheritedWidget {
  final TimeModelBindingState modelBindingState;

  const _ModelBindingScope({
    Key? key,
    required this.modelBindingState,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_ModelBindingScope oldWidget) => true;
}

class TimeModelBindingState extends State<TimeModelBinding> {
  late Time initTime = widget.initialTime;
  late Time time = widget.selectedTime;

  bool hourIsSelected = true;

  DayPeriod lastPeriod = DayPeriod.am;

  @override
  void initState() {
    bool _hourIsSelected = true;

    if (widget.focusMinutePicker || widget.disableHour!) {
      _hourIsSelected = false;
    }

    setState(() {
      hourIsSelected = _hourIsSelected;
    });
    super.initState();
  }

  bool didPeriodChange() {
    return lastPeriod != time.period;
  }

  void onAmPmChange(DayPeriod e) {
    setState(() {
      lastPeriod = time.period;
      time = time.setPeriod(e);
    });
  }

  onTimeChange(double value) {
    if (hourIsSelected) {
      onHourChange(value);
    } else {
      onMinuteChange(value);
    }
  }

  void onHourChange(double value) {
    setState(() {
      time = time.replacing(hour: value.round());
    });
  }

  void onMinuteChange(double value) {
    setState(() {
      time = time.replacing(minute: value.ceil());
    });
  }

  void changeMinMinute(double minMinute) {
    setState(() {
      widget.minMinute = minMinute;
    });
  }
  void changeMaxMinute({double? maxMinute}) {
    setState(() {
      widget.maxMinute = maxMinute??widget.maxMinuteAtMaximumHour;
    });
  }

  /// Change handler for `hourIsSelected`
  void onHourIsSelectedChange(bool newValue) {
    setState(() {
      hourIsSelected = newValue;
    });
  }

  /// [onChange] handler. Return [TimeOfDay]
  onOk() {
    widget.onChange(time.toTimeOfDay());
    if (widget.onChangeDateTime != null) {
      final now = DateTime.now();
      final dateTime =
          DateTime(now.year, now.month, now.day, time.hour, time.minute);
      widget.onChangeDateTime!(dateTime);
    }
    onCancel(result: time.toTimeOfDay());
  }

  /// Handler to close the picker
  onCancel({var result}) {
    if (widget.onCancel != null) {
      widget.onCancel!();
      return;
    }

    if (!widget.isInlineWidget) {
      Navigator.of(context).pop(result);
    }
  }

  /// Check if time is within range.
  /// Used to disable `AM/PM`.
  /// Example: if user provided [minHour] as `9` and [maxHour] as `21`,
  /// then the user should only be able to toggle `AM/PM` for `9am` and `9pm`
  bool checkIfWithinRange(DayPeriod other) {
    final tempTime = Time(time.hour, time.minute).setPeriod(other);
    final expectedHour = tempTime.hour;
    return widget.minHour! <= expectedHour && expectedHour <= widget.maxHour!;
  }

  @override
  Widget build(BuildContext context) {
    return _ModelBindingScope(
      modelBindingState: this,
      child: widget.child,
    );
  }
}
