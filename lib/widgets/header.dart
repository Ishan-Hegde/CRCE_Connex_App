import 'package:flutter/material.dart';

Widget header(BuildContext context, title) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
    child: Row(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pop(
                context); // This line navigates back to the previous screen.
          },
          child: Icon(
            Icons.chevron_left_rounded,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
            child: Text(
          title,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onBackground,
            fontSize: 16,
          ),
        ))
      ],
    ),
  );
}
