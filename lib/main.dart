import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/game_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const Top10ChallengeApp());
}

class Top10ChallengeApp extends StatelessWidget {
  const Top10ChallengeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GameProvider(),
      child: MaterialApp(
        title: 'Top10 Challenge',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF6B73FF),
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          fontFamily: 'Roboto',
        ),
        home: Consumer<GameProvider>(
          builder: (context, gameProvider, child) {
            if (gameProvider.isLoading) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            return const HomeScreen();
          },
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
