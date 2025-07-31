import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
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
            seedColor: const Color(0xFF2C5F5D),
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          textTheme: GoogleFonts.baloo2TextTheme(),
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
