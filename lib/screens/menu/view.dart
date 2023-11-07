import 'package:flutter/material.dart'
    show
        BuildContext,
        Column,
        Container,
        CrossAxisAlignment,
        EdgeInsets,
        Key,
        ListView,
        Scaffold,
        SizedBox,
        StatelessWidget,
        Theme,
        Widget;
import 'package:crce_connex/screens/menu/widgets/apps_carousel.dart';
import 'package:crce_connex/screens/menu/widgets/header.dart';
import 'package:crce_connex/screens/menu/widgets/info.dart';
import 'package:crce_connex/screens/menu/widgets/apps_list.dart';

class Apps extends StatelessWidget {
  const Apps(
      {super.key,
      Key? apps,
      required Scaffold home,
      required routes,
      required theme});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: ListView(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Header(),
                const SizedBox(height: 32),
                info(context),
                const SizedBox(height: 24),
                appsCarousel(context),
                const SizedBox(height: 16),
                appsList(context),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
