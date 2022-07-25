import 'package:flutter/material.dart';

import 'state/state_container.dart';
import 'state/time.dart';
import 'utils/constant.dart';
import 'widgets/android_builder/day_time_picker_android.dart';

PageRouteBuilder showPicker({
  BuildContext? context,
  required TimeOfDay value,
  required void Function(TimeOfDay) onChange,
  void Function(DateTime)? onChangeDateTime,
  void Function()? onCancel,
  bool is24HrFormat = false,
  Color? accentColor,
  Color? unselectedColor,
  String cancelText = "Cancel",
  String okText = "Ok",
  Image? sunAsset,
  Image? moonAsset,
  bool blurredBackground = false,
  bool ltrMode = true,
  Color barrierColor = Colors.black45,
  double? borderRadius,
  double? elevation,
  EdgeInsets? dialogInsetPadding =
      const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
  bool barrierDismissible = true,
  bool iosStylePicker = false,
  bool displayHeader = true,
  String hourLabel = 'hours',
  String minuteLabel = 'minutes',
  MinuteInterval minuteInterval = MinuteInterval.ONE,
  bool disableMinute = false,
  bool disableHour = false,
  bool disableMinuteIfMaxHourSelected = false,
  double minMinuteAtCurrentHour = -1,
  double minMinute = 0,
  double maxMinute = 59,
  ThemeData? themeData,
  bool focusMinutePicker = false,
  // Infinity is used so that we can assert whether or not the user actually set a value
  double minHour = double.infinity,
  double maxHour = double.infinity,
  TextStyle okStyle = const TextStyle(fontWeight: FontWeight.bold),
  TextStyle cancelStyle = const TextStyle(fontWeight: FontWeight.bold),
  ButtonStyle? buttonStyle,
  ButtonStyle? cancelButtonStyle,
  double? buttonsSpacing,
}) {
  if (minHour == double.infinity) {
    minHour = 0;
  }
  if (maxHour == double.infinity) {
    maxHour = 23;
  }

  assert(!(disableHour == true && disableMinute == true),
      "Both \"disableMinute\" and \"disableHour\" cannot be true.");
  assert(!(disableMinuteIfMaxHourSelected == true && disableMinute == true),
      "Both \"disableMinute\" and \"disableMinuteIfMaxHourSelected\" cannot be true.");
  assert(!(disableMinute == true && focusMinutePicker == true),
      "Both \"disableMinute\" and \"focusMinutePicker\" cannot be true.");
  assert(maxMinute <= 59, "\"maxMinute\" must be less than or equal to 59");
  assert(minMinute >= 0, "\"minMinute\" must be greater than or equal to 0");
  assert(maxHour <= 23 && minHour >= 0,
      "\"minHour\" and \"maxHour\" should be between 0-23");
  assert(!(minMinute > 0 && minMinuteAtCurrentHour > 0),
      "\"minMinute\" and \"minMinuteAtCurrentHour\" can't be selected together");
  if (disableMinuteIfMaxHourSelected == true) {
    if (maxHour == value.hour) {
      disableMinute = true;
    }
  }
  if (minMinuteAtCurrentHour > 0) {
    minMinute = minMinuteAtCurrentHour;
  }

  final timeValue = Time.fromTimeOfDay(value);

  return PageRouteBuilder(
    pageBuilder: (context, _, __) {
      {
        return Theme(
          data: themeData ?? Theme.of(context),
          child: const DayNightTimePickerAndroid(),
        );
      }
    },
    transitionDuration: const Duration(milliseconds: 200),
    transitionsBuilder: (context, anim, secondAnim, child) => SlideTransition(
      position: anim.drive(
        Tween(
          begin: const Offset(0, 0.15),
          end: const Offset(0, 0),
        ).chain(
          CurveTween(curve: Curves.ease),
        ),
      ),
      child: FadeTransition(
        opacity: anim,
        child: TimeModelBinding(
          minMinuteAtCurrentHour: minMinuteAtCurrentHour,
          initialTime: timeValue,
          isInlineWidget: false,
          onChange: onChange,
          disableMinuteIfMaxHourSelected: disableMinuteIfMaxHourSelected,
          onChangeDateTime: onChangeDateTime,
          onCancel: onCancel,
          is24HrFormat: is24HrFormat,
          displayHeader: displayHeader,
          accentColor: accentColor,
          unselectedColor: unselectedColor,
          cancelText: cancelText,
          okText: okText,
          sunAsset: sunAsset,
          moonAsset: moonAsset,
          blurredBackground: blurredBackground,
          borderRadius: borderRadius,
          elevation: elevation,
          dialogInsetPadding: dialogInsetPadding,
          minuteInterval: minuteInterval,
          disableMinute: disableMinute,
          disableHour: disableHour,
          maxHour: maxHour,
          maxMinute: maxMinute,
          minHour: minHour,
          minMinute: minMinute,
          focusMinutePicker: focusMinutePicker,
          okStyle: okStyle,
          cancelStyle: cancelStyle,
          buttonStyle: buttonStyle,
          cancelButtonStyle: cancelButtonStyle,
          buttonsSpacing: buttonsSpacing,
          hourLabel: hourLabel,
          minuteLabel: minuteLabel,
          ltrMode: ltrMode,
          child: child,
        ),
      ),
    ),
    barrierDismissible: barrierDismissible,
    opaque: false,
    barrierColor: barrierColor,
  );
}

