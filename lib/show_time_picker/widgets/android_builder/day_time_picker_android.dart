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

    double min = getMinMinute(
        timeState.widget.minMinute, timeState.widget.minuteInterval);
    double max = getMaxMinute(
        timeState.widget.maxMinute, timeState.widget.minuteInterval);

    int minDiff = (max - min).round();
    int divisions =
        getMinuteDivisions(minDiff, timeState.widget.minuteInterval);

    if (timeState.hourIsSelected) {
      min = timeState.widget.minHour!;
      max = timeState.widget.maxHour!;
      divisions = (max - min).round();
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
                      Slider(
                        onChangeEnd: (value) {
                          if (timeState.widget.isOnValueChangeMode) {
                            timeState.onOk();
                          }
                        },
                        value: timeState.hourIsSelected
                            ? timeState.time.hour.roundToDouble()
                            : timeState.time.minute.roundToDouble(),
                        onChanged: (value) {
                          timeState.onTimeChange(value);
                          if (timeState.hourIsSelected&&timeState.widget.minMinuteAtCurrentHour>0) {
                            if(timeState.widget.initialTime.hour==value){
                             timeState. onMinuteChange(timeState.widget.minMinuteAtCurrentHour);
                              timeState.widget.minMinute=timeState.widget.minMinuteAtCurrentHour;
                            }
                            else{
                              timeState.widget.minMinute=0;
                            }
                          }
                          if (timeState.widget.disableMinuteIfMaxHourSelected ==
                              true) {
                            if (timeState.hourIsSelected) {
                              if (value == max) {
                                timeState.widget.disableMinute = true;
                                timeState.onMinuteChange(0);
                              } else {
                                timeState.widget.disableMinute = false;
                              }
                            }
                          }
                        },
                        min: min,
                        max: max,
                        divisions: divisions,
                        activeColor: color,
                        inactiveColor: color.withAlpha(55),
                      ),
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
