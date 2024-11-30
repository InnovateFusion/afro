import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/pages/auth.dart';
import '../../features/shared/presentation/bloc/theme/theme_bloc.dart';

class DropDownMenu extends StatelessWidget {
  const DropDownMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (String value) {
        switch (value) {
          case 'Light Mode':
            context.read<ThemeBloc>().add(
                  const ChangeThemeEvent(themeMode: ThemeMode.light),
                );
            break;
          case 'Dark Mode':
            context.read<ThemeBloc>().add(
                  const ChangeThemeEvent(themeMode: ThemeMode.dark),
                );
            break;
          case 'Logout':
            context.read<AuthBloc>().add(SignOutEvent());
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const Auth(),
              ),
              (route) => false,
            );
            break;
        }
      },
      icon: Icon(
        Theme.of(context).brightness == Brightness.dark
            ? Icons.nightlight_round
            : Icons.wb_sunny,
        size: 32,
        color: Theme.of(context).colorScheme.primary,
      ),
      itemBuilder: (BuildContext context) => [
        PopupMenuItem(
          value: 'Light Mode',
          child: Row(
            children: [
              Icon(Icons.wb_sunny,
                  color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 8),
              const Text('Light Mode'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'Dark Mode',
          child: Row(
            children: [
              Icon(Icons.nightlight_round,
                  color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 8),
              const Text('Dark Mode'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'Logout',
          child: Row(
            children: [
              Icon(Icons.logout,
                  color: Theme.of(context).colorScheme.secondary),
              const SizedBox(width: 8),
              const Text('Logout'),
            ],
          ),
        ),
      ],
    );
  }
}
