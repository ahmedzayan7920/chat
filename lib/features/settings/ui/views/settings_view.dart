import 'package:chat/core/utils/app_routes.dart';
import 'package:flutter/material.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Column(
        children: [
          ListTile(
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.securitySettings);
            },
            leading: Icon(Icons.security_outlined),
            title: Text("Security Settings"),
          ),
        ],
      ),
    );
  }
}
