import 'package:flutter/material.dart';

class MobileTimeBar extends StatelessWidget {
  final double min;
  final double max;
  final double value;
  final double length;
  MobileTimeBar({required this.min, required this.max, required this.value, required this.length});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          // decoration: BoxDecoration(color: Color(0xff1B1932)),
          child: SliderTheme(
              data: const SliderThemeData(
                  thumbColor: Colors.grey,
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5)),
                  child: Container(
                    width: length,
                    child: Slider(
                      value: value,
                      min: min,
                      max: max,
                      onChanged: (value) {
                      },
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
