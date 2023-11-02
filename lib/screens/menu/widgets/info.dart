import 'package:flutter/material.dart';

Widget info(BuildContext context) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 24),
    decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16)),
    child: Row(
      children: [
        Expanded(
          flex: 6,
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                collegeTag(context),
                const SizedBox(height: 32),
                grade(context),
                const SizedBox(height: 32),
                Text('Ishan Hegde - 9477\n',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onBackground)),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
            child: SizedBox(
              height: 216,
              child: Image.network(
                'https://images.unsplash.com/photo-1617040619263-41c5a9ca7521?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8Zmx1dHRlcnxlbnwwfHwwfHx8MA%3D%3D&w=1000&q=80',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget collegeTag(BuildContext context) {
  return Container(
    decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(.1),
        borderRadius: BorderRadius.circular(24)),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    child: Text('Current Learning - CRCE',
        style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w900,
            color: Theme.of(context).colorScheme.primary)),
  );
}

Widget grade(BuildContext context) {
  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text('FLUTTER',
        style: TextStyle(
            fontSize: 10,
            letterSpacing: 3,
            color: Theme.of(context).colorScheme.onSurface)),
    const SizedBox(height: 8),
    Text('Cross Platform Mobile Development',
        style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onBackground))
  ]);
}
