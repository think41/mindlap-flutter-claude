import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'providers/app_provider.dart';
import 'screens/home_screen.dart';
import 'screens/capture_screen.dart';
import 'screens/thank_you_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppProvider(),
      child: MaterialApp.router(
        title: 'MindLap Project Builder',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF19211A), // MindLap's forest green
            brightness: Brightness.light,
          ).copyWith(
            primary: const Color(0xFF19211A), // Forest green
            secondary: const Color(0xFFF0F8FF), // Alice blue
            surface: const Color(0xFFFFFFFF), // Pure white
            onPrimary: Colors.white,
            onSecondary: const Color(0xFF19211A),
            onSurface: const Color(0xFF19211A),
          ),
          useMaterial3: true,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textTheme: const TextTheme(
            // Using Inter-inspired typography
            displayLarge: TextStyle(
              fontFamily: 'Inter',
              fontSize: 32,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
            ),
            displayMedium: TextStyle(
              fontFamily: 'Inter',
              fontSize: 28,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.25,
            ),
            displaySmall: TextStyle(
              fontFamily: 'Inter',
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
            headlineLarge: TextStyle(
              fontFamily: 'Inter',
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
            headlineMedium: TextStyle(
              fontFamily: 'Inter',
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
            headlineSmall: TextStyle(
              fontFamily: 'Inter',
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
            titleLarge: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            titleMedium: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            titleSmall: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            bodyLarge: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
            bodyMedium: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            bodySmall: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
            labelLarge: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            labelMedium: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            labelSmall: TextStyle(
              fontFamily: 'Inter',
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
          cardTheme: CardThemeData(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            color: Colors.white,
            shadowColor: const Color(0xFF19211A).withOpacity(0.1),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF19211A),
              foregroundColor: Colors.white,
              elevation: 2,
              shadowColor: const Color(0xFF19211A).withOpacity(0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              textStyle: const TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF19211A),
              side: const BorderSide(color: Color(0xFF19211A), width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              textStyle: const TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Color(0xFF19211A),
            foregroundColor: Colors.white,
            elevation: 4,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Color(0xFF19211A),
            elevation: 0,
            titleTextStyle: TextStyle(
              fontFamily: 'Inter',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF19211A),
            ),
          ),
        ),
        routerConfig: _router,
      ),
    );
  }
}

final GoRouter _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/capture',
      builder: (context, state) => const CaptureScreen(),
    ),
    GoRoute(
      path: '/thank-you',
      builder: (context, state) => const ThankYouScreen(),
    ),
  ],
);
