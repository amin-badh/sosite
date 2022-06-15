/// Created by Amin BADH on 15 Jun, 2022

import 'package:flutter/material.dart';

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    required this.icon,
    required this.title,
    required this.selected,
    required this.onTap,
  }) : super(key: key);

  final IconData icon;
  final String title;
  final bool selected;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: selected ? Theme.of(context).colorScheme.primary : null),
          title: Text(
            title,
            style: Theme.of(context).textTheme.bodyText1?.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                  color: selected ? Theme.of(context).colorScheme.primary : null,
                ),
          ),
          onTap: () => onTap(),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
