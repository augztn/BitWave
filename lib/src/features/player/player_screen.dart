import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../theme/bitwave_theme.dart';

class PlayerScreen extends StatelessWidget {
  const PlayerScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Now playing'),
          leading: IconButton(onPressed: () => context.go('/'), icon: const Icon(Icons.arrow_back)),
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 260,
                    height: 260,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF31205F), Color(0xFF142D59), Color(0xFF111827)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Icon(Icons.graphic_eq_rounded, size: 94, color: Colors.white70),
                  ),
                  const SizedBox(height: 30),
                  Text('Nothing playing', style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  const Text('Choose a song from your library to start listening.', style: TextStyle(color: BitWaveTheme.muted)),
                  const SizedBox(height: 30),
                  const LinearProgressIndicator(value: 0),
                  const SizedBox(height: 12),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text('0:00'), Text('0:00')],
                  ),
                  const SizedBox(height: 12),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(Icons.shuffle_rounded, color: BitWaveTheme.muted),
                      Icon(Icons.skip_previous_rounded, size: 36),
                      Icon(Icons.play_circle_fill_rounded, size: 64, color: BitWaveTheme.accent),
                      Icon(Icons.skip_next_rounded, size: 36),
                      Icon(Icons.repeat_rounded, color: BitWaveTheme.muted),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
