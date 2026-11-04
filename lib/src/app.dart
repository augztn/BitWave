import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'features/home/home_screen.dart';
import 'features/library/library_screen.dart';
import 'features/player/player_screen.dart';
import 'features/settings/settings_screen.dart';
import 'theme/bitwave_theme.dart';

final _router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
    GoRoute(path: '/library', builder: (context, state) => const LibraryScreen()),
    GoRoute(path: '/player', builder: (context, state) => const PlayerScreen()),
    GoRoute(path: '/settings', builder: (context, state) => const SettingsScreen()),
  ],
);

class BitWaveApp extends StatelessWidget {
  const BitWaveApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        title: 'BitWave',
        debugShowCheckedModeBanner: false,
        theme: BitWaveTheme.dark(),
        routerConfig: _router,
      );
}
