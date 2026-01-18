import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  static const id = '/';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final games = [
      (name: 'Schedule', route: '/schedule'),
      (name: 'Bill Splitter', route: '/bill-splitter'),
      (name: 'Finger Picker', route: '/finger-picker'),
      (name: 'Canvas Editor', route: '/canvas-editor'),
    ];

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            title: Text('User Interface Prototyping'),
            floating: true,
          ),
          SliverList.separated(
            itemCount: games.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final game = games[index];

              return ListTile(
                title: Text(game.name),
                onTap: () => Navigator.pushNamed(context, game.route),
              );
            },
          ),
        ],
      ),
    );
  }
}
