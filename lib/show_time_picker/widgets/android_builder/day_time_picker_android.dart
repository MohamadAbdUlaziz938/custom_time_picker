import 'dart:ffi';

import 'package:flutter/material.dart';
import '../../state/state_container.dart';
import '../../utils/utils.dart';
import '../am_pm.dart';
import '../../common/action_button.dart';
import '../../common/display_value.dart';
import '../../common/filter_wraper.dart';
import '../../common/wraper_container.dart';
import '../../common/wraper_dialog.dart';
import '../day_night_banner.dart';

class DayNightTimePickerAndroid extends StatefulWidget {
  const DayNightTimePickerAndroid({Key? key}) : super(key: key);

  @override
  DayNightTimePickerAndroidState createState() =>
      DayNightTimePickerAndroidState();
}

class DayNightTimePickerAndroidState extends State<DayNightTimePickerAndroid> {
  @override
  Widget build(BuildContext context) {
    final timeState = TimeModelBinding.of(context);

    // double min = getMinMinute(
    //     timeState.widget.minMinute, timeState.widget.minuteInterval);
    double min = getMinMinute(timeState.widget.minMinute);

    double max =
        getMaxMinute(timeState.widget.maxMinute!, timeState.widget.minMinute!);
    double minHour = 0;

    //  timeState.minute = (max-(timeState.time.minute / 5)).toDouble();
    // int minDiff = (max - min).round();
    // int divisions =
    //     getMinuteDivisions(minDiff, timeState.widget.minuteInterval);
    int divisions = max.toInt();

    if (timeState.hourIsSelected) {
      print('============== hours =========');
      minHour = timeState.initTime.hour.toDouble();
      print('min hour');
      print(minHour);
      min = 0;
      int selectedHour = 0;
      if ((minHour) > (timeState.widget.maxHour ?? 0)) {
        print('minimum section');
        final offHours = minHour - timeState.widget.maxHour!;
        final workHours = 24 - offHours;
        divisions = workHours.toInt();
        max = workHours;
      } else {
        print('maximum section');
        final offHours = timeState.widget.maxHour! - minHour;
        divisions = offHours.toInt();
        max = offHours;
      }
      selectedHour = timeState.time.hour;
      if (timeState.time.hour == 0) {
        selectedHour = 24;
      }
      timeState.hour = (selectedHour - minHour);
      if (timeState.hour < 0) {
        selectedHour = selectedHour - 1;
        timeState.hour = (max - selectedHour);
      }
      print('=== division ===');
      print(divisions);
      print('=== time hour ===');
      print(timeState.time.hour);
      print('=== hour value ===');
      print(timeState.hour);
    } else {
      if (timeState.hour == min) {
        timeState.widget.minMinute = timeState.widget.minMinuteAtCurrentHour;
        max = getMaxMinute(
            timeState.widget.maxMinute!, timeState.widget.minMinute!);
      } else if (timeState.widget.maxHour == timeState.time.hour) {
        max = getMaxMinute(timeState.widget.maxMinuteAtMaximumHour,
            timeState.widget.minMinute!);
      }
      divisions = max.toInt();

      timeState.minute =
          (timeState.time.minute - timeState.widget.minMinute!) / 5;
      print('============== minutes =========');
      print('min minutes');
      print(timeState.widget.minMinute);
      print('max minutes');
      print(timeState.widget.maxMinute);
      print('=== division ===');
      print(divisions);
      print('=== time minute ===');
      print(timeState.time.minute);
      print('=== minute value ===');
      print(timeState.minute);
    }

    final color =
        timeState.widget.accentColor ?? Theme.of(context).colorScheme.secondary;

    final hourValue = timeState.widget.is24HrFormat
        ? timeState.time.hour
        : timeState.time.hourOfPeriod;

    final ltrMode =
        timeState.widget.ltrMode ? TextDirection.ltr : TextDirection.rtl;

    Orientation currentOrientation = MediaQuery.of(context).orientation;

    return Center(
      child: SingleChildScrollView(
        physics: currentOrientation == Orientation.portrait
            ? const NeverScrollableScrollPhysics()
            : const AlwaysScrollableScrollPhysics(),
        child: FilterWrapper(
          child: WrapperDialog(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const DayNightBanner(),
                WrapperContainer(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const AmPm(),
                      Expanded(
                        child: Row(
                          textDirection: ltrMode,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            DisplayValue(
                              onTap: timeState.widget.disableHour!
                                  ? null
                                  : () {
                                      timeState.onHourIsSelectedChange(true);
                                    },
                              value: hourValue.toString().padLeft(2, '0'),
                              isSelected: timeState.hourIsSelected,
                            ),
                            const DisplayValue(
                              value: ":",
                            ),
                            DisplayValue(
                              onTap: timeState.widget.disableMinute!
                                  ? null
                                  : () {
                                      if (max == min) {
                                        timeState.changeMaxMinute();
                                      }
                                      timeState.onHourIsSelectedChange(false);
                                    },
                              value: timeState.time.minute
                                  .toString()
                                  .padLeft(2, '0'),
                              isSelected: !timeState.hourIsSelected,
                            ),
                          ],
                        ),
                      ),
                      min != max
                          ? Slider(
                              onChangeEnd: (value) {
                                if (timeState.widget.isOnValueChangeMode) {
                                  timeState.onOk();
                                }
                              },
                              value: timeState.hourIsSelected
                                  ? timeState.hour
                                  : timeState.minute,
                              onChanged: (value) {
                                value = value.round().toDouble();
                                final int selectedValue = value.toInt();
                                if (timeState.hourIsSelected) {
                                  timeState.hour = value;
                                  final calHour = (value * 60) + (minHour * 60);
                                  if (calHour > 1440) {
                                    value = (calHour - 1440) / 60;
                                  } else {
                                    if (calHour == 1440) {
                                      value = 0;
                                    } else {
                                      value = calHour / 60;
                                    }
                                  }
                                } else {
                                  timeState.minute = value;

                                  value =
                                      (value * 5) + timeState.widget.minMinute!;
                                }

                                timeState.onTimeChange(value);

                                if (timeState.hourIsSelected) {
                                  /// selected hour equal to maximum hour check add allowed maximum minute to max minut
                                  if (selectedValue == max) {
                                    timeState.changeMinMinute(0);
                                    timeState.onMinuteChange(0);
                                    timeState.minute = 0;
                                    timeState.changeMaxMinute();
                                  }

                                  /// selected hour is current hour change min minute
                                  else if (selectedValue == min) {
                                    timeState.changeMinMinute(timeState
                                        .widget.minMinuteAtCurrentHour);
                                    timeState.onMinuteChange(timeState
                                        .widget.minMinuteAtCurrentHour);
                                    timeState.minute = 0;
                                    timeState.changeMaxMinute(maxMinute: 55);
                                  } else {
                                    timeState.changeMinMinute(0);
                                    timeState.onMinuteChange(0);
                                    timeState.minute = 0;
                                    timeState.changeMaxMinute(maxMinute: 55);
                                  }
                                }
                              },
                              min: min,
                              max: max,
                              divisions: divisions > 0 ? divisions : null,
                              activeColor: color,
                              inactiveColor: color.withAlpha(55),
                            )
                          : const SizedBox(),
                      const ActionButtons(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
