import 'package:flutter/material.dart';

class CustomDrawerTile extends StatelessWidget {
  const CustomDrawerTile({
    super.key,
    required this.title,
    required this.icon,
    this.onTap,
  });
  final String title;
  final IconData icon;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      iconColor: Theme.of(context).colorScheme.primary,
      textColor: Theme.of(context).colorScheme.primary,
      titleTextStyle: Theme.of(context).textTheme.titleMedium,
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }
}
