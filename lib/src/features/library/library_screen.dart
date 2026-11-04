import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../theme/bitwave_theme.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Music library'),
          leading: IconButton(onPressed: () => context.go('/'), icon: const Icon(Icons.arrow_back)),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.library_music_outlined, size: 58, color: BitWaveTheme.accent),
                const SizedBox(height: 18),
                Text('Your music starts here', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 8),
                const Text(
                  'Connect Telegram and select the chats that contain your music. BitWave will build a searchable library from audio messages and music files.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: BitWaveTheme.muted, height: 1.5),
                ),
                const SizedBox(height: 22),
                FilledButton.icon(
                  onPressed: () => context.go('/settings'),
                  icon: const Icon(Icons.telegram),
                  label: const Text('Connect Telegram'),
                ),
              ],
            ),
          ),
        ),
      );
}
