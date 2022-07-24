import 'package:custom_time_selectable/state/state_container.dart';
import 'package:flutter/material.dart';

import 'constant.dart';


class SunMoon extends StatelessWidget {
  final bool? isSun;

  const SunMoon({
    Key? key,
    this.isSun,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timeState = TimeModelBinding.of(context);
    return SizedBox(
      width: SUN_MOON_WIDTH,
      child: AnimatedSwitcher(
        switchInCurve: Curves.ease,
        switchOutCurve: Curves.ease,
        duration: const Duration(milliseconds: 250),
        child: isSun!
            ? Container(
                key: const ValueKey(1),
                child: timeState.widget.sunAsset ??
                    const Image(
                      image: AssetImage(
                        "assets/sun.png",
                      ),
                    ))
            : Container(
                key: const ValueKey(2),
                child: timeState.widget.moonAsset ??
                    const Image(
                      image: AssetImage("assets/moon.png"),
                    ),
              ),
        transitionBuilder: (child, anim) {
          return ScaleTransition(
            scale: anim,
            child: FadeTransition(
              opacity: anim,
              child: SlideTransition(
                position: anim.drive(
                  Tween(
                    begin: const Offset(0, 4),
                    end: const Offset(0, 0),
                  ),
                ),
                child: child,
              ),
            ),
          );
        },
      ),
    );
  }
}
