import 'package:flutter/material.dart';

class TheSlider extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;
  final double max;
  final String label;

  const TheSlider({
    Key? key,
    required this.value,
    required this.onChanged,
    required this.max,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            margin: const EdgeInsets.only(left: 8, bottom: 8),
            child: Text(label,
                style:
                    TextStyle(color: Theme.of(context).colorScheme.primary))),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Theme.of(context).colorScheme.primary,
            inactiveTrackColor: Theme.of(context).colorScheme.surface,
            thumbColor: Theme.of(context).colorScheme.primary,
            overlayColor:
                Theme.of(context).colorScheme.primary.withOpacity(0.3),
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 0),
          ),
          child: Slider(
            value: value,
            min: 0,
            max: max,
            divisions: 20,
            onChanged: onChanged,
            label: value.round().toString(),
          ),
        ),
        Container(
          alignment: Alignment.bottomRight,
          margin: const EdgeInsets.only(right: 8, top: 8),
          child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.all(8),
              child: Text(value.toString(),
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary))),
        ),
      ],
    );
  }
}
