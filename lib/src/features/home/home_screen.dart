import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../theme/bitwave_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 760;
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.graphic_eq_rounded, color: BitWaveTheme.accent),
            SizedBox(width: 10),
            Text('BitWave', style: TextStyle(fontWeight: FontWeight.w800)),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Settings',
            onPressed: () => context.go('/settings'),
            icon: const Icon(Icons.settings_outlined),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: ListView(
                children: [
                  Text(
                    'YOUR MUSIC,\nYOUR CLOUD.',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          height: 1.05,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -1.4,
                        ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'A personal music library powered by the Telegram chats you choose.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: BitWaveTheme.muted,
                        ),
                  ),
                  const SizedBox(height: 28),
                  _ConnectionCard(onConnect: () => context.go('/settings')),
                  const SizedBox(height: 24),
                  Text('YOUR LIBRARY', style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(height: 12),
                  GridView.count(
                    crossAxisCount: wide ? 3 : 1,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: wide ? 1.8 : 3.2,
                    children: const [
                      _FeatureCard(icon: Icons.library_music_outlined, title: 'Music library', subtitle: 'Your selected Telegram chats'),
                      _FeatureCard(icon: Icons.queue_music_rounded, title: 'Playlists & queue', subtitle: 'Keep listening your way'),
                      _FeatureCard(icon: Icons.offline_pin_outlined, title: 'Offline cache', subtitle: 'Keep recent tracks ready'),
                    ],
                  ),
                  const SizedBox(height: 26),
                  FilledButton.icon(
                    onPressed: () => context.go('/library'),
                    icon: const Icon(Icons.library_music_outlined),
                    label: const Text('Open music library'),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton.icon(
                    onPressed: () => context.go('/player'),
                    icon: const Icon(Icons.play_circle_outline_rounded),
                    label: const Text('Open player'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ConnectionCard extends StatelessWidget {
  const _ConnectionCard({required this.onConnect});
  final VoidCallback onConnect;

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: BitWaveTheme.accent.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.telegram, color: BitWaveTheme.accent, size: 30),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Connect your Telegram', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                    SizedBox(height: 4),
                    Text('Use your own account. No BitWave server or bot.', style: TextStyle(color: BitWaveTheme.muted)),
                  ],
                ),
              ),
              IconButton(onPressed: onConnect, icon: const Icon(Icons.arrow_forward_rounded)),
            ],
          ),
        ),
      );
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({required this.icon, required this.title, required this.subtitle});
  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, color: BitWaveTheme.accent, size: 28),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text(subtitle, style: const TextStyle(color: BitWaveTheme.muted, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
