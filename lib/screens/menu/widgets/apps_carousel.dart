import 'package:flutter/material.dart';

Widget appsCarousel(BuildContext context) {
  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Text(
          'Featured',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            color: Theme.of(context).colorScheme.onBackground,
            fontSize: 16,
          ),
        )),
    const SizedBox(height: 16),
    SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              item(context, '1', 'Profile', '/app01'),
              const SizedBox(width: 8),
              item(context, '2', 'Default Counter', '/app02'),
              const SizedBox(width: 8),
              // item(context, '3', 'Multiplication of 2 numbers', '/app03'),
              // const SizedBox(width: 8),
              // item(context, '4', 'Alcohol or Gasoline', '/app04'),
              // const SizedBox(width: 8),
              item(context, '3', 'BMI Calculation', '/app05'),
              const SizedBox(width: 8),
              // item(context, '6', 'Random number game', '/app06'),
            ],
          ),
        ))
  ]);
}

Widget item(BuildContext context, String number, String title, String route) {
  return GestureDetector(
    onTap: () {
      Navigator.pushNamed(context, route, arguments: {'title': title});
    },
    child: Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Theme.of(context).colorScheme.surface),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(.1),
                borderRadius: BorderRadius.circular(24)),
            child: Text(
              number,
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: Theme.of(context).colorScheme.primary,
                fontSize: 20,
              ),
            ),
          ),
          const Spacer(),
          Text(
            title,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 12,
            ),
          ),
        ],
      ),
    ),
  );
}