Widget createInlinePicker({
  BuildContext? context,
  required TimeOfDay value,
  required void Function(TimeOfDay) onChange,
  void Function(DateTime)? onChangeDateTime,
  void Function()? onCancel,
  bool is24HrFormat = false,
  Color? accentColor,
  Color? unselectedColor,
  String cancelText = "Cancel",
  String okText = "Ok",
  bool isOnChangeValueMode = false,
  bool ltrMode = true,
  Image? sunAsset,
  Image? moonAsset,
  bool blurredBackground = false,
  Color barrierColor = Colors.black45,
  double? borderRadius,
  double? elevation,
  EdgeInsets? dialogInsetPadding =
      const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
  bool barrierDismissible = true,
  bool iosStylePicker = false,
  String hourLabel = 'hours',
  String minuteLabel = 'minutes',
  MinuteInterval minuteInterval = MinuteInterval.ONE,
  bool disableMinute = false,
  bool disableMinuteIfMaxHourSelected = false,
  bool disableHour = false,
  double minMinute = 0,
  double maxMinute = 59,
  bool displayHeader = true,
  ThemeData? themeData,
  bool focusMinutePicker = false,
  // Infinity is used so that we can assert whether or not the user actually set a value
  double minHour = double.infinity,
  double minMinuteAtCurrentHour = 0,
  double maxHour = double.infinity,
  TextStyle okStyle = const TextStyle(fontWeight: FontWeight.bold),
  TextStyle cancelStyle = const TextStyle(fontWeight: FontWeight.bold),
  ButtonStyle? buttonStyle,
  ButtonStyle? cancelButtonStyle,
  double? buttonsSpacing,
}) {
  if (minHour == double.infinity) {
    minHour = 0;
  }
  if (maxHour == double.infinity) {
    maxHour = 23;
  }

  assert(!(disableHour == true && disableMinute == true),
      "Both \"disableMinute\" and \"disableHour\" cannot be true.");
  assert(!(disableMinute == true && focusMinutePicker == true),
      "Both \"disableMinute\" and \"focusMinutePicker\" cannot be true.");
  assert(maxMinute <= 59, "\"maxMinute\" must be less than or equal to 59");
  assert(minMinute >= 0, "\"minMinute\" must be greater than or equal to 0");
  assert(maxHour <= 23 && minHour >= 0,
      "\"minHour\" and \"maxHour\" should be between 0-23");
  assert(minMinute != 0 && minMinuteAtCurrentHour != 0,
      "\"minMinute\" and \"minMinuteAtCurrentHour\" can't be selected together");
  if (disableMinuteIfMaxHourSelected == true) {
    if (maxHour == value.hour) {
      disableMinute = true;
    }
  }
  final timeValue = Time.fromTimeOfDay(value);

  return TimeModelBinding(
    minMinuteAtCurrentHour: minMinuteAtCurrentHour,
    onChange: onChange,
    onChangeDateTime: onChangeDateTime,
    onCancel: onCancel,
    is24HrFormat: is24HrFormat,
    accentColor: accentColor,
    unselectedColor: unselectedColor,
    cancelText: cancelText,
    okText: okText,
    sunAsset: sunAsset,
    moonAsset: moonAsset,
    blurredBackground: blurredBackground,
    borderRadius: borderRadius,
    elevation: elevation,
    dialogInsetPadding: dialogInsetPadding,
    minuteInterval: minuteInterval,
    disableMinute: disableMinute,
    disableMinuteIfMaxHourSelected: disableMinuteIfMaxHourSelected,
    disableHour: disableHour,
    maxHour: maxHour,
    maxMinute: maxMinute,
    minHour: minHour,
    minMinute: minMinute,
    isInlineWidget: true,
    displayHeader: displayHeader,
    isOnValueChangeMode: isOnChangeValueMode,
    focusMinutePicker: focusMinutePicker,
    okStyle: okStyle,
    cancelStyle: cancelStyle,
    hourLabel: hourLabel,
    minuteLabel: minuteLabel,
    buttonStyle: buttonStyle,
    cancelButtonStyle: cancelButtonStyle,
    buttonsSpacing: buttonsSpacing,
    ltrMode: ltrMode,
    initialTime: timeValue,
    child: Builder(
      builder: (context) {
        {
          return Builder(
            builder: (context) {
              return Theme(
                data: themeData ?? Theme.of(context),
                child: const DayNightTimePickerAndroid(),
              );
            },
          );
        }
      },
    ),
  );
}
