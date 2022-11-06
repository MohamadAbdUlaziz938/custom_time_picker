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

    double min = getMinMinute(timeState.widget.minMinute);

    double max =
        getMaxMinute(timeState.widget.maxMinute!, timeState.widget.minMinute!);
    int divisions = max.toInt();

    if (timeState.hourIsSelected) {
      min = 0;
      max = timeState.widget.workingHours.length.toDouble() - 1;
      divisions = max.toInt();

      timeState.hour =
          timeState.widget.workingHours.indexOf(timeState.time.hour).toDouble();
      timeState.hour = timeState.hour == -1 ? 0 : timeState.hour;
    } else {
      if (timeState.hour == 0) {
        timeState.widget.minMinute = timeState.widget.minMinuteAtCurrentHour;
        max = getMaxMinute(
            timeState.widget.maxMinute!, timeState.widget.minMinute!);
      }
      if (timeState.widget.workingHours[timeState.hour.toInt()] ==
          timeState.widget.maxHour) {
        max = getMaxMinute(timeState.widget.maxMinuteAtMaximumHour,
            timeState.widget.minMinute!);
      }
      divisions = max.toInt();
      timeState.minute =
          ((timeState.time.minute - timeState.widget.minMinute!) / 5);
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
                                        timeState.changeMaxMinute(
                                            maxMinute: 55);
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
                                value = value.ceil().toDouble();
                                if (value == timeState.hour &&
                                    timeState.hourIsSelected)
                                  return;
                                else if (value == timeState.minute &&
                                    !timeState.hourIsSelected) return;

                                if (timeState.hourIsSelected) {
                                  timeState.hour = value;
                                } else {
                                  timeState.minute = value;
                                  value =
                                      (value * 5) + timeState.widget.minMinute!;
                                }

                                timeState.onTimeChange(value);

                                if (timeState.hourIsSelected) {
                                  /// selected hour equal to maximum hour check add allowed maximum minute to max minut
                                  if (value == max) {
                                    timeState.changeMinMinute(0);
                                    timeState.onMinuteChange(0);
                                    timeState.minute = 0;
                                  }

                                  /// selected hour is current hour change min minute
                                  else if (value == min) {
                                    timeState.changeMinMinute(timeState
                                        .widget.minMinuteAtCurrentHour);
                                    timeState.onMinuteChange(timeState
                                        .widget.minMinuteAtCurrentHour);

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
