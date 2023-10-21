import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/theme.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    String greeting = getGreeting();
    bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    '$greeting,',
                    style: TextStyle(
                      fontSize: 24,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    ' Joseffe!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Welcome back!',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
          const Spacer(),
          Switch(
            thumbIcon: thumbIcon(isDarkMode, context),
            value: isDarkMode,
            activeColor:
                Theme.of(context).colorScheme.onSurface.withOpacity(.2),
            inactiveThumbColor:
                Theme.of(context).colorScheme.onSurface.withOpacity(1),
            activeTrackColor: Theme.of(context).colorScheme.background,
            inactiveTrackColor: Theme.of(context).colorScheme.background,
            trackOutlineColor: MaterialStateProperty.all(isDarkMode
                ? Theme.of(context).colorScheme.surface
                : Theme.of(context).colorScheme.onSurface.withOpacity(.2)),
            onChanged: (value) {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
          ),
        ],
      ),
    );
  }

  String getGreeting() {
    int hour = DateTime.now().hour;
    String greeting;

    if (hour >= 5 && hour < 12) {
      greeting = 'Morning';
    } else if (hour >= 12 && hour < 18) {
      greeting = 'Afternoon';
    } else {
      greeting = 'Evening';
    }

    return greeting;
  }

  thumbIcon(isDarkMode, context) {
    return MaterialStateProperty.resolveWith<Icon?>(
        (Set<MaterialState> states) {
      if (!isDarkMode) {
        return Icon(
          Icons.light_mode_rounded,
          color: Theme.of(context).colorScheme.background,
        );
      }

      return const Icon(
        Icons.dark_mode_rounded,
        color: Colors.amber,
      );
    });
  }
}
