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

    // int minDiff = (max - min).round();
    // int divisions =
    //     getMinuteDivisions(minDiff, timeState.widget.minuteInterval);
    int divisions = max.toInt();
    final double minHour = timeState.initTime.hour.toDouble();
    if (timeState.hourIsSelected) {
      min = 0;
      if ((minHour) > (timeState.widget.maxHour ?? 0)) {
        final offHours = minHour - timeState.widget.maxHour!;
        final workHours = 24 - offHours;
        divisions = workHours.toInt();
        max = workHours;
      } else {
        final offHours = timeState.widget.maxHour! - minHour;
        divisions = offHours.toInt();
        max = offHours;
      }
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
