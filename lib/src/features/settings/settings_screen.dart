import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../theme/bitwave_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Settings & account'),
          leading: IconButton(onPressed: () => context.go('/'), icon: const Icon(Icons.arrow_back)),
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.telegram, color: BitWaveTheme.accent, size: 28),
                        SizedBox(width: 10),
                        Text('Telegram account', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'TDLib connection is not configured yet. BitWave will use your own Telegram account and only access chats you can already open.',
                      style: TextStyle(color: BitWaveTheme.muted, height: 1.5),
                    ),
                    const SizedBox(height: 18),
                    const Text('API credentials will be entered and stored locally. Never share your API hash or login codes.'),
                    const SizedBox(height: 14),
                    const TextField(
                      enabled: false,
                      decoration: InputDecoration(labelText: 'Telegram API ID', hintText: 'Available after TDLib integration'),
                    ),
                    const SizedBox(height: 12),
                    const TextField(
                      enabled: false,
                      obscureText: true,
                      decoration: InputDecoration(labelText: 'Telegram API hash'),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Create your application at my.telegram.org/apps. Bot tokens are not used by BitWave.',
                      style: TextStyle(color: BitWaveTheme.muted, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            const ListTile(
              leading: Icon(Icons.storage_outlined),
              title: Text('Audio cache'),
              subtitle: Text('Cache controls will be available after playback integration.'),
            ),
            const ListTile(
              leading: Icon(Icons.lock_outline),
              title: Text('Privacy & session'),
              subtitle: Text('Session stays on this device. You can revoke it in Telegram → Settings → Devices.'),
            ),
          ],
        ),
      );
}
